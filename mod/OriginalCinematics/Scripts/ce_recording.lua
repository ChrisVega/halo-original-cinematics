-- Plays back a CE "recorded animation": the unit-control stream a cutscene
-- feeds a biped (throttle, facing, animation state) tick by tick at 30 Hz.
-- Format: initial unit control, initial direction controllers, then events
-- (header byte: 2-bit time delta kind, 6-bit event type).

local R = {}
R.__index = R

local unpack = string.unpack
local ANGLE = 0.0031415927 -- controller units -> radians

local EV_END, EV_ANIM_STATE, EV_AIM_SPEED, EV_FLAGS, EV_WEAPON, EV_THROTTLE = 1, 2, 3, 4, 5, 6
local EV_CHAR0, EV_SHORT0 = 7, 15

local function dir_vector(c)
    local yaw, pitch = c.yaw * ANGLE, c.pitch * ANGLE
    return { math.cos(yaw) * math.cos(pitch), math.sin(yaw) * math.cos(pitch), math.sin(pitch) }
end

-- control struct size by unit control data version (v0 fields + one field per later version)
local function control_size(version)
    local size = 1 + 1 + 2 + 2 + 2 + 8 + 12 + 12 + 12
    if version >= 1 then size = size + 4 end
    if version >= 2 then size = size + 2 end
    if version >= 3 then size = size + 2 end
    return size
end

function R.new(rec)
    local s = rec.stream
    local self = setmetatable({ rec = rec, s = s, length = rec.length, tick = 0, done = false }, R)
    local p = 1
    local c = {}
    c.animation_state, c.aiming_speed, c.flags, c.weapon = unpack("<BBi2i2", s, p)
    p = p + 6 + 2 -- + unused word
    c.throttle = { unpack("<ff", s, p) }; p = p + 8
    c.facing = { unpack("<fff", s, p) }; p = p + 12
    c.aiming = { unpack("<fff", s, p) }; p = p + 12
    c.looking = { unpack("<fff", s, p) }; p = p + 12
    p = 1 + control_size(rec.control_version)
    local fy, fp, ay, ap, ly, lp = unpack("<i2i2i2i2i2i2", s, p)
    p = p + 12
    self.ctl = c
    self.facing_c = { yaw = fy, pitch = fp }
    self.aiming_c = { yaw = ay, pitch = ap }
    self.looking_c = { yaw = ly, pitch = lp }
    self.p = p
    self.pending = 0 -- ticks left before the next event applies
    self:_read_header()
    return self
end

function R:_read_header()
    local s, p = self.s, self.p
    if p > #s then self.done = true; return end
    local h = s:byte(p)
    local kind, ev = h & 3, h >> 2
    local delta, size = 0, 1
    if kind == 1 then delta = 1
    elseif kind == 2 then delta = s:byte(p + 1); size = 2
    elseif kind == 3 then delta = unpack("<I2", s, p + 1); size = 3 end
    self.next_ev, self.next_size, self.pending = ev, size, delta
end

local function step_dir(c, dy, dp)
    c.yaw = c.yaw + dy
    if c.yaw > 1000 then c.yaw = c.yaw - 1000 elseif c.yaw < -1000 then c.yaw = c.yaw + 1000 end
    c.pitch = c.pitch + dp
end

function R:_apply()
    local s, ev, c = self.s, self.next_ev, self.ctl
    local p = self.p + self.next_size
    if ev == EV_ANIM_STATE then c.animation_state = s:byte(p); p = p + 1
    elseif ev == EV_AIM_SPEED then c.aiming_speed = s:byte(p); p = p + 1
    elseif ev == EV_FLAGS then c.flags = unpack("<i2", s, p); p = p + 2
    elseif ev == EV_WEAPON then c.weapon = unpack("<i2", s, p); p = p + 2
    elseif ev == EV_THROTTLE then c.throttle = { unpack("<ff", s, p) }; p = p + 8
    elseif ev >= EV_CHAR0 and ev < EV_CHAR0 + 16 then
        local short = ev >= EV_SHORT0
        local bits = ev - (short and EV_SHORT0 or EV_CHAR0)
        local dy, dp
        if short then dy, dp = unpack("<i2i2", s, p); p = p + 4 else dy, dp = unpack("<bb", s, p); p = p + 2 end
        if bits & 1 ~= 0 then step_dir(self.facing_c, dy, dp); c.facing = dir_vector(self.facing_c) end
        if bits & 2 ~= 0 then
            if bits & 1 ~= 0 then self.aiming_c = { yaw = self.facing_c.yaw, pitch = self.facing_c.pitch }; c.aiming = c.facing
            else step_dir(self.aiming_c, dy, dp); c.aiming = dir_vector(self.aiming_c) end
        end
        if bits & 4 ~= 0 then
            if bits & 1 ~= 0 then self.looking_c = { yaw = self.facing_c.yaw, pitch = self.facing_c.pitch }; c.looking = c.facing
            elseif bits & 2 ~= 0 then self.looking_c = { yaw = self.aiming_c.yaw, pitch = self.aiming_c.pitch }; c.looking = c.aiming
            else step_dir(self.looking_c, dy, dp); c.looking = dir_vector(self.looking_c) end
        end
    else
        self.done = true; return
    end
    self.p = p
    self:_read_header()
end

-- Advance one 30 Hz tick; returns the unit control in effect for this tick.
function R:step()
    if self.done then return self.ctl end
    while not self.done and self.pending == 0 do
        if self.next_ev == EV_END then self.done = true; break end
        self:_apply()
    end
    if not self.done then self.pending = self.pending - 1 end
    self.tick = self.tick + 1
    if self.tick >= self.length then self.done = true end
    return self.ctl
end

return R
