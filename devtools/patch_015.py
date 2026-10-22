"""One-off edit for 0.1.5: framing guard + mouth movement in ue_stage.lua."""
from pathlib import Path
p = Path(__file__).resolve().parent.parent / "mod" / "OriginalCinematics" / "Scripts" / "ue_stage.lua"
s = p.read_text(encoding="utf-8")


def rep(a, b):
    global s
    assert s.count(a) == 1, a[:80]
    s = s.replace(a, b)


rep('''    if self.cam_offset then pos.Z = pos.Z + self.cam_offset end
    self.cam:K2_SetActorLocationAndRotation(pos, rot, false, {}, true)
    -- CE stores a horizontal FOV for a 4:3 frame. Carried straight onto a
    -- widescreen frame it crops the top and bottom, which reads as a tighter,
    -- closer camera. Widen it so the vertical view is the original one.
    local fov = math.deg(c.fov)
    local cfg = self.ctx.camera or {}
    if cfg.source_aspect and cfg.target_aspect then
        fov = math.deg(2 * math.atan(math.tan(c.fov / 2) * cfg.target_aspect / cfg.source_aspect))
    end
''', '''    if self.cam_offset then pos.Z = pos.Z + self.cam_offset end
    -- CE stores a horizontal FOV for a 4:3 frame. Carried straight onto a
    -- widescreen frame it crops the top and bottom, which reads as a tighter,
    -- closer camera. Widen it so the vertical view is the original one.
    local fov = math.deg(c.fov)
    local cfg = self.ctx.camera or {}
    if cfg.source_aspect and cfg.target_aspect then
        fov = math.deg(2 * math.atan(math.tan(c.fov / 2) * cfg.target_aspect / cfg.source_aspect))
    end
    local fok, ferr = pcall(self._frame, self, pos, rot, fov, cfg)
    if not fok and not self.frame_err then self.frame_err = true; self.log("framing failed: %s", tostring(ferr)) end
    self.cam:K2_SetActorLocationAndRotation(pos, rot, false, {}, true)
''')

rep('''-- Fades ---''', '''-- Framing guard: the original shots were framed on the original Keyes; ours
-- walks and stands a little differently, so a shot can lose him. Each frame his
-- real head (last frame's Head_M) is put in camera terms; if it sits further
-- off centre than the scenes sheet allows, the camera turns just enough to
-- bring it back, and if the camera is closer to his head than allowed it backs
-- off along the line to his head (he stays at the same spot on screen). Shots
-- that are not on him (his head starts far outside the frame) are left alone.
local function wrap180(a)
    while a > 180 do a = a - 360 end
    while a < -180 do a = a + 360 end
    return a
end

function Stage:_frame(pos, rot, fov, cfg)
    local fr = cfg.framing
    local h = self.subject_head
    if not (fr and h) then return end
    -- a cut (the camera jumped) starts the guard over
    local last = self.frame_last
    if last then
        local j = math.sqrt((pos.X - last.X) ^ 2 + (pos.Y - last.Y) ^ 2 + (pos.Z - last.Z) ^ 2)
        if j > 60 then self.frame_fix = nil; self.frame_logged_shot = nil end
    end
    self.frame_last = { X = pos.X, Y = pos.Y, Z = pos.Z }
    local aspect = cfg.target_aspect or 1.7778
    local hf = fov / 2
    local hv = math.deg(math.atan(math.tan(math.rad(hf)) / aspect))
    local dx, dy, dz = h.X - pos.X, h.Y - pos.Y, h.Z - pos.Z
    local flat = math.sqrt(dx * dx + dy * dy)
    local dist = math.sqrt(flat * flat + dz * dz)
    if dist < 1 then return end
    local off_yaw = wrap180(math.deg(math.atan(dy, dx)) - rot.Yaw)
    local off_pitch = math.deg(math.atan(dz, flat)) - rot.Pitch
    local want = { yaw = 0, pitch = 0, back = 0 }
    if math.abs(off_yaw) <= hf * (fr.follow or 1.9) then
        local lim = hf * (fr.yaw_limit or 0.6)
        if off_yaw > lim then want.yaw = off_yaw - lim elseif off_yaw < -lim then want.yaw = off_yaw + lim end
        local lo, hi = -hv * (fr.pitch_low or 0.35), hv * (fr.pitch_high or 0.8)
        if off_pitch > hi then want.pitch = off_pitch - hi elseif off_pitch < lo then want.pitch = off_pitch - lo end
        local min = (math.abs(off_yaw) <= hf) and (fr.min_dist or 110) or (fr.min_dist_off or 70)
        if dist < min then want.back = min - dist end
    end
    local f = self.frame_fix
    local k = fr.smooth or 0.25
    if not f then f = { yaw = want.yaw, pitch = want.pitch, back = want.back }
    else
        f.yaw = f.yaw + (want.yaw - f.yaw) * k
        f.pitch = f.pitch + (want.pitch - f.pitch) * k
        f.back = f.back + (want.back - f.back) * k
    end
    self.frame_fix = f
    if f.back > 0.5 then
        pos.X = pos.X - dx / dist * f.back
        pos.Y = pos.Y - dy / dist * f.back
        pos.Z = pos.Z - dz / dist * f.back
    end
    rot.Yaw = rot.Yaw + f.yaw
    rot.Pitch = rot.Pitch + f.pitch
    if (math.abs(f.yaw) > 3 or math.abs(f.pitch) > 3 or f.back > 10) and not self.frame_logged_shot then
        self.frame_logged_shot = true
        self.log("framing: turned %.1f/%.1f deg, backed %.0f cm (head was %.0f/%.0f deg off, %.0f cm)",
            f.yaw, f.pitch, f.back, off_yaw, off_pitch, dist)
    end
end

-- Fades ---''')

rep('''    self.log("play %s (%s) open=%s", name, kind, tostring(ok))''', '''    self.log("play %s (%s) open=%s", name, kind, tostring(ok))
    if kind == "voice" then
        local tok, terr = pcall(self._start_talk, self, name)
        if not tok then self.log("mouth start failed: %s", tostring(terr)) end
    end''')

rep('''function Stage:_keyes(row, name)''', '''-- Mouths --------------------------------------------------------------------------
-- A voice line belongs to the character whose voice_prefix it carries
-- ("keyes02" -> keyes); while it plays his jaw opens with its loudness.
function Stage:_start_talk(name)
    local who = name:match("([%a_]+)%d*%a?$")
    if not who then return end
    for _, rep in pairs(self.reps) do
        local row = rep.row
        if row and row.voice_prefix and row.voice_prefix ~= "-" and who:find(row.voice_prefix, 1, true) == 1 then
            self.env_cache = self.env_cache or {}
            local env = self.env_cache[name]
            if env == nil then
                local wav = self.ctx.sound:wav(name)
                env = wav and require("ce_sound").envelope(wav, 30) or false
                self.env_cache[name] = env
            end
            if env then
                local peak = 0
                for _, v in ipairs(env) do if v > peak then peak = v end end
                rep.talk = { env = env, t0 = os.clock(),
                    full = math.max(0.02, math.min((row.jaw or {}).full_rms or 0.18, peak * 0.7)) }
            end
        end
    end
end

function Stage:_jaw(rep)
    local jaw = rep.row and rep.row.jaw
    if not (rep.face and jaw and jaw.bones) then return end
    if rep.jaw == nil then
        rep.jaw = false
        for _, n in ipairs(jaw.bones) do
            local idx = -1
            pcall(function() idx = rep.face:GetBoneIndex(FName(n)) end)
            if type(idx) == "number" and idx >= 0 then
                local parent
                pcall(function() parent = rep.face:GetParentBone(FName(n)):ToString() end)
                local pw = parent and world_quat(rep.face, parent)
                local jw = world_quat(rep.face, n)
                if pw and jw then
                    rep.jaw = { bone = n, parent = parent, local_q = Q.mul(Q.conj(pw), jw) }
                    self.log("mouth %s: jaw bone %s (parent %s)", rep.row.id, n, parent)
                end
                break
            end
        end
        if not rep.jaw then
            local nb = -1
            pcall(function() nb = rep.face:GetNumBones() end)
            local names = {}
            for b = 0, math.min(nb - 1, 900) do
                pcall(function()
                    local bn = rep.face:GetBoneName(b):ToString()
                    local l = bn:lower()
                    if l:find("jaw") or l:find("mouth") or l:find("lip") or l:find("chin") then names[#names + 1] = bn end
                end)
            end
            self.log("mouth %s: no jaw bone among %d face bones; jaw-like: %s", rep.row.id, nb, table.concat(names, ","))
        end
    end
    local j = rep.jaw
    if not j then return end
    local amp = 0
    local t = rep.talk
    if t then
        local i = math.floor((os.clock() - t.t0) * 30) + 1
        local v = t.env[i]
        if v then amp = math.min(1, math.max(0, (v - 0.01) / t.full)) else rep.talk = nil end
    end
    rep.jaw_amp = (rep.jaw_amp or 0) + (amp - (rep.jaw_amp or 0)) * 0.5
    local pw = world_quat(rep.face, j.parent)
    if not pw then return end
    local q = Q.mul(pw, j.local_q)
    if rep.jaw_amp > 0.02 then
        -- his left-right axis, from the actor's yaw; turned so the chin drops
        local yaw = 0
        pcall(function() yaw = math.rad(rep.actor:K2_GetActorRotation().Yaw) end)
        local fwd, right = { math.cos(yaw), math.sin(yaw), 0 }, { -math.sin(yaw), math.cos(yaw), 0 }
        if not j.sign then
            local test = Q.rotate(Q.from_axis_angle(right, math.rad(10)), fwd)
            j.sign = test[3] < 0 and 1 or -1
        end
        local open = Q.from_axis_angle(right, j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp))
        q = Q.norm(Q.mul(open, q))
    end
    rep.face:SetBoneRotationByName(FName(j.bone), Q.to_rotator(q), 0)
    if rep.jaw_amp > 0.3 and not j.logged then
        j.logged = true
        self.log("mouth %s: talking (open %.0f%%)", rep.row.id, rep.jaw_amp * 100)
    end
end

function Stage:_keyes(row, name)''')

rep('''    if ok and rep then self.reps[ev.name] = rep''', '''    if ok and rep then rep.row = row; self.reps[ev.name] = rep''')

rep('''        if rep.align then self:_align_face(rep) end
''', '''        if rep.align then self:_align_face(rep) end
        if rep.face and not rep.align then
            local jok, jerr = pcall(self._jaw, self, rep)
            if not jok and not rep.jaw_err then rep.jaw_err = true; self.log("mouth failed: %s", tostring(jerr)) end
        end
        local fr = (self.ctx.camera or {}).framing
        if fr and rep.body and rep.row and rep.row.id == fr.subject then
            pcall(function()
                local t = rep.body:GetBoneTransformByName(FName("Head_M"), 0).Translation
                self.subject_head = { X = tonumber(t.X), Y = tonumber(t.Y), Z = tonumber(t.Z) }
            end)
        end
''')
p.write_text(s, encoding="utf-8")
print("patched")
