-- Runs an original CE cutscene script (decompiled from the player's map) at
-- 30 ticks a second and keeps the scene's state: the camera, every character
-- (position, facing, animation and frame), and the sound/fade events. The
-- stage (ue_stage.lua) only draws this state; nothing here touches Unreal.

local R = require("ce_recording")

local T = {}
T.__index = T

local TICK = 1 / 30

local function lower(s) return s and s:lower() or s end

-- data: { map, scenario (ce_map:read_scenario), scripts (ce_script.read),
--         graphs = function(path) -> graph or nil, sound_ticks = function(name) -> ticks }
function T.new(data)
    local self = setmetatable({ d = data, tick = 0, threads = {}, objects = {}, events = {},
        camera = nil, cam_move = nil, ignored = {}, done = false,
        -- scenes sheet: where a flying vehicle (the Pelican) ends up, CE units, by object name
        fly_to = data.fly_to or {},
        -- scenes sheet camera = "remake": the remake's own camera (its seat, first person) stays on
        camera_remake = data.camera_remake or false,
        -- max/min are only read for scenes that ask for them; the bridge never did
        math_ops = data.math_ops or false }, T)
    self.flying = next(self.fly_to) ~= nil
    self:_index_objects()
    return self
end

-- object name -> placement (biped/scenery) with its palette tag
function T:_index_objects()
    local s = self.d.scenario
    self.placements = {}
    local function add(list, palette, kind)
        for _, p in pairs(list) do
            local nm = s.object_names[p.name]
            if nm then
                self.placements[lower(nm.name)] = { kind = kind, tag = palette[p.type], pos = p.pos, rot = p.rot }
            end
        end
    end
    add(s.bipeds, s.biped_palette, "biped")
    add(s.scenery, s.scenery_palette, "scenery")
    if s.vehicles then add(s.vehicles, s.vehicle_palette or {}, "vehicle") end
    self.all_names = {}
    for _, nm in pairs(s.object_names) do self.all_names[#self.all_names + 1] = lower(nm.name) end
end

function T:emit(ev) self.events[#self.events + 1] = ev end

function T:take_events()
    local e = self.events; self.events = {}; return e
end

-- Objects ------------------------------------------------------------------------
function T:create(name)
    name = lower(name)
    local pl = self.placements[name]
    -- a Pelican is a vehicle even when the map does not list it as placed
    local kind = pl and pl.kind or (self.flying and name:find("pelican") and "vehicle") or "unknown"
    local o = {
        name = name, kind = kind, tag = pl and pl.tag,
        pos = pl and { pl.pos[1], pl.pos[2], pl.pos[3] } or { 0, 0, 0 },
        yaw = pl and pl.rot[1] or 0, seat = "stand", scale = 1,
        base = { anim = nil, frame = 0 }, custom = nil, rec = nil,
    }
    local sf = self.start_facing and self.start_facing[name]
    if sf then o.yaw = math.rad(sf) end
    self.objects[name] = o
    self:emit({ type = "create", name = name, tag = o.tag, kind = o.kind })
    return o
end

function T:_walks_off(name)
    for _, n in ipairs((self.walk_off or {}).objects or {}) do
        if n == name then return true end
    end
end

-- walk_off: keep going (running, the flee stance) instead of stopping
function T:_run_on(o)
    -- a salute still playing finishes first
    if o.custom then o.run_after_custom = true; return end
    o.rec, o.walk_on = nil, true
    if o.panic then o.seat = "flee" end
end

function T:destroy(name, force)
    name = lower(name)
    -- walk_off (scenes sheet): deleted in the original off camera, on camera
    -- in the remake; it keeps walking straight ahead instead, until the cut
    local wo = self.walk_off
    if not force and wo and self.objects[name] then
        for _, n in ipairs(wo.objects or {}) do
            if n == name then
                self:_run_on(self.objects[name])
                return
            end
        end
    end
    if self.objects[name] then
        self.objects[name] = nil
        self:emit({ type = "destroy", name = name })
    end
end

function T:obj(name) return name and self.objects[lower(name)] end

-- Camera ---------------------------------------------------------------------------
local function lerp(a, b, t) return a + (b - a) * t end
local function lerp_angle(a, b, t)
    local d = (b - a + math.pi) % (2 * math.pi) - math.pi
    return a + d * t
end

function T:camera_set(point_name, ticks)
    -- the remake's own camera stays on (first person in the seat): the original's
    -- shots are not used for this scene
    if self.camera_remake then return end
    local p = self.d.scenario.cameras[point_name]
    if not p then self:note("camera point " .. tostring(point_name)); return end
    -- trace every cut/ move with the tick it happened on, so a camera that is
    -- at the wrong place can be matched to the script line that put it there.
    local cp = self.camera and self.camera.pos
    self:emit({ type = "note", text = string.format("camera_set %s ticks=%d at tick %d from=(%s)",
        point_name, ticks or 0, self.tick, cp and string.format("%.2f,%.2f,%.2f", cp[1], cp[2], cp[3]) or "-") })
    if self.walk_off and point_name == self.walk_off["until"] then
        for n, o in pairs(self.objects) do
            if o.walk_on then self:destroy(n, true) end
        end
    end
    local pos = p.pos
    -- shot_adjust (scenes sheet): cm along the camera's own right/up/forward
    local adj = self.shot_adjust and self.shot_adjust[point_name]
    if adj then
        local a, b = p.rot[1], p.rot[2]
        local fx, fy, fz = math.cos(a) * math.cos(b), math.sin(a) * math.cos(b), math.sin(b)
        local rx, ry = math.sin(a), -math.cos(a)
        local r, u, f = (adj.right or 0) / 304.8, (adj.up or 0) / 304.8, (adj.forward or 0) / 304.8
        pos = { pos[1] + rx * r + fx * f, pos[2] + ry * r + fy * f, pos[3] + u + fz * f }
        self:note(string.format("shot_adjust %s: right %s up %s forward %s cm", point_name,
            tostring(adj.right or 0), tostring(adj.up or 0), tostring(adj.forward or 0)))
    end
    local target = { pos = pos, rot = p.rot, fov = p.fov }
    if not self.camera or ticks <= 0 then
        self.camera = { pos = { table.unpack(pos) }, rot = { table.unpack(p.rot) }, fov = p.fov }
        self.cam_move = nil
    else
        self.cam_move = { from = { pos = { table.unpack(self.camera.pos) }, rot = { table.unpack(self.camera.rot) }, fov = self.camera.fov },
            to = target, t = 0, n = ticks,
            -- interrupting a move still under way: start at speed (chain_ease)
            chained = self.cam_move ~= nil and self.chain_ease == "out" }
    end
end

function T:_update_camera()
    local m = self.cam_move
    if not m then return end
    m.t = m.t + 1
    local k = math.min(1, m.t / m.n)
    -- Measured on the original engine (open Halo port, devtools/fit_camera_rules.py
    -- scored against its recorded camera): position and facing ease in and out
    -- together (smootherstep), angles the short way round, and a move that
    -- interrupts another starts from where the camera is.
    local function ease(u) u = math.max(0, math.min(1, u)); return u * u * u * (u * (6 * u - 15) + 10) end
    local e = ease(k)
    if m.chained then local v = 1 - k; e = 1 - v * v * v end
    local kp, kr = e, e
    local c = self.camera
    for i = 1, 3 do
        c.pos[i] = lerp(m.from.pos[i], m.to.pos[i], kp)
        c.rot[i] = lerp_angle(m.from.rot[i], m.to.rot[i], kr)
    end
    c.fov = lerp(m.from.fov, m.to.fov, kp)
    if k >= 1 then self.cam_move = nil end
end

-- Animation helpers ---------------------------------------------------------------
function T:graph_for(o)
    if not o.tag then return nil end
    local g = self.d.graphs(o.tag)
    return g
end

local function find_anim(g, name)
    if not g then return nil end
    local a = g.by_name[name]
    if a then return a end
    local ln = name:lower()
    for n, x in pairs(g.by_name) do if n:lower() == ln then return x end end
end

function T:base_anim(o, moving)
    local g = self:graph_for(o)
    local seat = o.seat or "stand"
    -- Keyes has unarmed idles; crewmen (the marine's graph) only pistol and
    -- rifle ones standing, and seated idles numbered %0 and %2.
    local what = moving and { "move-front", "move-front%0" } or { "idle%1", "idle", "idle%0", "idle%2" }
    local ok = self.d.anim_ok or function() return true end
    local seats = { seat, "stand", "alert", "flee" }
    local function look(gr, classes)
        if not gr then return nil end
        for _, st in ipairs(seats) do
            for _, wc in ipairs(classes) do
                for _, w in ipairs(what) do
                    local a = find_anim(gr, st .. " " .. wc .. " " .. w)
                    if a and ok(a) then return a end
                end
            end
        end
    end
    -- its own unarmed ones, then a borrowed graph's unarmed ones (crewmen:
    -- the captain's), then its own armed ones
    local a = look(g, { "unarmed" })
    if a then return a, g end
    local bp = self.d.borrow and self.d.borrow(o.tag)
    local bg = bp and self.d.graphs(bp)
    a = look(bg, { "unarmed" })
    if a then return a, bg end
    a = look(g, { "pistol", "rifle" })
    if a then return a, g end
end

-- Standing still, a turn of the facing larger than this (radians) turns the
-- body, at most this far per tick; smaller ones are carried by head and chest.
local BODY_TURN_AT = math.rad(70)
local BODY_TURN_RATE = math.rad(4)
local BODY_WALK_RATE = math.rad(12)

local function frame_info(map, a, f)
    if a.frame_info_type == 0 or a._ok == false then return 0, 0, 0 end
    local stride = ({ 8, 12, 16 })[a.frame_info_type]
    a._fi = a._fi or map:data(a.ptr + 72)
    local o = f * stride + 1
    if o + stride - 1 > #a._fi then return 0, 0, 0 end
    local dx, dy = string.unpack("<ff", a._fi, o)
    local dyaw = 0
    if a.frame_info_type == 2 then dyaw = string.unpack("<f", a._fi, o + 8) end
    if a.frame_info_type == 3 then dyaw = string.unpack("<f", a._fi, o + 12) end
    return dx, dy, dyaw
end

function T:_move_local(o, dx, dy)
    local c, s = math.cos(o.yaw), math.sin(o.yaw)
    o.pos[1] = o.pos[1] + c * dx - s * dy
    o.pos[2] = o.pos[2] + s * dx + c * dy
end

-- A vehicle flying a scripted route (recording_play_and_hover): a straight line
-- from where it was placed to the scenes sheet's fly_to point, eased at both
-- ends, taking the recording's length. Nose points along the line. Each tick
-- the stage gets its pose ("vehicle" event) and moves the remake's own vehicle.
function T:_update_vehicle(o)
    local f = o.fly
    if not f or not f.to then return end
    if f.t < f.n then f.t = f.t + 1 end
    local k = f.t / f.n
    local e = k * k * (3 - 2 * k)
    for i = 1, 3 do o.pos[i] = lerp(f.from[i], f.to[i], e) end
    o.yaw = f.yaw
    self:emit({ type = "vehicle", name = o.name, pos = { o.pos[1], o.pos[2], o.pos[3] }, yaw = o.yaw, t = f.t, n = f.n })
end

function T:_update_object(o)
    if o.kind == "vehicle" then return self:_update_vehicle(o) end
    if o.kind ~= "biped" then return end
    if o.custom then
        -- a scripted animation plays as animated: no look turn on top (the
        -- walk's last look twisted Keyes' neck and head as he leaned in)
        o.look_yaw = nil
        local a = o.custom.anim
        local dx, dy, dyaw = frame_info(self.d.map, a, o.custom.frame)
        self:_move_local(o, dx, dy)
        o.yaw = o.yaw + dyaw
        o.custom.frame = o.custom.frame + 1
        if o.custom.frame >= a.frame_count then
            o.custom = nil
            if o.run_after_custom then o.run_after_custom = nil; self:_run_on(o) end
        end
        return
    end
    local moving = false
    if o.rec then
        local c = o.rec:step()
        local fx, fy = c.facing[1], c.facing[2]
        local face = (fx * fx + fy * fy > 1e-6) and math.atan(fy, fx) or o.yaw
        local lx, ly = c.looking[1], c.looking[2]
        o.look_yaw = (lx * lx + ly * ly > 1e-6) and math.atan(ly, lx) or face
        local tx, ty = c.throttle[1], c.throttle[2]
        local walking = math.abs(tx) + math.abs(ty) > 0.01
        -- A standing biped keeps its feet planted: small changes of facing are
        -- a look (head, neck and chest turn), only a large one turns the body,
        -- at a walking turn's pace. Walking, the body follows the facing.
        local d = face - o.yaw
        if d ~= d or math.abs(d) > 1e6 then d = 0 end
        d = (d + math.pi) % (2 * math.pi) - math.pi
        if walking then
            -- turning into a walk: quickly, but not in one frame
            local step = math.min(math.abs(d), BODY_WALK_RATE)
            o.yaw = o.yaw + (d > 0 and step or -step)
        elseif math.abs(d) > BODY_TURN_AT then
            local step = math.min(math.abs(d) - BODY_TURN_AT * 0.5, BODY_TURN_RATE)
            o.yaw = o.yaw + (d > 0 and step or -step)
        end
        -- walk_off: past its last step (where the original slows to a stop
        -- before deleting it) it runs on instead
        o.rec_tick = (o.rec_tick or 0) + 1
        if o.run_after and o.rec_tick >= o.run_after and not o.custom then
            self:_run_on(o)
            walking = false
        end
        if walking then
            moving = true
            local a = self:base_anim(o, true)
            local speed = 0.5 / 32
            if a and a.frame_count > 0 then
                local sx = 0
                for f = 0, a.frame_count - 1 do sx = sx + (frame_info(self.d.map, a, f)) end
                if sx > 0 then speed = sx / a.frame_count end
            end
            self:_move_local(o, tx * speed, ty * speed)
        end
        if o.rec and o.rec.done then
            o.rec = nil
            if o.rec_delete then self:destroy(o.name) return end
        end
    end
    if o.walk_on then
        moving = true
        local wa = self:base_anim(o, true)
        local speed = 0.5 / 32
        if wa and wa.frame_count > 0 then
            local sx = 0
            for f = 0, wa.frame_count - 1 do sx = sx + (frame_info(self.d.map, wa, f)) end
            if sx > 0 then speed = sx / wa.frame_count end
        end
        self:_move_local(o, speed, 0)
    end
    local a, ag = self:base_anim(o, moving)
    if o.base.anim ~= a then o.base = { anim = a, frame = 0, graph = ag } end
    if a then o.base.frame = (o.base.frame + 1) % math.max(1, a.frame_count) end
end

-- Pose to draw this tick: animation + frame (custom wins over base).
function T:pose_of(o)
    if o.custom then return o.custom.anim, math.min(o.custom.frame, o.custom.anim.frame_count - 1), o.custom.graph end
    if o.base.anim then return o.base.anim, o.base.frame, o.base.graph or self:graph_for(o) end
end

-- Script evaluation ---------------------------------------------------------------
function T:note(what)
    if not self.ignored[what] then self.ignored[what] = true; self:emit({ type = "note", text = what }) end
end

local function argv(e) return e and (e.value ~= nil and e.value or e.global) end

function T:sleep_ticks(n)
    n = math.floor(tonumber(n) or 0)
    if n > 0 then coroutine.yield(n) end
end

function T:eval(e)
    if e == nil then return nil end
    if not e.fn then
        if e.global then return self:global(e.global) end
        return e.value
    end
    local f = self["hs_" .. e.fn]
    if f then return f(self, e.args) end
    local script = self.d.scripts.scripts[e.fn]
    if script then return self:eval(script.body) end
    self:note("ignored " .. e.fn)
end

function T:global(name)
    local g = self.d.scripts.globals[name]
    if g then return self:eval(g) end
end

function T:args(a) local r = {}; for i, x in ipairs(a) do r[i] = self:eval(x) end; return r end

T.hs_begin = function(self, a) local r; for _, x in ipairs(a) do r = self:eval(x) end; return r end
T.hs_if = function(self, a)
    if self:eval(a[1]) then return self:eval(a[2]) elseif a[3] then return self:eval(a[3]) end
end
T.hs_sleep = function(self, a) self:sleep_ticks(self:eval(a[1])) end
T["hs_="] = function(self, a) return self:eval(a[1]) == self:eval(a[2]) end
T["hs_-"] = function(self, a) local v = self:args(a); return (v[1] or 0) - (v[2] or 0) end
T["hs_+"] = function(self, a) local v = self:args(a); local s = 0; for _, x in ipairs(v) do s = s + (x or 0) end; return s end
-- max/min: the scripts wait "(max 0 (- (recording_time ...) 120))", so a missing
-- max made every such wait 0 and the ride ran straight through its timing
T.hs_max = function(self, a)
    if not self.math_ops then self:note("ignored max"); return nil end
    local v = self:args(a); local m = v[1]; for i = 2, #v do if v[i] and (m == nil or v[i] > m) then m = v[i] end end; return m
end
T.hs_min = function(self, a)
    if not self.math_ops then self:note("ignored min"); return nil end
    local v = self:args(a); local m = v[1]; for i = 2, #v do if v[i] and (m == nil or v[i] < m) then m = v[i] end end; return m
end
T["hs_>"] = function(self, a) local v = self:args(a); return (v[1] or 0) > (v[2] or 0) end
T["hs_<"] = function(self, a) local v = self:args(a); return (v[1] or 0) < (v[2] or 0) end
T.hs_game_difficulty_get_real = function() return "normal" end
T.hs_players = function() return nil end
T.hs_unit = function(self, a) return self:eval(a[1]) end
T.hs_list_get = function() return nil end
T.hs_player0 = function() return nil end

T.hs_wake = function(self, a)
    local name = argv(a[1])
    local s = self.d.scripts.scripts[name]
    if s then self:spawn(s.body, name) end
end

T.hs_camera_set = function(self, a) self:camera_set(argv(a[1]), self:eval(a[2]) or 0) end
T.hs_camera_time = function(self) local m = self.cam_move; return m and (m.n - m.t) or 0 end
T.hs_camera_control = function(self, a)
    if self.camera_remake then return end
    self:emit({ type = "camera_control", on = self:eval(a[1]) })
end
T.hs_cinematic_start = function(self) self:emit({ type = "cinematic_start" }) end
T.hs_cinematic_stop = function(self) self:emit({ type = "cinematic_stop" }) end
T.hs_cinematic_set_near_clip_distance = function(self, a) self:emit({ type = "near_clip", wu = self:eval(a[1]) }) end
T.hs_fade_in = function(self, a) local v = self:args(a); self:emit({ type = "fade", into = "scene", color = { v[1], v[2], v[3] }, ticks = v[4] or 0 }) end
T.hs_fade_out = function(self, a) local v = self:args(a); self:emit({ type = "fade", into = "color", color = { v[1], v[2], v[3] }, ticks = v[4] or 0 }) end

-- HaloScript's sound_impulse_time is the time LEFT before the sound finishes,
-- not its whole length. The original scripts call it once right after starting
-- a line and again later, to line the next line up with this one's end. If it
-- always answered with the full length, every later call over-waited and the
-- scene ran long (the cut after the "90 seconds" line had a long dead pause).
T.hs_sound_impulse_start = function(self, a)
    local name = argv(a[1])
    self.snd = self.snd or {}
    self.snd[name] = { start = self.tick, dur = self.d.sound_ticks(name) or 0 }
    self:emit({ type = "sound", name = name, object = argv(a[2]), scale = self:eval(a[3]) or 1 })
end
T.hs_sound_impulse_time = function(self, a)
    local e = self.snd and self.snd[argv(a[1])]
    if not e then return 0 end
    return math.max(0, e.dur - (self.tick - e.start))
end
T.hs_sound_looping_start = function(self, a) self:emit({ type = "loop", name = argv(a[1]) }) end
T.hs_sound_looping_stop = function(self, a) self:emit({ type = "loop_stop", name = argv(a[1]) }) end

T.hs_object_create = function(self, a) local n = argv(a[1]); if not self:obj(n) then self:create(n) end end
T.hs_object_create_anew = function(self, a) local n = argv(a[1]); self:destroy(n, true); self:create(n) end
T.hs_object_destroy = function(self, a) self:destroy(argv(a[1])) end
T.hs_object_create_anew_containing = function(self, a)
    local s = lower(argv(a[1]))
    for _, n in ipairs(self.all_names) do if n:find(s, 1, true) then self:destroy(n); self:create(n) end end
end
T.hs_object_destroy_containing = function(self, a)
    local s = lower(argv(a[1]))
    local kill = {}
    for n in pairs(self.objects) do if n:find(s, 1, true) then kill[#kill + 1] = n end end
    for _, n in ipairs(kill) do self:destroy(n) end
end
T.hs_object_teleport = function(self, a)
    local o = self:obj(argv(a[1]))
    local f = self.d.scenario.flags[argv(a[2])]
    if o and f then o.pos = { f.pos[1], f.pos[2], f.pos[3] }; o.yaw = f.facing[1] end
end
T.hs_object_set_scale = function(self, a) local o = self:obj(argv(a[1])); if o then o.scale = self:eval(a[2]) or 1 end end
T.hs_unit_set_seat = function(self, a) local o = self:obj(argv(a[1])); if o then o.seat = argv(a[2]) end end

-- A vehicle model's "seat" marker (chair-local, CE units), read from the map.
function T:_seat_marker(tag)
    self.seat_markers = self.seat_markers or {}
    if not tag then return nil end
    local key = lower(tag)
    if self.seat_markers[key] == nil then
        local found = false
        local map = self.d.map
        local mt = map and map.by_path and map.by_path[key .. ".mod2"]
        if mt then
            pcall(function()
                for _, m in map:each(mt.data + 0xAC, 64) do
                    if map:str32(m) == "seat" then
                        for _, inst in map:each(m + 52, 32) do
                            found = { string.unpack("<fff", map.tag_data, map:ofs(inst + 4)) }
                            break
                        end
                    end
                end
            end)
        end
        self.seat_markers[key] = found
    end
    return self.seat_markers[key] or nil
end

T.hs_vehicle_load_magic = function(self, a)
    local chair, unit = self:obj(argv(a[1])), self:obj(argv(a[3]))
    if chair and unit then
        local m = self:_seat_marker(chair.tag)
        if not m then
            -- no "seat" marker in the chair's model: the crew would be put at
            -- the chair's own origin (on the floor under it), not in the seat.
            self:note("no seat marker for " .. tostring(chair.tag))
            m = { 0, 0, 0 }
        end
        local c, s = math.cos(chair.yaw), math.sin(chair.yaw)
        local px = chair.pos[1] + m[1] * c - m[2] * s
        local py = chair.pos[2] + m[1] * s + m[2] * c
        local pz = chair.pos[3] + m[3]
        unit.pos = { px, py, pz }
        unit.seat_pos = { px, py, pz }
        unit.chair_pos = chair.pos
        unit.seat_marker = m
        unit.yaw = chair.yaw; unit.seat = "pchair-driver"; unit.seated = true
    end
end

local function start_recording(self, a, delete)
    local o = self:obj(argv(a[1]))
    local rec = self.d.scenario.recordings[argv(a[2])]
    -- a custom animation started this same tick (the salutes: salute, then walk
    -- off) plays out first; the recording waits for it. Otherwise it takes over.
    if o and rec then
        o.rec = R.new(rec); o.rec_delete = delete
        o.rec_tick, o.run_after = 0, nil
        if tostring(argv(a[2])):find("panic") then o.panic = true end
        if self:_walks_off(o.name) then
            -- the tick of its last step
            local probe, t, last = R.new(rec), 0, nil
            while not probe.done and t < 20000 do
                t = t + 1
                local c = probe:step()
                if math.abs(c.throttle[1]) + math.abs(c.throttle[2]) > 0.01 then last = t end
            end
            o.run_after = last
        end
        if not (o.custom and o.custom.frame == 0) then o.custom = nil end
    end
end
T.hs_recording_play = function(self, a) start_recording(self, a, false) end
T.hs_recording_play_and_delete = function(self, a) start_recording(self, a, true) end
T.hs_recording_kill = function(self, a) local o = self:obj(argv(a[1])); if o then o.rec = nil end end
T.hs_recording_time = function(self, a)
    local o = self:obj(argv(a[1]))
    if o and o.rec then return math.max(0, o.rec.length - o.rec.tick) end
    if o and o.fly then return math.max(0, o.fly.n - o.fly.t) end
    return 0
end

-- A vehicle's recording (the Pelican's flight): the vehicle flies its route over
-- the recording's length, hovering. A unit's recording plays as before.
T.hs_recording_play_and_hover = function(self, a)
    local o = self:obj(argv(a[1]))
    local rec = self.d.scenario.recordings[argv(a[2])]
    -- as before this scene existed: anything but a flying vehicle is not played
    local to = o and o.kind == "vehicle" and self.fly_to[lower(o.name)]
    if not (o and rec and to) then self:note("ignored recording_play_and_hover"); return end
    local from = { o.pos[1], o.pos[2], o.pos[3] }
    o.fly = { from = from, to = { to[1], to[2], to[3] }, n = math.max(1, rec.length), t = 0,
        yaw = math.atan(to[2] - from[2], to[1] - from[1]) }
    o.yaw = o.fly.yaw
end

T.hs_custom_animation = function(self, a)
    local o = self:obj(argv(a[1]))
    local g = self.d.graphs(argv(a[2]))
    local an = find_anim(g, argv(a[3]))
    -- one that reads back as garbage is skipped (the unit keeps its base pose)
    if an and self.d.anim_ok and not self.d.anim_ok(an) then self:note("bad animation " .. tostring(argv(a[3]))); an = nil end
    if o and an then o.custom = { anim = an, frame = 0, graph = g }; o.rec = nil end
    if o and tostring(argv(a[3])):find("panic") then o.panic = true end
    return o ~= nil and an ~= nil
end
T.hs_unit_stop_custom_animation = function(self, a) local o = self:obj(argv(a[1])); if o then o.custom = nil end end
T.hs_unit_get_custom_animation_time = function(self, a)
    local o = self:obj(argv(a[1]))
    if o and o.custom then return o.custom.anim.frame_count - o.custom.frame end
    return 0
end
T.hs_effect_new = function(self, a) self:emit({ type = "effect", name = argv(a[1]), flag = argv(a[2]) }) end
T.hs_cinematic_screen_effect_start = function(self) self:emit({ type = "screen_effect", on = true }) end
T.hs_cinematic_screen_effect_stop = function(self) self:emit({ type = "screen_effect", on = false }) end
T.hs_switch_bsp = function(self, a) self:emit({ type = "bsp", index = self:eval(a[1]) }) end
T.hs_game_skip_ticks = function() end

-- Threads ---------------------------------------------------------------------------
function T:spawn(body, name)
    local co = coroutine.create(function() self:eval(body) end)
    self.threads[#self.threads + 1] = { co = co, wait = 0, name = name }
end

-- script_name may list several scripts ("bridge,hangar_cryo"), run in order.
function T:start(script_name)
    local names = {}
    for n in script_name:gmatch("[^,]+") do assert(self.d.scripts.scripts[n], "no script " .. n); names[#names + 1] = n end
    self.main = script_name
    local co = coroutine.create(function()
        for _, n in ipairs(names) do self:eval(self.d.scripts.scripts[n].body) end
    end)
    self.threads[#self.threads + 1] = { co = co, wait = 0, name = script_name }
end

-- Advance one tick. Returns false once the main script has finished.
function T:step()
    self.tick = self.tick + 1
    local alive = {}
    local main_alive = false
    for _, th in ipairs(self.threads) do
        if th.wait > 0 then th.wait = th.wait - 1 end
        if th.wait == 0 and coroutine.status(th.co) ~= "dead" then
            local ok, n = coroutine.resume(th.co)
            if not ok then self:emit({ type = "error", text = th.name .. ": " .. tostring(n) }) end
            if ok and n then th.wait = n end
        end
        if coroutine.status(th.co) ~= "dead" then
            alive[#alive + 1] = th
            if th.name == self.main then main_alive = true end
        end
    end
    self.threads = alive
    self:_update_camera()
    for _, o in pairs(self.objects) do self:_update_object(o) end
    if not main_alive then self.done = true end
    return not self.done
end

T.TICK = TICK
return T
