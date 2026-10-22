-- Draws an original cutscene's state (ce_timeline) inside Campaign Evolved:
-- a camera following the original shots, the remake's own Keyes posed from the
-- original animations, a Cortana stand-in built from the player's MCC model,
-- the original voices/music through the remake's media player, and fades.

local Q = require("qmath")
local RT = require("retarget")
local CM = require("ce_model")

local Stage = {}
Stage.__index = Stage

local WU = 304.8
local function ue_pos(p) return { X = p[1] * WU, Y = -p[2] * WU, Z = p[3] * WU } end
local function ue_yaw(rad) return -math.deg(rad) end

-- A CE camera point's three angles (a, b, c) are turns about the world's axes:
-- forward = Rx(c) * Ry(-b) * Rz(a) * x, and the camera is never rolled (its up
-- follows the world's). Fitted against the original engine's own camera,
-- recorded through the open Halo port's debug_camera_save (devtools/
-- fit_ce_rotation2.py: zero error over every still shot of the a10 intro).
local function ce_camera_rot(r)
    local a, b, c = r[1], r[2], r[3]
    -- Rz(a) x = (cos a, sin a, 0); Ry(-b) tilts it up by b; Rx(c) turns about X
    local x, y, z = math.cos(a), math.sin(a), 0
    x, z = x * math.cos(b), x * math.sin(b)
    y, z = y * math.cos(c) - z * math.sin(c), y * math.sin(c) + z * math.cos(c)
    -- to Unreal: Y mirrored
    y = -y
    return { Pitch = math.deg(math.asin(math.max(-1, math.min(1, z)))), Yaw = math.deg(math.atan(y, x)), Roll = 0 }
end

local function cls(path)
    local c = StaticFindObject(path)
    assert(c and c:IsValid(), "missing class " .. path)
    return c
end

local IDENTITY = { Translation = { X = 0, Y = 0, Z = 0 }, Rotation = { X = 0, Y = 0, Z = 0, W = 1 }, Scale3D = { X = 1, Y = 1, Z = 1 } }

-- The mission's persistent world. FindFirstOf("World") can hand back a World
-- Partition streaming cell's world; actors spawned there die when the cell
-- streams out (the camera vanished ~36 s in and the game crashed).
function Stage.main_world()
    local pc = FindFirstOf("PlayerController")
    local w
    pcall(function() w = pc:GetWorld() end)
    if w and w:IsValid() then return w, pc end
    local ok, list = pcall(FindAllOf, "World")
    if ok and type(list) == "table" then
        for _, cand in ipairs(list) do
            local n = ""
            pcall(function() n = cand:GetFullName() end)
            if cand:IsValid() and n:find("/Levels/Halo1/") and not n:find("_Generated_") then return cand, pc end
        end
    end
    return FindFirstOf("World"), pc
end

-- ctx: { log, scene (ce_scene), sound (ce_sound), sheets, characters (by ce_tag lower) }
function Stage.new(ctx)
    local self = setmetatable({ ctx = ctx, log = ctx.log, actors = {}, reps = {}, players = {}, music = {}, cam_offset = nil }, Stage)
    self.world, self.pc = Stage.main_world()
    local wn = "?"
    pcall(function() wn = self.world:GetFullName() end)
    ctx.log("stage world: %s", wn)
    return self
end

-- False once anything the scene stands on has been destroyed under it.
function Stage:alive()
    local ok, v = pcall(function() return self.cam == nil or self.cam:IsValid() end)
    return ok and v
end

function Stage:spawn(class_path, loc, rot)
    local a = self.world:SpawnActor(cls(class_path), loc or { X = 0, Y = 0, Z = 0 }, rot or { Pitch = 0, Yaw = 0, Roll = 0 })
    assert(a and a:IsValid(), "spawn failed " .. class_path)
    self.actors[#self.actors + 1] = a
    return a
end

function Stage:add(actor, class_path)
    local c = actor:AddComponentByClass(cls(class_path), false, IDENTITY, false)
    assert(c and c:IsValid(), "component failed " .. class_path)
    return c
end

-- Camera ----------------------------------------------------------------------------
function Stage:begin_camera()
    pcall(function() self.prev_view = self.pc:GetViewTarget() end)
    local cam = self:spawn("/Script/Engine.CameraActor")
    self.cam = cam
    local cfg = self.ctx.camera or {}
    pcall(function()
        local cc = cam.CameraComponent
        cc.bConstrainAspectRatio = true
        cc.AspectRatio = cfg.letterbox_aspect or cfg.target_aspect or 1.7778
    end)
    pcall(function()
        local src = self:add(cam, "/Script/Engine.WorldPartitionStreamingSourceComponent")
        src:EnableStreamingSource()
    end)
    self.pc:SetViewTargetWithBlend(cam, 0, 0, 0, false)
    pcall(function()
        local hud = self.pc.MyHUD
        if hud and hud:IsValid() then
            self.prev_hud = hud.bShowHUD
            hud.bShowHUD = false
        end
    end)
    pcall(function() self.pc:SetIgnoreMoveInput(true); self.pc:SetIgnoreLookInput(true) end)
end

-- Hand the view back before the cutscene camera is destroyed, otherwise the
-- player is left looking through an actor that no longer exists.
function Stage:end_camera()
    pcall(function()
        if self.prev_hud ~= nil then
            local hud = self.pc.MyHUD
            if hud and hud:IsValid() then hud.bShowHUD = self.prev_hud end
        end
    end)
    pcall(function() self.pc:SetIgnoreMoveInput(false); self.pc:SetIgnoreLookInput(false) end)
    pcall(function()
        local prev = self.prev_view
        if prev and prev:IsValid() then
            self.pc:SetViewTargetWithBlend(prev, 0, 0, 0, false)
        else
            local pawn = self.pc.Pawn
            if pawn and pawn:IsValid() then self.pc:SetViewTargetWithBlend(pawn, 0, 0, 0, false) end
        end
    end)
    self.cam, self.prev_view, self.prev_hud = nil, nil, nil
end

function Stage:update_camera(c)
    pcall(self.check_audio, self)
    if not (self.cam and c) then return end
    if not self.cam:IsValid() then return end
    local rot = ce_camera_rot(c.rot)
    local pos = ue_pos(c.pos)
    -- Extreme close-ups (the camera inside close_cm of the original Keyes'
    -- head): the remake's face is not where the original model's is, and at
    -- 12 cm a few cm swing him out of frame. Keep the original's offset from
    -- his head by moving the camera with the difference between the heads;
    -- fades out by fade_cm, so other shots stay exactly the original's.
    local ch = self.close_head
    local cc = (self.ctx.camera or {}).closeup
    if ch and cc then
        local d = math.sqrt((pos.X - ch.ce.X) ^ 2 + (pos.Y - ch.ce.Y) ^ 2 + (pos.Z - ch.ce.Z) ^ 2)
        local w = d <= cc.close_cm and 1 or (d >= cc.fade_cm and 0 or (cc.fade_cm - d) / (cc.fade_cm - cc.close_cm))
        -- The correction is the small difference between the two heads. A
        -- bigger one means they are not the same thing (the wrong bone, a
        -- different animation) and the camera must stay where the original
        -- put it: never pull it metres away.
        local ox, oy, oz = ch.ours.X - ch.ce.X, ch.ours.Y - ch.ce.Y, ch.ours.Z - ch.ce.Z
        local off = math.sqrt(ox * ox + oy * oy + oz * oz)
        if off > 40 then
            if not self.close_too_far then
                self.close_too_far = true
                self.log("close-up: head difference %.0f cm is not a close-up difference, camera left alone", off)
            end
            w = 0
        end
        if w > 0 then
            pos.X = pos.X + ox * w
            pos.Y = pos.Y + oy * w
            pos.Z = pos.Z + oz * w
            if not self.close_logged or math.abs(self.close_logged - d) > 30 then
                self.close_logged = d
                self.log("close-up: camera %.0f cm from the original's head, moved (%.1f, %.1f, %.1f) cm", d,
                    ox * w, oy * w, oz * w)
            end
        end
    end
    -- a cut (the camera jumped): the aim starts over, scenery hidden for the
    -- last shot comes back
    local lc = self.aim_last_pos
    if not lc or math.sqrt((pos.X - lc.X) ^ 2 + (pos.Y - lc.Y) ^ 2 + (pos.Z - lc.Z) ^ 2) > 60 then
        self.aim_fix = nil
        self.shot_line_in = 3
        pcall(self._unblock_restore, self)
    end
    self.aim_last_pos = { X = pos.X, Y = pos.Y, Z = pos.Z }
    pcall(self._aim, self, pos, rot, c, ch, cc)
    if self.shot_line_in then
        self.shot_line_in = self.shot_line_in - 1
        if self.shot_line_in == 0 then pcall(self._shot_line, self, pos) end
    end
    if self.cam_offset then pos.Z = pos.Z + self.cam_offset end
    -- CE stores a horizontal FOV for a 4:3 frame; widened by target/source
    -- aspect (the scenes sheet keeps both 4:3: MCC shows the original 70 deg
    -- across, letterboxed). A constrained aspect keeps the horizontal FOV.
    local fov = math.deg(c.fov)
    local cfg = self.ctx.camera or {}
    if cfg.source_aspect and cfg.target_aspect then
        fov = math.deg(2 * math.atan(math.tan(c.fov / 2) * cfg.target_aspect / cfg.source_aspect))
    end
    local fok, ferr = pcall(self._frame, self, pos, rot, fov, cfg)
    if not fok and not self.frame_err then self.frame_err = true; self.log("framing failed: %s", tostring(ferr)) end
    self.cam:K2_SetActorLocationAndRotation(pos, rot, false, {}, true)
    pcall(function() self.cam.CameraComponent:SetFieldOfView(fov) end)
    self.last_cam = { pos = pos, rot = rot, fov = fov, aspect = cfg.letterbox_aspect or cfg.target_aspect or 1.7778 }
    local vt = self.pc:GetViewTarget()
    if not (vt and vt:IsValid() and vt:GetFName():ToString() == self.cam:GetFName():ToString()) then
        self.pc:SetViewTargetWithBlend(self.cam, 0, 0, 0, false)
    end
end

-- Framing guard: the original shots were framed on the original Keyes; ours
-- walks and stands a little differently, so a shot can lose him. Each frame his
-- real head (last frame's Head_M) is put in camera terms; if it sits further
-- off centre than the scenes sheet allows, the camera turns just enough to
-- bring it back, and if the camera is closer to his head than allowed it backs
-- off along the line to his head (he stays at the same spot on screen). Shots
-- that are not on him (his head starts far outside the frame) are left alone.
local function wrap180(a)
    if a ~= a or math.abs(a) > 1e6 then return 0 end
    a = (a + 180) % 360 - 180
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
    -- far away (another room: the hangar shots), he isn't the subject
    if dist > (fr.max_dist or 1200) then self.frame_fix = nil; return end
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

-- Fades -----------------------------------------------------------------------------
function Stage:fade(ev)
    local cm = self.pc.PlayerCameraManager
    local col = { R = ev.color[1] or 0, G = ev.color[2] or 0, B = ev.color[3] or 0, A = 1 }
    local secs = (ev.ticks or 0) / 30
    if ev.into == "color" then cm:StartCameraFade(0, 1, secs, col, false, true)
    else cm:StartCameraFade(1, 0, secs, col, false, false) end
end

-- Sound ----------------------------------------------------------------------------
-- How the remake's own cutscene audio reaches the speakers (sound class, submix,
-- AudioLink into Wwise...) is copied from its MediaSoundComponent before its
-- sequence is stopped, and applied to ours.
local COPY = { "SoundClass", "SoundSubmix", "AttenuationSettings", "SourceEffectChain", "bIsUISound",
    "bAllowSpatialization", "bOverrideAttenuation", "bEnableBusSends", "bEnableBaseSubmix",
    "bEnableSubmixSends", "Channels" }
local media_template = nil

local function prop_names(obj)
    local names = {}
    pcall(function()
        local c = obj:GetClass()
        while c and c:IsValid() do
            local cn = c:GetFName():ToString()
            if cn == "ActorComponent" or cn == "SceneComponent" or cn == "Object" then break end
            c:ForEachProperty(function(p) names[#names + 1] = p:GetFName():ToString() end)
            c = c:GetSuperStruct()
        end
    end)
    return names
end

local function show(v)
    if type(v) == "userdata" then
        local s = tostring(v)
        pcall(function() s = v:IsValid() and v:GetFullName() or "invalid" end)
        if s == tostring(v) then pcall(function() s = v:ToString() end) end
        return s
    end
    return tostring(v)
end

function Stage.capture_media_sound(log)
    local list = {}
    pcall(function() list = FindAllOf("MediaSoundComponent") or {} end)
    if type(list) ~= "table" then list = { list } end
    log("media sound components before takeover: %d", #list)
    pcall(function()
        local ak = StaticFindObject("/Script/AkAudio.Default__AkSettings")
        if ak and ak:IsValid() then log("wwise AudioRouting=%s", show(ak.AudioRouting)) end
    end)
    for i, c in ipairs(list) do
        local owner, player = "?", "?"
        pcall(function() owner = c:GetOwner():GetFName():ToString() end)
        pcall(function() player = c:GetMediaPlayer():GetFName():ToString() end)
        log("  [%d] %s owner=%s player=%s", i, show(c), owner, player)
        if i == 1 or player:find("Preroll") then
            local vals = {}
            for _, n in ipairs(prop_names(c)) do
                local ok, v = pcall(function() return c[n] end)
                if ok then
                    log("    %s = %s", n, show(v))
                    vals[n] = v
                end
            end
            if not media_template or player:find("Preroll") then media_template = { vals = vals, names = prop_names(c) } end
        end
    end
end

local function apply_template(snd, log)
    if not media_template then return end
    local n = 0
    for _, name in ipairs(media_template.names) do
        local want = false
        for _, k in ipairs(COPY) do if k == name then want = true end end
        if name:find("AudioLink") then want = true end
        local v = media_template.vals[name]
        local usable = v ~= nil
        if usable and type(v) == "userdata" then
            local okv, isv = pcall(function() return v:IsValid() end)
            usable = not okv or isv  -- plain struct/value wrappers have no IsValid
        end
        if want and usable then
            if pcall(function() snd[name] = v end) then n = n + 1 end
        end
    end
    log("sound channel: copied %d settings from the remake's movie audio", n)
end

function Stage:_channel()
    if not self.sound_actor then self.sound_actor = self:spawn("/Script/Engine.Actor") end
    local mp = StaticConstructObject(cls("/Script/MediaAssets.MediaPlayer"), self.sound_actor)
    assert(mp and mp:IsValid(), "no media player")
    pcall(function() mp.PlayOnOpen = true end)
    local snd = self:add(self.sound_actor, "/Script/MediaAssets.MediaSoundComponent")
    apply_template(snd, self.log)
    -- SetMediaPlayer keeps only a weak pointer: hold the player through the
    -- component's MediaPlayer property too, or garbage collection frees it
    -- mid-scene (the next OpenUrl on it then crashed the game).
    pcall(function() snd.MediaPlayer = mp end)
    snd:SetMediaPlayer(mp)
    pcall(function() snd:Start() end)
    return { mp = mp, snd = snd }
end

function Stage:play(name, kind, start_at)
    local file = self.ctx.sound:playable(name)
    if not file then self.log("no sound file for %s", name); return end
    -- the original script starts some lines once per marine; play it once
    self.last_play = self.last_play or {}
    local t = os.clock()
    if self.last_play[name] and t - self.last_play[name] < 0.5 then return end
    self.last_play[name] = t
    local ch
    if kind == "voice" then
        for _, c in ipairs(self.players) do
            local busy = false
            pcall(function() busy = c.mp:IsPlaying() end)
            if not busy then ch = c; break end
        end
        if not ch then ch = self:_channel(); self.players[#self.players + 1] = ch end
    else
        ch = self.music[kind]
        if not ch then ch = self:_channel(); self.music[kind] = ch end
    end
    if not ch.mp:IsValid() then
        self.log("sound channel was freed; making a new one")
        local fresh = self:_channel()
        ch.mp, ch.snd = fresh.mp, fresh.snd
    end
    local ok = ch.mp:OpenUrl("file://" .. file:gsub("\\", "/"))
    pcall(function() ch.mp:Play() end)
    -- start part-way in (music the original had already started before the
    -- part we take over): seek once the player has opened the file
    if start_at and start_at > 0 then
        self.seeks = self.seeks or {}
        self.seeks[#self.seeks + 1] = { ch = ch, at = start_at, name = name, since = os.clock() }
    end
    self.log("play %s (%s) open=%s%s", name, kind, tostring(ok), start_at and string.format(" from %.1fs", start_at) or "")
    if kind == "voice" then
        local tok, terr = pcall(self._start_talk, self, name)
        if not tok then self.log("mouth start failed: %s", tostring(terr)) end
    end
    self.audio_checks = self.audio_checks or {}
    if #self.audio_checks < 4 then
        self.audio_checks[#self.audio_checks + 1] = { ch = ch, name = name, at = os.clock() + 1.0 }
    end
end

-- A second after the first few sounds start, say whether they are really playing.
function Stage:check_audio()
    local sk = self.seeks
    if sk then
        for i = #sk, 1, -1 do
            local q = sk[i]
            local ready = false
            pcall(function() ready = q.ch.mp:IsReady() end)
            if ready or os.clock() - q.since > 3 then
                local ok = false
                -- seconds since it started count too, so it lands where the original is now
                local target = q.at + (os.clock() - q.since)
                pcall(function() ok = q.ch.mp:Seek({ Ticks = math.floor(target * 1e7) }) end)
                self.log("seek %s to %.1fs: %s", q.name, target, tostring(ok))
                table.remove(sk, i)
            end
        end
    end
    local list = self.audio_checks
    if not list then return end
    for i = #list, 1, -1 do
        local c = list[i]
        if not c.done and os.clock() >= c.at then
            c.done = true
            local playing, t, active, ac, acp, vol = "?", "?", "?", "?", "?", "?"
            pcall(function() playing = tostring(c.ch.mp:IsPlaying()) end)
            pcall(function() t = string.format("%.2f", c.ch.mp:GetTime().Ticks / 1e7) end)
            pcall(function() active = tostring(c.ch.snd:IsActive()) end)
            pcall(function() local a = c.ch.snd.AudioComponent; ac = tostring(a and a:IsValid()); acp = tostring(a:IsPlaying()) end)
            pcall(function() vol = string.format("%.2f", c.ch.snd.AudioComponent.VolumeMultiplier) end)
            local prep, ready, err, dur, pn = "?", "?", "?", "?", "?"
            pcall(function() prep = tostring(c.ch.mp:IsPreparing()) end)
            pcall(function() ready = tostring(c.ch.mp:IsReady()) end)
            pcall(function() err = tostring(c.ch.mp:HasError()) end)
            pcall(function() dur = string.format("%.2f", c.ch.mp:GetDuration().Ticks / 1e7) end)
            pcall(function() pn = c.ch.mp:GetPlayerName():ToString() end)
            self.log("audio %s: playing=%s time=%s dur=%s preparing=%s ready=%s error=%s player=%s active=%s audiocomp=%s/%s vol=%s",
                c.name, playing, t, dur, prep, ready, err, pn, active, ac, acp, vol)
        end
    end
end
-- Characters ------------------------------------------------------------------------
function Stage:character_for(tag)
    return tag and self.ctx.characters[tag:lower()]
end



local FOOT_MARKS = { "Toes", "Ankle", "Foot", "Ball", "Heel", "Sole" }

-- How a look off the body is carried (cumulative share at each bone, root to
-- tip), and the furthest the head turns before the body has to.
local LOOK_SHARE = { Spine1_M = 0.15, Chest_M = 0.35, Neck_M = 0.65, Head_M = 1.0 }
local LOOK_MAX = math.rad(80)
local function is_foot_bone(name)
    for _, m in ipairs(FOOT_MARKS) do
        if name:find(m) then return true end
    end
    return false
end

local ksl_cdo = nil
local function kismet()
    local ok = false
    if ksl_cdo then pcall(function() ok = ksl_cdo:IsValid() end) end
    if not ok then ksl_cdo = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary") end
    return ksl_cdo
end

-- Aim (scenes.aim): the remake's floors are not the original's, so where the
-- original camera looks at the original Keyes' head, ours can be a metre
-- higher (the walk to the chair). While the original's head is inside the
-- frame, the camera turns by the angle between his head and ours, so ours
-- sits where the original sat on screen. Close-ups are the closeup rule's.
function Stage:_aim(pos, rot, c, ch, cc)
    local aim = (self.ctx.camera or {}).aim
    if not (aim and ch) then return end
    local function dir(p)
        local dx, dy, dz = p.X - pos.X, p.Y - pos.Y, p.Z - pos.Z
        local flat = math.sqrt(dx * dx + dy * dy)
        return math.deg(math.atan(dy, dx)), math.deg(math.atan(dz, flat)), math.sqrt(flat * flat + dz * dz)
    end
    local y1, p1, d1 = dir(ch.ce)
    local y2, p2 = dir(ch.ours)
    local want_y, want_p = 0, 0
    local cfg = self.ctx.camera or {}
    local hf = math.deg(c.fov) / 2
    if cfg.source_aspect and cfg.target_aspect then
        hf = math.deg(math.atan(math.tan(c.fov / 2) * cfg.target_aspect / cfg.source_aspect))
    end
    local hv = math.deg(math.atan(math.tan(math.rad(hf)) / (cfg.target_aspect or 1.7778)))
    local in_frame = math.abs(wrap180(y1 - rot.Yaw)) <= hf and math.abs(p1 - rot.Pitch) <= hv
    local close = cc and d1 < (cc.fade_cm or 100)
    if in_frame and not close and d1 < 1500 then
        local m = aim.max_deg or 30
        want_y = math.max(-m, math.min(m, wrap180(y2 - y1)))
        want_p = math.max(-m, math.min(m, p2 - p1))
    end
    local f = self.aim_fix
    local k = aim.smooth or 0.2
    if not f then f = { y = want_y, p = want_p }
    else
        f.y = f.y + (want_y - f.y) * k
        f.p = f.p + (want_p - f.p) * k
    end
    self.aim_fix = f
    rot.Yaw = rot.Yaw + f.y
    rot.Pitch = rot.Pitch + f.p
    if (math.abs(f.y) > 2 or math.abs(f.p) > 2) and not self.aim_logged then
        self.aim_logged = true
        self.log("aim: turned %.1f/%.1f deg onto our Keyes (heads %.0f cm apart, %.0f cm from camera)",
            f.y, f.p, math.sqrt((ch.ours.X - ch.ce.X) ^ 2 + (ch.ours.Y - ch.ce.Y) ^ 2 + (ch.ours.Z - ch.ce.Z) ^ 2), d1)
    elseif math.abs(f.y) < 1 and math.abs(f.p) < 1 then
        self.aim_logged = nil
    end
    pcall(self._unblock, self, pos)
end

-- Unblock (scenes.unblock): remake scenery the original did not have between
-- the camera and Keyes (the display base in front of display_rev, which was a
-- see-through hologram) is hidden for the shot.
function Stage:_unblock(pos)
    local ub = (self.ctx.camera or {}).unblock
    if not ub then return end
    self.ub_frame = (self.ub_frame or 0) + 1
    if self.ub_frame % (ub.every or 10) ~= 0 then return end
    self.ub_hidden = self.ub_hidden or {}
    if #self.ub_hidden >= (ub.max_hits or 4) then return end
    local keyes
    for _, r in pairs(self.reps) do
        if r.row and r.row.id == "keyes" and r.body then keyes = r end
    end
    if not keyes then return end
    local k = kismet()
    if not k then return end
    local ignore = {}
    for _, r in pairs(self.reps) do
        local live = false
        pcall(function() live = r.actor:IsValid() end)
        if live then ignore[#ignore + 1] = r.actor end
    end
    local col = { R = 0, G = 0, B = 0, A = 0 }
    for _, bn in ipairs(ub.bones or { "Head_M" }) do
        local t = keyes.body:GetBoneTransformByName(FName(bn), 0).Translation
        local tx, ty, tz = tonumber(t.X), tonumber(t.Y), tonumber(t.Z)
        local d = math.sqrt((tx - pos.X) ^ 2 + (ty - pos.Y) ^ 2 + (tz - pos.Z) ^ 2)
        if d > 1 and d < 1500 then
            local share = ub.share or 0.8
            local endv = { X = pos.X + (tx - pos.X) * share, Y = pos.Y + (ty - pos.Y) * share, Z = pos.Z + (tz - pos.Z) * share }
            local out = {}
            local hit = k:LineTraceSingle(self.pc, { X = pos.X, Y = pos.Y, Z = pos.Z }, endv, 0, false, ignore, 0, out, true, col, col, 0)
            if hit then
                local comp
                pcall(function() comp = out.Component:Get() end)
                local ok = false
                pcall(function() ok = comp and comp:IsValid() end)
                if ok then
                    local name = "?"
                    pcall(function() name = comp:GetFullName() end)
                    comp:SetVisibility(false, false)
                    self.ub_hidden[#self.ub_hidden + 1] = comp
                    self.log("unblock: hid %s (between the camera and Keyes' %s, %.0f cm away)", name, bn, d)
                    if #self.ub_hidden >= (ub.max_hits or 4) then return end
                end
            end
        end
    end
end

function Stage:_unblock_restore()
    for _, comp in ipairs(self.ub_hidden or {}) do
        pcall(function() comp:SetVisibility(true, false) end)
    end
    if self.ub_hidden and #self.ub_hidden > 0 then self.log("unblock: %d shown again", #self.ub_hidden) end
    self.ub_hidden = {}
end


-- Lowest foot bone in the pose, in component space (cm above the actor origin).
local function posed_foot_z(rep)
    if not (rep and rep.body and rep.foot_bones) then return nil end
    local lo
    for _, bn in ipairs(rep.foot_bones) do
        local ok, z = pcall(function()
            return tonumber(rep.body:GetBoneTransformByName(FName(bn), 1).Translation.Z)
        end)
        if ok and z and (not lo or z < lo) then lo = z end
    end
    return lo
end

-- A bone's world rotation as a quaternion {x, y, z, w}.
local function world_quat(comp, bone)
    local r = comp:GetBoneTransformByName(FName(bone), 0).Rotation
    local q = { tonumber(r.X), tonumber(r.Y), tonumber(r.Z), tonumber(r.W) }
    for i = 1, 4 do if type(q[i]) ~= "number" then return nil end end
    return q
end

local function comp_quat(comp, bone)
    local r = comp:GetBoneTransformByName(FName(bone), 1).Rotation
    local q = { tonumber(r.X), tonumber(r.Y), tonumber(r.Z), tonumber(r.W) }
    for i = 1, 4 do if type(q[i]) ~= "number" then return nil end end
    return q
end

local function world_pos(comp, bone)
    local t = comp:GetBoneTransformByName(FName(bone), 0).Translation
    local v = { tonumber(t.X), tonumber(t.Y), tonumber(t.Z) }
    for i = 1, 3 do if type(v[i]) ~= "number" then return nil end end
    return v
end

local function vsub(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local function vadd(a, b) return { a[1] + b[1], a[2] + b[2], a[3] + b[3] } end

-- An object the engine has dropped: calling into it is a null pointer inside
-- the engine, and that is a crash the game cannot catch.
local function obj_ok(o)
    if not o then return false end
    local ok, v = pcall(function() return o:IsValid() end)
    return ok and v == true
end

-- Turn the face's follow bones as far as their body bones have turned.
function Stage:_follow_face(rep)
    if not (obj_ok(rep.face) and obj_ok(rep.body)) then return end
    for _, e in ipairs(rep.follow) do
        local ok, err = pcall(function()
            local b = world_quat(rep.body, e.body)
            if not b then return end
            local d = Q.mul(b, Q.conj(e.b0))
            rep.face:SetBoneRotationByName(FName(e.face), Q.to_rotator(Q.norm(Q.mul(d, e.f0))), 0)
            -- and keep it where the body bone is: rotations alone let the
            -- face drift off the neck when he bends or bobs
            if e.off then
                local bp = world_pos(rep.body, e.body)
                if bp then
                    local t = vadd(bp, Q.rotate(b, e.off))
                    rep.face:SetBoneLocationByName(FName(e.face), { X = t[1], Y = t[2], Z = t[3] }, 0)
                end
            end
        end)
        if not ok and not rep.follow_err then
            rep.follow_err = true
            self.log("face follow %s failed: %s", e.face, tostring(err))
        end
    end
end

-- Corrective bones: part of the way between how far their two neighbours
-- have turned from rest (component space).
function Stage:_fixups(rep)
    for _, f in ipairs(rep.fixups) do
        local qf, qt = comp_quat(rep.body, f.from), comp_quat(rep.body, f.to)
        if qf and qt then
            local df = Q.mul(qf, Q.conj(f.rf))
            local dt = Q.mul(qt, Q.conj(f.rt))
            local d = Q.nlerp(df, dt, f.share)
            rep.body:SetBoneRotationByName(FName(f.bone), Q.to_rotator(Q.norm(Q.mul(d, f.r))), 1)
        end
    end
end

-- Where each face follow bone sits in its body bone's frame, taken once the
-- face is aligned and both are still in their rest pose.
function Stage:_pin_face(rep)
    if not (rep.follow and rep.face) then return end
    local n = 0
    for _, e in ipairs(rep.follow) do
        pcall(function()
            local b, bp, fp = world_quat(rep.body, e.body), world_pos(rep.body, e.body), world_pos(rep.face, e.face)
            if b and bp and fp then e.off = Q.rotate(Q.conj(b), vsub(fp, bp)); n = n + 1 end
        end)
    end
    self.log("face pinned to %d body bones", n)
end

-- Mouths --------------------------------------------------------------------------
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

-- The face's lips, teeth and tongue hang off the face root, not the jaw, so
-- turning the jaw alone only drops the chin. Every bone whose name matches a
-- "with" pattern (and whose ancestors don't) is carried round the jaw's pivot
-- by the same turn, times its weight (lip corners half way).
function Stage:_mouth_group(rep, jaw_bone, with)
    local face = rep.face
    local nb = 0
    pcall(function() nb = face:GetNumBones() end)
    local names, parent_of = {}, {}
    for b = 0, nb - 1 do
        pcall(function()
            local bn = face:GetBoneName(b):ToString()
            names[#names + 1] = bn
            parent_of[bn] = face:GetParentBone(FName(bn)):ToString()
        end)
    end
    local function weight(bn)
        for _, w in ipairs(with) do
            if bn:find(w[1], 1, true) then return w[2] end
        end
    end
    local function under(bn, set)
        local p = parent_of[bn]
        local guard = 0
        while p and p ~= "None" and guard < 64 do
            if set[p] then return true end
            p = parent_of[p]; guard = guard + 1
        end
        return false
    end
    local picked = {}
    for _, bn in ipairs(names) do if bn ~= jaw_bone and weight(bn) then picked[bn] = true end end
    local group, list = {}, {}
    for bn in pairs(picked) do
        if not under(bn, picked) and not under(bn, { [jaw_bone] = true }) then
            local par = parent_of[bn]
            local pw, bw = world_quat(face, par), world_quat(face, bn)
            local pp, bp = world_pos(face, par), world_pos(face, bn)
            if pw and bw and pp and bp then
                group[#group + 1] = { bone = bn, parent = par, w = weight(bn),
                    lq = Q.mul(Q.conj(pw), bw), lp = Q.rotate(Q.conj(pw), vsub(bp, pp)) }
                list[#list + 1] = bn
            end
        end
    end
    table.sort(list)
    self.log("mouth %s: %d bones open with the jaw: %s", rep.row.id, #group, table.concat(list, ","))
    return group
end

function Stage:_jaw(rep)
    local jaw = rep.row and rep.row.jaw
    if not (rep.face and jaw and jaw.bones) then return end
    if not obj_ok(rep.face) then return end
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
                    -- his left-right axis and forward, kept in the head's own
                    -- frame, so the jaw opens the same way however the head turns
                    local yaw = 0
                    pcall(function() yaw = math.rad(rep.actor:K2_GetActorRotation().Yaw) end)
                    local fwd, right = { math.cos(yaw), math.sin(yaw), 0 }, { -math.sin(yaw), math.cos(yaw), 0 }
                    local test = Q.rotate(Q.from_axis_angle(right, math.rad(10)), fwd)
                    rep.jaw.sign = test[3] < 0 and 1 or -1
                    rep.jaw.right_local = Q.rotate(Q.conj(pw), right)
                    self.log("mouth %s: jaw bone %s (parent %s)", rep.row.id, n, parent)
                    rep.jaw.group = self:_mouth_group(rep, n, jaw.with or {})
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
    j.right = Q.rotate(pw, j.right_local)
    if rep.jaw_amp > 0.02 then
        local open = Q.from_axis_angle(j.right, j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp))
        q = Q.norm(Q.mul(open, q))
    end
    local angle = j.right and j.sign and j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp) or 0
    -- the mouth group first, from the face as it is before the jaw turns
    if j.group and #j.group > 0 then
        local pivot = world_pos(rep.face, j.bone)
        local moves = {}
        for _, g in ipairs(j.group) do
            local pw, pp = world_quat(rep.face, g.parent), world_pos(rep.face, g.parent)
            if pw and pp and pivot then
                local rq = Q.mul(pw, g.lq)
                local rp = vadd(pp, Q.rotate(pw, g.lp))
                if angle ~= 0 and rep.jaw_amp > 0.02 then
                    local r = Q.from_axis_angle(j.right, angle * g.w)
                    rq = Q.norm(Q.mul(r, rq))
                    rp = vadd(pivot, Q.rotate(r, vsub(rp, pivot)))
                end
                moves[#moves + 1] = { g.bone, rq, rp }
            end
        end
        for _, m in ipairs(moves) do
            rep.face:SetBoneLocationByName(FName(m[1]), { X = m[3][1], Y = m[3][2], Z = m[3][3] }, 0)
            rep.face:SetBoneRotationByName(FName(m[1]), Q.to_rotator(m[2]), 0)
        end
    end
    rep.face:SetBoneRotationByName(FName(j.bone), Q.to_rotator(q), 0)
    if rep.jaw_amp > 0.3 and not j.logged then
        j.logged = true
        self.log("mouth %s: talking (open %.0f%%)", rep.row.id, rep.jaw_amp * 100)
    end
end

function Stage:_keyes(row, name)
    local actor = self:spawn("/Script/Engine.Actor")
    local comps = {}
    local meshes = {}
    for i, path in ipairs(row.remake_meshes) do meshes[i] = path end
    -- a crowd: a different face and hair per object, picked by its name
    if row.variants and #row.variants > 0 then
        local h = 0
        for k = 1, #name do h = (h * 31 + name:byte(k)) % 1000003 end
        local v = row.variants[h % #row.variants + 1]
        meshes[2], meshes[3] = v[1], v[2]
    end
    for i, path in ipairs(meshes) do
        local mesh = LoadAsset(path)
        if mesh and mesh:IsValid() then
            local c = self:add(actor, "/Script/Engine.PoseableMeshComponent")
            if not pcall(function() c:SetSkinnedAssetAndUpdate(mesh, false) end) then
                pcall(function() c:SetSkeletalMesh(mesh, false) end)
            end
            comps[i] = c
        else
            self.log("mesh missing %s", path)
        end
    end
    local body = comps[1]
    assert(body, "no body mesh")
    -- Crew bodies, faces and hair are posed far from their own rest bounds
    -- (seated, running, leaning), so the engine culled them and they popped.
    -- Keyes keeps his sheet value; the crowd gets a generous box.
    local bs = row.bounds_scale or 1
    if row.id ~= "keyes" then bs = math.max(bs, 10) end
    if bs ~= 1 then
        for _, c in pairs(comps) do pcall(function() c:SetBoundsScale(bs) end) end
    end
    -- a crowd: a uniform colour per object (the remake's own division
    -- materials), on the slots that wear the default uniform
    if row.uniforms and #row.uniforms > 0 then
        local h = 7
        for k = #name, 1, -1 do h = (h * 17 + name:byte(k)) % 1000003 end
        local upath = row.uniforms[h % #row.uniforms + 1]
        local um = LoadAsset(upath)
        if um and um:IsValid() then
            local n = 0
            for _, c in pairs(comps) do
                pcall(function()
                    for slot = 0, c:GetNumMaterials() - 1 do
                        local m = c:GetMaterial(slot)
                        local mn = m and m:IsValid() and m:GetFName():ToString() or ""
                        if mn:find("NavyCrew") and not mn:find("Anatomy") and not mn:find("NamePatch") then
                            c:SetMaterial(slot, um); n = n + 1
                        end
                    end
                end)
            end
            self.log("uniform %s: %s (%d slots)", name, upath:match("([^/.]+)$") or upath, n)
        else
            self.log("uniform missing %s", upath)
        end
    end
    -- the remake rest pose in component space, for every mapped bone
    local rest = {}
    local bad_rest = 0
    for b = 0, body:GetNumBones() - 1 do
        local bn = body:GetBoneName(b):ToString()
        local t = body:GetBoneTransformByName(FName(bn), 1)
        -- UE4SS can hand a struct member back as a wrapper rather than a
        -- number on some builds; coerce, and skip a bone with no usable rest.
        local q = { tonumber(t.Rotation.X), tonumber(t.Rotation.Y), tonumber(t.Rotation.Z), tonumber(t.Rotation.W) }
        local p = { tonumber(t.Translation.X), tonumber(t.Translation.Y), tonumber(t.Translation.Z) }
        local ok = true
        for i = 1, 4 do if type(q[i]) ~= "number" then ok = false end end
        for i = 1, 3 do if type(p[i]) ~= "number" then ok = false end end
        if ok then
            rest[bn] = { rot = q, pos = p }
        else
            bad_rest = bad_rest + 1
            if bad_rest <= 5 then self.log("bone %s has no usable rest transform", bn) end
        end
    end
    if bad_rest > 0 then self.log("bones without rest transform: %d", bad_rest) end
    -- Feet in the remake's rest pose: the lowest one is the height its soles
    -- sit at above the actor origin. The posed foot is kept at that height.
    local foot_bones, rest_foot_z = {}, nil
    for bn, r in pairs(rest) do
        if is_foot_bone(bn) then
            foot_bones[#foot_bones + 1] = bn
            if not rest_foot_z or r.pos[3] < rest_foot_z then rest_foot_z = r.pos[3] end
        end
    end
    table.sort(foot_bones)
    self.log("keyes %s: feet %s, rest sole offset %.1f cm", name,
        table.concat(foot_bones, ","), rest_foot_z or -1)
    -- Save the body's rest skeleton once (names, parents, component-space
    -- rest), so the retargeting can be checked against the original offline.
    if row.id == "keyes" then pcall(function()
        local path = (os.getenv("LOCALAPPDATA") or ".") .. "/OriginalCinematics/keyes_rest.lua"
        local f = io.open(path, "wb")
        if not f then return end
        f:write("return {\n")
        for b = 0, body:GetNumBones() - 1 do
            local bn = body:GetBoneName(b):ToString()
            local parent = ""
            pcall(function() parent = body:GetParentBone(FName(bn)):ToString() end)
            local r = rest[bn]
            if r then
                f:write(string.format("  { name = %q, parent = %q, rot = { %.9g, %.9g, %.9g, %.9g }, pos = { %.6g, %.6g, %.6g } },\n",
                    bn, parent, r.rot[1], r.rot[2], r.rot[3], r.rot[4], r.pos[1], r.pos[2], r.pos[3]))
            end
        end
        f:write("}\n"); f:close()
        self.log("saved Keyes' rest skeleton to %s", path)
    end) end
    -- Put each part where the remake's own BP_KeyesBipedActor has it (face on
    -- the body with no socket, turned part_yaw; hair and brows on the face),
    -- while the body is still in its rest pose. Then hang the face off the
    -- body's head bone keeping that placement, so it follows the head and
    -- spine from there. (Snapping it straight onto Head_M without the remake's
    -- turn twisted his neck.)
    local parents, yaws = row.part_parent or {}, row.part_yaw or {}
    for i = 2, #comps do
        local c, parent = comps[i], comps[parents[i] or 1] or body
        if c then
            pcall(function()
                c:K2_AttachToComponent(parent, FName("None"), 0, 0, 0, true)
                c:K2_SetRelativeLocationAndRotation({ X = 0, Y = 0, Z = 0 },
                    { Pitch = 0, Yaw = yaws[i] or 0, Roll = 0 }, false, {}, true)
            end)
        end
    end
    -- Line the face's own head bone up with the body's: placed by the remake's
    -- turn alone it sat low and forward, the head sunk into the collar. Done on
    -- the first scene frame, not here: at create time the face component's
    -- bones are not readable yet and the alignment failed silently, which left
    -- the face sunk in the collar in every run.
    local align = nil
    if comps[2] and row.align_bones and #row.align_bones == 2 then
        align = { face = comps[2], fb = row.align_bones[1], bb = row.align_bones[2], yaw = yaws[2] or 0, tries = 0 }
    end
    -- Parts on another part's skeleton follow its pose (hair and brows the
    -- face's; hands and sleeves the body's).
    local leaders = row.part_leader
    for i = 2, #comps do
        local p = (leaders and #leaders > 0) and (leaders[i] or 0) or ((parents[i] or 1) > 1 and parents[i] or 0)
        if comps[i] and p > 0 and comps[p] then
            pcall(function() comps[i]:SetLeaderPoseComponent(comps[p], true, false) end)
        end
    end
    -- The face is a MetaHuman mesh with its own full skeleton (pelvis, spine_*,
    -- neck_*, head): its neck skin is weighted to those bones, not to Head_M.
    -- It stays on the body like the remake's, and each frame its follow bones
    -- turn by exactly as much as the matching body bones have turned from rest
    -- (world space), so the neck bends with the collar.
    local follow = nil
    if comps[2] and row.follow_bones and #row.follow_bones > 0 then
        follow = {}
        for _, pair in ipairs(row.follow_bones) do
            local ok, e = pcall(function()
                return { body = pair[1], face = pair[2],
                    b0 = world_quat(body, pair[1]), f0 = world_quat(comps[2], pair[2]) }
            end)
            if ok and e.b0 and e.f0 then follow[#follow + 1] = e
            else self.log("face follow %s->%s unavailable", pair[1], pair[2]) end
        end
        self.log("face follows %d body bones", #follow)
    else
        local head = row.attach_bone == "leader" and "Head_M" or row.attach_bone
        for i = 2, #comps do
            if comps[i] and (parents[i] or 1) == 1 then
                pcall(function() comps[i]:K2_AttachToComponent(body, FName(head), 1, 1, 1, true) end)
            end
        end
    end
    local scene = self.ctx.scene
    local g = scene:graph(row.ce_tag)
    local mt = scene.map.by_path[row.ce_tag .. ".mod2"]
    local model = mt and CM.read(scene.map, mt)
    local rows = {}
    for _, r in ipairs(self.ctx.sheets.bone_map) do if r.rig == row.rig then rows[#rows + 1] = r end end
    local rt = (g and model) and RT.new(g.nodes, model.nodes, rows, rest) or nil
    self.log("keyes %s: %d meshes, %d bones mapped", name, #comps, rt and #rt.map or 0)
    -- corrective bones (fixups sheet) with their rest rotations
    local fixups = {}
    for _, f in ipairs(self.ctx.sheets.fixups or {}) do
        if f.rig == row.rig and rest[f.bone] and rest[f.from] and rest[f.to] then
            fixups[#fixups + 1] = { bone = f.bone, from = f.from, to = f.to, share = f.share,
                r = rest[f.bone].rot, rf = rest[f.from].rot, rt = rest[f.to].rot }
        end
    end
    if #fixups > 0 then self.log("%s: %d corrective bones", name, #fixups) end
    return { kind = "skinned", actor = actor, body = body, rt = rt, graph = g, face = follow and comps[2], fixups = fixups,
        follow = follow, align = align, foot_bones = foot_bones, rest_foot_z = rest_foot_z }
end

function Stage:_ce_model(row, name)
    local scene = self.ctx.scene
    local path = row.ce_tag
    local mt = scene.map.by_path[path .. ".mod2"]
    assert(mt, "no CE model " .. path)
    local model = CM.read(scene.map, mt, 4)
    local actor = self:spawn("/Script/Engine.Actor")
    local pm = self:add(actor, "/Script/ProceduralMeshComponent.ProceduralMeshComponent")
    local mat = row.material ~= "-" and LoadAsset(row.material) or nil
    -- A tinted instance when the sheet gives a colour (BasicShapeMaterial's
    -- "Color"): the glyph hologram only drew its pattern, so she looked see-through.
    if mat and mat:IsValid() and row.tint and #row.tint == 3 then
        pcall(function()
            local mlib = StaticFindObject("/Script/Engine.Default__KismetMaterialLibrary")
            local dyn = mlib:CreateDynamicMaterialInstance(self.pc, mat, FName("None"), 0)
            if dyn and dyn:IsValid() then
                dyn:SetVectorParameterValue(FName("Color"), { R = row.tint[1], G = row.tint[2], B = row.tint[3], A = 1 })
                mat = dyn
            end
        end)
    end
    -- The CE hologram model is stored a little under a third of human size;
    -- the original renders it full size, so scale it up to match.
    local scale = row.model_scale or 1
    for si, part in ipairs(model.parts) do
        local verts, normals, uvs, tris = {}, {}, {}, {}
        for v = 0, part.vcount - 1 do
            local x = part.verts[v]
            verts[#verts + 1] = { X = x.pos[1] * WU * scale, Y = -x.pos[2] * WU * scale, Z = x.pos[3] * WU * scale }
            normals[#normals + 1] = { X = x.normal[1], Y = -x.normal[2], Z = x.normal[3] }
            uvs[#uvs + 1] = { X = x.uv[1], Y = x.uv[2] }
        end
        for _, t in ipairs(part.tris) do
            -- mirrored geometry: reverse the winding; and draw the back faces
            -- too (the strips' winding is not consistent, which left holes)
            tris[#tris + 1] = t[1]; tris[#tris + 1] = t[3]; tris[#tris + 1] = t[2]
            tris[#tris + 1] = t[1]; tris[#tris + 1] = t[2]; tris[#tris + 1] = t[3]
        end
        pm:CreateMeshSection_LinearColor(si - 1, verts, tris, normals, uvs, {}, {}, {}, {}, {}, false, false)
        if mat and mat:IsValid() then pcall(function() pm:SetMaterial(si - 1, mat) end) end
    end
    self.log("ce model %s for %s: %d parts", path, name, #model.parts)
    return { kind = "rigid", actor = actor }
end

-- A holographic material for an H2A texture: the sheet's translucent unlit
-- material with the picture and tint; its fallback tinted when it is missing.
function Stage:_holo_material(h2, tex)
    self.holo_mats = self.holo_mats or {}
    if self.holo_mats[tex] ~= nil then return self.holo_mats[tex] or nil end
    local mlib = StaticFindObject("/Script/Engine.Default__KismetMaterialLibrary")
    local rlib = StaticFindObject("/Script/Engine.Default__KismetRenderingLibrary")
    local tint = h2.tint or { 0.6, 0.45, 1, 0.85 }
    local col = { R = tint[1], G = tint[2], B = tint[3], A = tint[4] or 1 }
    local made, how = nil, "none"
    if h2.use ~= "tinted" then pcall(function()
        local base = LoadAsset(h2.material)
        if not (base and base:IsValid()) then return end
        local png = (self.ctx.cache or "") .. "\\h2a_" .. tex .. (h2.png_suffix or "") .. ".png"
        local t = rlib:ImportFileAsTexture2D(self.pc, png)
        if not (t and t:IsValid()) then return end
        local dyn = mlib:CreateDynamicMaterialInstance(self.pc, base, FName("None"), 0)
        dyn:SetTextureParameterValue(FName(h2.texture_param), t)
        dyn:SetVectorParameterValue(FName(h2.tint_param), col)
        made, how = dyn, "hologram"
    end) end
    if not made then
        pcall(function()
            local base = LoadAsset(h2.fallback_material)
            local dyn = mlib:CreateDynamicMaterialInstance(self.pc, base, FName("None"), 0)
            local ft = h2.fallback_tint
            dyn:SetVectorParameterValue(FName("Color"), ft and { R = ft[1], G = ft[2], B = ft[3], A = ft[4] or 1 } or col)
            made, how = dyn, "tinted"
        end)
    end
    self.log("h2a material for %s: %s", tex, how)
    self.holo_mats[tex] = made or false
    return made
end

-- Cortana (or anyone with an h2a row) from the player's Halo 2 Anniversary
-- files, posed by the original's animations (cortana_h2a.lua).
function Stage:_h2a(row, name)
    local H = require("h2a")
    local CH = require("cortana_h2a")
    local h2 = row.h2a
    local h = assert(H.open(self.ctx.mcc .. "\\halo2\\preload\\paks\\shared.pck"))
    local keep = {}
    for _, i in ipairs(h2.parts or {}) do keep[i] = true end
    local tpl, err = h:template(h2.tpl, function(sm, i) return keep[i] end)
    h:close()
    assert(tpl, err)
    local scene = self.ctx.scene
    local g = scene:graph(row.ce_tag)
    local mt = scene.map.by_path[row.ce_tag .. ".mod2"]
    local model = mt and CM.read(scene.map, mt)
    assert(g and model, "no CE graph/model for " .. row.ce_tag)
    local sk = CH.new(tpl, g.nodes, model.nodes, function(m) self.log("%s", m) end)
    local actor = self:spawn("/Script/Engine.Actor")
    local pm = self:add(actor, "/Script/ProceduralMeshComponent.ProceduralMeshComponent")
    local R, P = sk:solve(nil, 0)
    -- "ce": as tall as the original's model (her shots are framed for it)
    local scale = tonumber(h2.scale) or 1
    if h2.scale == "ce" then
        local ce_top, ce_bot = -1e9, 1e9
        for _, part in ipairs(model.parts or {}) do
            for v = 0, (part.vcount or 0) - 1 do
                local z = part.verts[v].pos[3]
                if z > ce_top then ce_top = z end
                if z < ce_bot then ce_bot = z end
            end
        end
        local top, bot = -1e9, 1e9
        for _, list in ipairs(sk:skin(R, P, 1)) do
            for _, v in ipairs(list) do
                if v.Z > top then top = v.Z end
                if v.Z < bot then bot = v.Z end
            end
        end
        if ce_top > ce_bot and top > bot then scale = (ce_top - ce_bot) * WU / (top - bot) end
        self.log("h2a %s: original %.0f cm tall, remastered %.0f cm (feet at %.0f) -> scale %.3f",
            name, (ce_top - ce_bot) * WU, top - bot, bot, scale)
    end
    local vs = sk:skin(R, P, scale)
    for si, part in ipairs(sk.parts) do
        local tris, uvs = {}, {}
        for _, t in ipairs(part.tris) do
            -- mirrored into Unreal's frame: reverse the winding; and both
            -- sides, the hologram is see-through
            tris[#tris + 1] = t[1] - 1; tris[#tris + 1] = t[3] - 1; tris[#tris + 1] = t[2] - 1
            tris[#tris + 1] = t[1] - 1; tris[#tris + 1] = t[2] - 1; tris[#tris + 1] = t[3] - 1
        end
        for i = 1, #part.verts do local uv = part.uvs[i] or { 0, 0 }; uvs[i] = { X = uv[1], Y = uv[2] } end
        -- normals (from her rest shape): a lit material on a mesh without
        -- them draws it black
        local nrm = {}
        local vv = vs[si]
        for i = 1, #vv do nrm[i] = { 0, 0, 0 } end
        for _, t in ipairs(part.tris) do
            local a, b, c = vv[t[1]], vv[t[3]], vv[t[2]]
            if a and b and c then
                local ux, uy, uz = b.X - a.X, b.Y - a.Y, b.Z - a.Z
                local wx, wy, wz = c.X - a.X, c.Y - a.Y, c.Z - a.Z
                local nx, ny, nz = uy * wz - uz * wy, uz * wx - ux * wz, ux * wy - uy * wx
                for _, k in ipairs({ t[1], t[2], t[3] }) do
                    local n = nrm[k]; n[1] = n[1] + nx; n[2] = n[2] + ny; n[3] = n[3] + nz
                end
            end
        end
        local normals = {}
        for i = 1, #vv do
            local n = nrm[i]
            local l = math.sqrt(n[1] * n[1] + n[2] * n[2] + n[3] * n[3])
            normals[i] = l > 1e-9 and { X = n[1] / l, Y = n[2] / l, Z = n[3] / l } or { X = 0, Y = 0, Z = 1 }
        end
        local white = {}
        for i = 1, #vv do white[i] = { R = 1, G = 1, B = 1, A = 1 } end
        -- "vertex": her texture's colours painted onto her points (sampled at
        -- each point's UV), drawn with the engine's vertex colour material
        local vmat = nil
        if h2.use == "vertex" then
            local f = io.open((self.ctx.cache or "") .. "\\h2a_" .. part.mat.texture .. ".vtx2.rgba", "rb")
            local px = f and f:read("a"); if f then f:close() end
            if px and #px >= 256 * 256 * 4 then
                for i = 1, #vv do
                    local uv = part.uvs[i] or { 0, 0 }
                    local u, v = uv[1] % 1, uv[2] % 1
                    local o = (math.floor(v * 255) * 256 + math.floor(u * 255)) * 4
                    local r, g, b = px:byte(o + 1, o + 3)
                    -- linear colour for the engine
                    white[i] = { R = (r / 255) ^ 2.2, G = (g / 255) ^ 2.2, B = (b / 255) ^ 2.2, A = 1 }
                end
                -- kept for the hologram shimmer (_holo_colors): her colours and
                -- each point's rest height
                self.holo_base = self.holo_base or {}
                local hb = { cols = white, z = {} }
                for i = 1, #vv do hb.z[i] = vv[i].Z end
                self.holo_base[si] = hb
                vmat = self.vertex_mat
                if vmat == nil then
                    vmat = LoadAsset(h2.vertex_material)
                    if not (vmat and vmat:IsValid()) then vmat = false end
                    self.vertex_mat = vmat
                    self.log("h2a vertex material %s: %s", h2.vertex_material, vmat and "ok" or "missing")
                end
            else
                self.log("h2a vertex colours missing for %s", part.mat.texture)
            end
        end
        pm:CreateMeshSection_LinearColor(si - 1, vv, tris, normals, uvs, {}, {}, {}, white, {}, false, false)
        local mat = vmat or self:_holo_material(h2, part.mat.texture)
        if mat then pcall(function() pm:SetMaterial(si - 1, mat) end) end
    end
    self.log("h2a %s for %s: %d parts", h2.tpl, name, #sk.parts)
    local holo = self.holo_base; self.holo_base = nil
    return { kind = "h2a", actor = actor, pm = pm, sk = sk, scale = scale, holo = holo, holo_cfg = h2.shimmer }
end

-- Loudness-driven mouth opening (0..1) of whoever is speaking on rep.
local function talk_amp(rep)
    local amp = 0
    local t = rep.talk
    if t then
        local i = math.floor((os.clock() - t.t0) * 30) + 1
        local v = t.env[i]
        if v then amp = math.min(1, math.max(0, (v - 0.01) / t.full)) else rep.talk = nil end
    end
    rep.jaw_amp = (rep.jaw_amp or 0) + (amp - (rep.jaw_amp or 0)) * 0.5
    return rep.jaw_amp
end

-- Pose an h2a character for this tick (at most every other frame).
-- The original's hologram look on her painted colours: bright bands of light
-- sweeping up her body, a fine scanline pattern and a faint flicker
-- (h2a.shimmer in the characters sheet).
function Stage:_holo_colors(rep, si)
    local hb = rep.holo and rep.holo[si]
    local c = rep.holo_cfg
    if not (hb and c) then return nil end
    local t = os.clock()
    local flick = 1 - c.flicker * (0.5 + 0.5 * math.sin(t * 23.0) * math.sin(t * 7.3))
    local out = {}
    local band_pos = (t * c.band_speed) % c.band_every
    for i = 1, #hb.cols do
        local z = hb.z[i] or 0
        local d = (z - band_pos) % c.band_every
        local band = math.exp(-(d * d) / (2 * c.band_width * c.band_width))
        local line = 1 - c.scanline * (0.5 + 0.5 * math.sin(z * c.scanline_freq))
        local k = (c.base + c.band * band) * line * flick
        local b = hb.cols[i]
        out[i] = { R = b.R * k, G = b.G * k, B = b.B * k, A = 1 }
    end
    return out
end

function Stage:_pose_h2a(rep, o, tl)
    self.frame_no = self.frame_no or 0
    local anim, frame = tl:pose_of(o)
    local amp = talk_amp(rep)
    local key = tostring(anim) .. ":" .. tostring(frame) .. ":" .. math.floor(amp * 8)
    if self.frame_no - (rep.posed_at or -9) < 2 then return end
    if key == rep.posekey then
        -- same pose: only the hologram shimmer moves
        if rep.holo and rep.last_vs then
            for si = 1, #rep.last_vs do
                local cols = self:_holo_colors(rep, si)
                if cols then rep.pm:UpdateMeshSection_LinearColor(si - 1, rep.last_vs[si], {}, {}, {}, {}, {}, cols, {}, false) end
            end
            rep.posed_at = self.frame_no
        end
        return
    end
    rep.posekey, rep.posed_at = key, self.frame_no
    local frames = anim and self.ctx.scene:frames(anim)
    local f = frames and frames[frame]
    local jaw = math.rad(((rep.row and rep.row.jaw) or {}).max_deg or 12) * amp
    local t0 = os.clock()
    local R, P = rep.sk:solve(f, jaw)
    local vs = rep.sk:skin(R, P, rep.scale)
    rep.last_vs = vs
    for si = 1, #vs do
        rep.pm:UpdateMeshSection_LinearColor(si - 1, vs[si], {}, {}, {}, {}, {}, self:_holo_colors(rep, si) or {}, {}, false)
    end
    rep.pose_count = (rep.pose_count or 0) + 1
    if rep.pose_count == 1 or rep.pose_count == 30 then
        self.log("h2a pose %d took %.1f ms (anim %s)", rep.pose_count, (os.clock() - t0) * 1000, anim and anim.name or "-")
    end
end

function Stage:create(ev)
    for _, n in ipairs(self.ctx.skip_objects or {}) do
        if n == ev.name then return end
    end
    local row = self:character_for(ev.tag)
    if not row then return end
    local ok, rep = pcall(function()
        if #row.remake_meshes > 0 then return self:_keyes(row, ev.name) end
        if row.fallback == "h2a" and row.h2a and row.h2a.tpl then
            local hok, hrep = pcall(self._h2a, self, row, ev.name)
            if hok then return hrep end
            self.log("h2a %s failed, using the original model: %s", ev.name, tostring(hrep))
            return self:_ce_model(row, ev.name)
        end
        if row.fallback == "ce_model" then return self:_ce_model(row, ev.name) end
    end)
    if ok and rep then rep.row = row; self.reps[ev.name] = rep
    elseif not ok then self.log("create %s failed: %s", ev.name, tostring(rep)) end
end

function Stage:destroy(name)
    self.log("script destroys %s", tostring(name))
    local rep = self.reps[name]
    if rep then
        pcall(function() rep.actor:K2_DestroyActor() end); self.reps[name] = nil
        -- out of the spawned list too: a destroyed actor handed back to the
        -- engine (the floor trace's ignore list) crashed the game
        for i = #self.actors, 1, -1 do
            if rawequal(self.actors[i], rep.actor) then table.remove(self.actors, i) end
        end
    end
end

-- Shot line (survey): a few frames after every cut, what the remake has
-- between the camera and our Keyes (head and hips), by line trace: the mesh,
-- and how far from the camera. Ours are ignored.
function Stage:_shot_line(pos)
    local k = kismet()
    if not k then return end
    local keyes
    for _, r in pairs(self.reps) do
        if r.row and r.row.id == "keyes" and r.body then keyes = r end
    end
    if not keyes then return end
    local ignore = {}
    for _, r in pairs(self.reps) do
        local live = false
        pcall(function() live = r.actor:IsValid() end)
        if live then ignore[#ignore + 1] = r.actor end
    end
    local col = { R = 0, G = 0, B = 0, A = 0 }
    local parts = {}
    for _, bn in ipairs({ "Head_M", "Root_M" }) do
        local t = keyes.body:GetBoneTransformByName(FName(bn), 0).Translation
        local tx, ty, tz = tonumber(t.X), tonumber(t.Y), tonumber(t.Z)
        local d = math.sqrt((tx - pos.X) ^ 2 + (ty - pos.Y) ^ 2 + (tz - pos.Z) ^ 2)
        local out = {}
        local hit = k:LineTraceSingle(self.pc, { X = pos.X, Y = pos.Y, Z = pos.Z }, { X = tx, Y = ty, Z = tz }, 0, false, ignore, 0, out, true, col, col, 0)
        if hit then
            local m, hx, hy, hz = "?", 0, 0, 0
            pcall(function() local c = out.Component:Get(); m = c:GetFName():ToString(); pcall(function() m = c.StaticMesh:GetFName():ToString() end) end)
            pcall(function() hx, hy, hz = tonumber(out.Location.X), tonumber(out.Location.Y), tonumber(out.Location.Z) end)
            parts[#parts + 1] = string.format("%s BLOCKED by %s at (%.0f,%.0f,%.0f), %.0f of %.0f cm", bn, m, hx, hy, hz,
                math.sqrt((hx - pos.X) ^ 2 + (hy - pos.Y) ^ 2 + (hz - pos.Z) ^ 2), d)
        else
            parts[#parts + 1] = string.format("%s clear (%.0f cm)", bn, d)
        end
    end
    self.log("shot line from (%.0f,%.0f,%.0f): %s", pos.X, pos.Y, pos.Z, table.concat(parts, "; "))
end

-- Survey (once per scene): a scan of the remake's bridge by line traces only
-- (reading mesh components directly crashed the game in 0.2.80). Straight down
-- every 50 cm over the bridge: the height and the name of what is hit (floor,
-- chair, console), to find the remake's chairs and floors and fit them against
-- the original's (devtools/fit_bridge.py). Written to
-- %LOCALAPPDATA%/OriginalCinematics/survey_remake.tsv.
function Stage:survey()
    local k = kismet()
    if not k then return end
    local path = (os.getenv("LOCALAPPDATA") or ".") .. "/OriginalCinematics/survey_remake.tsv"
    local f = io.open(path, "wb")
    if not f then return end
    local ignore = {}
    for _, a in ipairs(self.actors or {}) do
        local live = false
        pcall(function() live = a:IsValid() end)
        if live then ignore[#ignore + 1] = a end
    end
    local col = { R = 0, G = 0, B = 0, A = 0 }
    local g = 0
    for x = -2200, 1700, 50 do
        for y = -1600, 1600, 50 do
            local out = {}
            local ok, hit = pcall(function()
                return k:LineTraceSingle(self.pc, { X = x, Y = y, Z = 200 }, { X = x, Y = y, Z = -450 }, 0, false, ignore, 0, out, true, col, col, 0)
            end)
            if ok and hit then
                local z, cname, mname = 0, "?", "?"
                pcall(function() z = tonumber(out.Location.Z) or 0 end)
                pcall(function()
                    local c = out.Component:Get()
                    cname = c:GetFName():ToString()
                    pcall(function() mname = c.StaticMesh:GetFName():ToString() end)
                end)
                f:write(string.format("HIT\t%d\t%d\t%.1f\t%s\t%s\n", x, y, z, mname, cname))
                g = g + 1
            end
        end
    end
    f:close()
    self.log("survey: %d trace hits -> %s", g, path)
end

-- The remake places its own Keyes on the bridge at the original's spot; ours
-- would overlap it (two heads, two bodies). Hide it for the scene, and take
-- its feet as the remake's floor height for ours.
function Stage:hide_remake_cast()
    self.hidden = self.hidden or {}
    local list = {}
    for _, cn in ipairs(self.ctx.hide or { "BP_KeyesBipedActor_C" }) do
        local ok, found = pcall(FindAllOf, cn)
        if ok and found then
            if type(found) ~= "table" then found = { found } end
            for _, a in ipairs(found) do list[#list + 1] = a end
        end
    end
    for _, a in ipairs(list) do
        pcall(function()
            if a:IsValid() then
                local l = a:K2_GetActorLocation()
                self.remake_keyes = { X = l.X, Y = l.Y, Z = l.Z }
                a:SetActorHiddenInGame(true)
                self.hidden[#self.hidden + 1] = a
            end
        end)
    end
    if self.remake_keyes then
        self.log("hid the remake's Keyes (%d) at (%.0f, %.0f, %.0f)", #self.hidden,
            self.remake_keyes.X, self.remake_keyes.Y, self.remake_keyes.Z)
    end
end

-- Height of the remake's own floor under the actor, from the game's collision:
-- one downward trace, ignoring the actor itself. The bridge rises about a metre
-- along Keyes' walk, so this is asked every frame instead of fixed once.
function Stage:_trace_floor(rep, x, y, z, from)
    local k = kismet()
    if not k then return nil end
    local startv = { X = x, Y = y, Z = z + (from or 300) }
    local endv = { X = x, Y = y, Z = z - 500 }
    local out = {}
    local ignore = { rep.actor }
    if ((rep.row or {}).floor or {}).ignore_cast then
        -- the cast that is alive right now (never a destroyed actor)
        for _, r in pairs(self.reps) do
            if r ~= rep and r.actor then
                local live = false
                pcall(function() live = r.actor:IsValid() end)
                if live then ignore[#ignore + 1] = r.actor end
            end
        end
    end
    for _, a in ipairs(self.hidden or {}) do
        local live = false
        pcall(function() live = a:IsValid() end)
        if live then ignore[#ignore + 1] = a end
    end
    local col = { R = 0, G = 0, B = 0, A = 0 }
    local ok, was = pcall(function()
        return k:LineTraceSingle(self.pc, startv, endv, 0, false, ignore, 0, out, true, col, col, 0)
    end)
    if not ok then
        self.trace_errors = (self.trace_errors or 0) + 1
        if self.trace_errors <= 3 then self.log("floor trace failed: %s", tostring(was)) end
        return nil
    end
    if not was then
        self.trace_misses = (self.trace_misses or 0) + 1
        if self.trace_misses <= 3 then
            self.log("floor trace: nothing under (%.0f, %.0f, %.0f)", x, y, z)
        end
        return nil
    end
    local hz
    pcall(function() hz = tonumber(out.Location.Z) end)
    if not hz then
        if not self.trace_no_z then self.trace_no_z = true; self.log("floor trace: hit with no Location") end
        return nil
    end
    if not self.trace_ok then
        self.trace_ok = true
        self.log("floor trace: first floor at %.1f cm under the actor", hz)
    end
    return hz
end

-- Put the face's head bone where the body's head bone is (see _keyes). Runs on
-- the first scene frames; logs why if it cannot, instead of failing silently.
function Stage:_align_face(rep)
    local a = rep.align
    if not (obj_ok(a.face) and obj_ok(rep.body)) then rep.align = nil; return end
    local ok, err = pcall(function()
        local fp = a.face:GetBoneTransformByName(FName(a.fb), 0).Translation
        local bp = rep.body:GetBoneTransformByName(FName(a.bb), 0).Translation
        local d = { X = bp.X - fp.X, Y = bp.Y - fp.Y, Z = bp.Z - fp.Z }
        a.face:K2_SetRelativeLocationAndRotation(d, { Pitch = 0, Yaw = a.yaw, Roll = 0 }, false, {}, true)
        self.log("face aligned: moved (%.1f, %.1f, %.1f) cm so %s meets %s", d.X, d.Y, d.Z, a.fb, a.bb)
        local nf = a.face:GetBoneTransformByName(FName("neck_01"), 0).Translation
        local nb = rep.body:GetBoneTransformByName(FName("Neck_M"), 0).Translation
        self.log("after: face neck_01 vs body Neck_M off (%.1f, %.1f, %.1f) cm", nf.X - nb.X, nf.Y - nb.Y, nf.Z - nb.Z)
    end)
    if ok then
        rep.align = nil
        self:_pin_face(rep)
    else
        a.tries = a.tries + 1
        if a.tries == 1 or a.tries == 60 then self.log("face align try %d failed: %s", a.tries, tostring(err)) end
        if a.tries >= 60 then rep.align = nil end
    end
end

-- Shot check: where a point sits in the current frame, as -1..1 across
-- (left to right) and down (top to bottom); nil when it is behind the camera.
local function to_screen(c, pt)
    local dx, dy, dz = pt.X - c.pos.X, pt.Y - c.pos.Y, pt.Z - c.pos.Z
    local yw, pc = math.rad(c.rot.Yaw), math.rad(c.rot.Pitch)
    -- camera axes (Unreal: X forward, Y right, Z up; rotator pitch positive up)
    local fx, fy, fz = math.cos(pc) * math.cos(yw), math.cos(pc) * math.sin(yw), math.sin(pc)
    local rx, ry = -math.sin(yw), math.cos(yw)
    local ux, uy, uz = -math.sin(pc) * math.cos(yw), -math.sin(pc) * math.sin(yw), math.cos(pc)
    local f = dx * fx + dy * fy + dz * fz
    if f < 1 then return nil end
    local r = dx * rx + dy * ry
    local u = dx * ux + dy * uy + dz * uz
    local th = math.tan(math.rad(c.fov / 2))
    local roll = math.rad(c.rot.Roll or 0)
    local sx, sy = r / f / th, -u / f / th * c.aspect
    return sx * math.cos(roll) + sy * math.sin(roll), -sx * math.sin(roll) + sy * math.cos(roll), f
end

-- Every cut and every 15 frames: for each cast member, the original's position
-- (from the map) against ours, and where the head lands on screen if ours stood
-- exactly at the original's spot versus where it does. "shot" lines in the log.
function Stage:_shot_check(tl)
    local c = self.last_cam
    if not c then return end
    local cut = false
    local lp = self.shot_last
    if lp and math.sqrt((c.pos.X - lp.X) ^ 2 + (c.pos.Y - lp.Y) ^ 2 + (c.pos.Z - lp.Z) ^ 2) > 60 then cut = true end
    self.shot_last = { X = c.pos.X, Y = c.pos.Y, Z = c.pos.Z }
    if not cut and (self.frame_no % 15) ~= 0 then return end
    self.log("shot t=%d%s cam (%.0f,%.0f,%.0f) yaw %.1f pitch %.1f roll %.1f fov %.1f", tl.tick or -1, cut and " CUT" or "",
        c.pos.X, c.pos.Y, c.pos.Z, c.rot.Yaw, c.rot.Pitch, c.rot.Roll or 0, c.fov)
    for name, rep in pairs(self.reps) do
        local o = tl.objects[name]
        if o and o.pos and rep.body then
            pcall(function()
                local want = ue_pos(o.pos)
                local a = rep.actor:K2_GetActorLocation()
                local h = rep.body:GetBoneTransformByName(FName("Head_M"), 0).Translation
                local hw = { X = want.X + (h.X - a.X), Y = want.Y + (h.Y - a.Y), Z = want.Z + (h.Z - a.Z) }
                local ax, ay, d1 = to_screen(c, h)
                local bx, by = to_screen(c, hw)
                local fmt = function(x, y) return x and string.format("%.2f,%.2f", x, y) or "behind" end
                self.log("shot   %s: orig (%.0f,%.0f,%.0f) ours (%.0f,%.0f,%.0f) off %.0f cm; head on screen ours %s orig %s, %.0f cm from camera",
                    name, want.X, want.Y, want.Z, a.X, a.Y, a.Z,
                    math.sqrt((a.X - want.X) ^ 2 + (a.Y - want.Y) ^ 2 + (a.Z - want.Z) ^ 2),
                    fmt(ax, ay), fmt(bx, by), d1 or -1)
            end)
        end
    end
end

function Stage:update_objects(tl)
    self.frame_no = (self.frame_no or 0) + 1
    pcall(self._shot_check, self, tl)
    for name, rep in pairs(self.reps) do
        if rep.align then self:_align_face(rep) end
        rep.frames_alive = (rep.frames_alive or 0) + 1
        if rep.face and rep.frames_alive == 300 then
            pcall(function()
                local fh = rep.face:GetBoneTransformByName(FName("head"), 0).Translation
                local bh = rep.body:GetBoneTransformByName(FName("Head_M"), 0).Translation
                local fc = rep.face:K2_GetComponentLocation()
                self.log("face check %s: face head (%.0f,%.0f,%.0f) body Head_M (%.0f,%.0f,%.0f) face comp (%.0f,%.0f,%.0f) visible %s",
                    name, fh.X, fh.Y, fh.Z, bh.X, bh.Y, bh.Z, fc.X, fc.Y, fc.Z, tostring(rep.face:IsVisible()))
            end)
        end
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
        local o = tl.objects[name]
        -- where the original Keyes' head is (its own model posed by the same
        -- frame) against ours, for the close-up rule in update_camera
        if o and rep.row and rep.row.id == "keyes" and rep.rt and rep.rt.last_W and rep.body then
            pcall(function()
                -- The head node is looked up by name in the animation that is
                -- playing, every frame. The node list belongs to the graph of
                -- that animation and it changes with it (the lean's graph is
                -- not the walk's), so an index kept from before pointed at
                -- another bone: the original's head was read from the wrong
                -- place and the camera was pulled metres away, which is when
                -- Keyes' face went missing.
                local hi
                for i, n in pairs(rep.rt.nodes) do
                    if n.name == "bip01 head" then hi = i; break end
                end
                if not hi then
                    for i, n in pairs(rep.rt.nodes) do
                        if n.name and n.name:lower():find("head") then hi = i; break end
                    end
                end
                if hi and hi ~= rep.ce_head_node then
                    rep.ce_head_node = hi
                    self.log("close-up: original head node %s", rep.rt.nodes[hi].name)
                end
                local w = hi and rep.rt.last_W[hi]
                if w then
                    local cy, sy = math.cos(o.yaw), math.sin(o.yaw)
                    local hx, hy, hz = w.pos[1], w.pos[2], w.pos[3]
                    local ce = ue_pos({ o.pos[1] + cy * hx - sy * hy, o.pos[2] + sy * hx + cy * hy, o.pos[3] + hz })
                    local t = rep.body:GetBoneTransformByName(FName("Head_M"), 0).Translation
                    -- Mode 0 is the bone's world transform (the same one the
                    -- mod's own world_pos helper uses), so this is already in
                    -- the world and needs no extra component offset.
                    self.close_head = { ce = ce, ours = { X = tonumber(t.X), Y = tonumber(t.Y), Z = tonumber(t.Z) } }
                    -- How far our head is from the original's, every second,
                    -- whatever is playing: this is what decides whether his
                    -- face is in the shot.
                    if self.frame_no % 30 == 0 then
                        local dx = tonumber(t.X) - ce.X
                        local dy = tonumber(t.Y) - ce.Y
                        local dz = tonumber(t.Z) - ce.Z
                        self.log("head diff %s: ours (%.0f,%.0f,%.0f) orig (%.0f,%.0f,%.0f) apart %.0f cm; actor (%.0f,%.0f,%.0f) anim %s rec %s",
                            name, tonumber(t.X), tonumber(t.Y), tonumber(t.Z), ce.X, ce.Y, ce.Z,
                            math.sqrt(dx * dx + dy * dy + dz * dz),
                            ue_pos(o.pos).X, ue_pos(o.pos).Y, ue_pos(o.pos).Z,
                            tostring(o.custom and o.custom.anim and o.custom.anim.name),
                            tostring(o.rec and o.rec.name))
                    end
                    -- in-game check of the pose against the original model's:
                    -- hands and head, every second while a scripted animation plays
                    if o.custom and self.frame_no % 30 == 0 then
                        local parts = {}
                        for _, pr in ipairs({ { "bip01 l hand", "Wrist_L" }, { "bip01 r hand", "Wrist_R" }, { "bip01 head", "Head_M" } }) do
                            local ni
                            for i, n in pairs(rep.rt.nodes) do if n.name == pr[1] then ni = i end end
                            local wn = ni and rep.rt.last_W[ni]
                            if wn then
                                local ox, oy, oz = wn.pos[1], wn.pos[2], wn.pos[3]
                                local c = ue_pos({ o.pos[1] + cy * ox - sy * oy, o.pos[2] + sy * ox + cy * oy, o.pos[3] + oz })
                                local b = rep.body:GetBoneTransformByName(FName(pr[2]), 0).Translation
                                parts[#parts + 1] = string.format("%s orig (%.0f,%.0f,%.0f) ours (%.0f,%.0f,%.0f)", pr[2],
                                    c.X, c.Y, c.Z, b.X, b.Y, b.Z)
                            end
                        end
                        self.log("pose check %s %s: %s", name, tostring(o.custom.anim and o.custom.anim.name), table.concat(parts, "; "))
                        -- Where the face sits against the body's head. The
                        -- face is a mesh of its own: when the body's hips
                        -- move (the lean), the face has to move with them or
                        -- it is left behind and his face goes for a moment.
                        if rep.face then
                            pcall(function()
                                local fh = rep.face:GetBoneTransformByName(FName("head"), 0).Translation
                                local bh = rep.body:GetBoneTransformByName(FName("Head_M"), 0).Translation
                                local d = math.sqrt((fh.X - bh.X) ^ 2 + (fh.Y - bh.Y) ^ 2 + (fh.Z - bh.Z) ^ 2)
                                self.log("face seam %s: face (%.0f,%.0f,%.0f) body (%.0f,%.0f,%.0f) apart %.0f cm",
                                    name, fh.X, fh.Y, fh.Z, bh.X, bh.Y, bh.Z, d)
                            end)
                        end
                    end
                end
            end)
        end
        local valid = false
        pcall(function() valid = rep.actor:IsValid() and (not rep.body or rep.body:IsValid()) end)
        if not valid then
            self.reps[name] = nil
            self.log("%s was destroyed under the scene", name)
            o = nil
        end
        local p, yaw
        if o then
            p = ue_pos(o.pos)
            yaw = ue_yaw(o.yaw)
            pcall(function()
                rep.actor:K2_SetActorLocationAndRotation(p, { Pitch = 0, Yaw = yaw, Roll = 0 }, false, {}, true)
            end)
            -- a seated body's face is lined up before the first pose: measured
            -- after it, the hips have already dropped into the chair and the
            -- face is pinned inside him
            if rep.kind == "skinned" and rep.rt and not (rep.align and o.seated) then
                if not obj_ok(rep.body) then return end
                local anim, frame, agraph = tl:pose_of(o)
                if anim and anim._ok == false then anim = nil end
                if anim and (rep.anim ~= anim or rep.frame ~= frame) then
                    rep.anim, rep.frame = anim, frame
                    local frames = self.ctx.scene:frames(anim)
                    local f = frames and frames[frame]
                    -- from another graph (a borrowed walk): its nodes by name
                    if f and agraph and agraph ~= rep.graph then f = rep.rt:remap(f, agraph) end
                    if f then
                        local ok, posed = pcall(function() return rep.rt:solve(f) end)
                        if not ok then
                            rep.pose_errors = (rep.pose_errors or 0) + 1
                            if rep.pose_errors <= 3 then self.log("pose %s failed: %s", name, tostring(posed)) end
                            return
                        end
                        if not rep.pose_logged then
                            rep.pose_logged = true
                            self.log("pose %s: anim=%s frame=%s bones=%d", name, tostring(anim.name or anim), tostring(frame), #posed)
                            -- How the body sits: where the hips are against the
                            -- character's own feet, and the height of the seat
                            -- it was put in. A seated crewman who is standing
                            -- has his hips at the standing height; one who
                            -- floats has them too high.
                            local pz, fz2, sz = 0, 0, 0
                            pcall(function()
                                local t = rep.body:GetBoneTransformByName(FName("pelvis"), 0).Translation
                                pz = tonumber(t.Z) or 0
                            end)
                            pcall(function()
                                local t = rep.body:GetBoneTransformByName(FName("foot_l"), 0).Translation
                                fz2 = tonumber(t.Z) or 0
                            end)
                            if o.seat_pos then sz = o.seat_pos[3] or 0 end
                            self.log("seat %s: seated=%s anim=%s pos (%.0f,%.0f,%.0f) pelvis z %.0f foot z %.0f seat z %.0f",
                                name, tostring(o.seated), tostring(o.custom and o.custom.anim and o.custom.anim.name or anim.name),
                                p.X, p.Y, p.Z, pz, fz2, sz)
                        end
                        -- The look: what the facing/look direction is off the
                        -- body is shared out to chest, neck and head (each bone's
                        -- component-space rotation carries the turn so far).
                        local look = 0
                        if o.look_yaw then
                            look = o.look_yaw - o.yaw
                            if look ~= look or math.abs(look) > 1e6 then look = 0 end
                            look = (look + math.pi) % (2 * math.pi) - math.pi
                            look = math.max(-LOOK_MAX, math.min(LOOK_MAX, look))
                        end
                        rep.look = (rep.look or 0) + (look - (rep.look or 0)) * 0.25
                        for _, b in ipairs(posed) do
                            local share = LOOK_SHARE[b.bone]
                            if share and math.abs(rep.look) > 0.005 and type(b.rot) == "table" then
                                b.rot = Q.norm(Q.mul(Q.from_axis_angle({ 0, 0, 1 }, -rep.look * share), b.rot))
                            end
                        end
                        for _, b in ipairs(posed) do
                            if type(b.bone) ~= "string" or type(b.rot) ~= "table" then
                                self.log("pose %s: skipping bad bone entry (%s)", name, tostring(b.bone))
                            else
                                if not rep.pose_logged2 then
                                    rep.pose_logged2 = true
                                    self.log("pose %s: first bone %s", name, b.bone)
                                end
                                local ok2, err2 = pcall(function()
                                    rep.body:SetBoneRotationByName(FName(b.bone), Q.to_rotator(b.rot), 1)
                                    -- the hips' height and sway (seated: down onto the seat;
                                    -- a scripted animation: Keyes' lean moves his hips 50-90 cm
                                    -- toward the chair, and his arms and neck are posed for that)
                                    if b.loc then
                                        if not rep.root_bone then
                                            rep.root_bone = b.bone
                                            pcall(function()
                                                -- mode 1 is the bone's own space
                                                -- (the same space b.loc is in)
                                                local t = rep.body:GetBoneTransformByName(FName(b.bone), 1).Translation
                                                rep.rest_root = { X = tonumber(t.X) or 0, Y = tonumber(t.Y) or 0, Z = tonumber(t.Z) or 0 }
                                            end)
                                        end
                                        if o.seated or o.custom then
                                            rep.body:SetBoneLocationByName(FName(b.bone),
                                                { X = b.loc[1], Y = b.loc[2], Z = b.loc[3] }, 1)
                                        elseif rep.rest_root then
                                            -- The lean is over. A bone location
                                            -- stays where it was put, so his hips
                                            -- kept the 50-90 cm the lean moved
                                            -- them forward and he walked away
                                            -- through the chair and the console.
                                            -- Put them back where they belong.
                                            rep.body:SetBoneLocationByName(FName(b.bone), rep.rest_root, 1)
                                        end
                                    end
                                end)
                                if not ok2 and not rep.pose_err_logged then
                                    rep.pose_err_logged = true
                                    self.log("pose %s bone %s failed: %s", name, b.bone, tostring(err2))
                                end
                            end
                        end
                        if rep.fixups and #rep.fixups > 0 then
                            local fok, ferr = pcall(self._fixups, self, rep)
                            if not fok and not rep.fix_err then rep.fix_err = true; self.log("fixups %s failed: %s", name, tostring(ferr)) end
                        end
                        if rep.follow and rep.face then self:_follow_face(rep) end
                    end
                end
            end
            if rep.kind == "h2a" then
                local hok, herr = pcall(self._pose_h2a, self, rep, o, tl)
                if not hok and not rep.pose_err then rep.pose_err = true; self.log("h2a pose failed: %s", tostring(herr)) end
            end
            -- Keep his soles on the remake's floor wherever he is along the
            -- walk. The floor under the bridge rises about a metre, so it is
            -- asked every frame instead of fixed once.
            -- Seated crew stay where the chair's own seat marker puts them: a
            -- floor snap from the dangling feet dropped the pilots into their
            -- chairs (logged as 9 cm and more down) and pushed others through the floor.
            if o.seated then
                if not rep.seated_logged then
                    rep.seated_logged = true
                    self.log("seated %s: no floor snap (chair seat marker)", name)
                end
            elseif rep.foot_bones and rep.rest_foot_z then
                local fz = posed_foot_z(rep)
                if fz then
                    -- seated, start just above the feet: from higher up the
                    -- trace lands on the chair itself
                    local fl = (rep.row or {}).floor or {}
                    local from = fl.from or 300
                    if fl.from_feet then from = fz + from end
                    local floor = self:_trace_floor(rep, p.X, p.Y, p.Z, o.seated and (fz + 25) or from)
                    if floor then
                        local target = floor + rep.rest_foot_z - fz + 0.5
                        local lift = target - p.Z
                        -- a sudden jump is something else under him (a console's
                        -- edge): keep the last good lift, and ease the rest
                        if fl.smooth and rep.lift then
                            if math.abs(lift - rep.lift) > 40 then lift = rep.lift end
                            lift = rep.lift + (lift - rep.lift) * 0.5
                        end
                        target = p.Z + lift
                        if math.abs(lift) < 250 then
                            rep.lift = lift
                            p.Z = target
                            pcall(function()
                                rep.actor:K2_SetActorLocationAndRotation(p,
                                    { Pitch = 0, Yaw = yaw, Roll = 0 }, false, {}, true)
                            end)
                            if not rep.floor_logged then
                                rep.floor_logged = true
                                -- The same vertical shift is put on the camera, so
                                -- the shot keeps the original's height relative to
                                -- him even if the remake's floor sits a little off.
                                if rep.row and fr and rep.row.id == fr.subject then self.cam_offset = lift end
                                self.log("floor %s: foot %.1f, floor %.1f, moved %.1f cm", name, fz, floor, lift)
                            end
                        elseif not rep.floor_bad then
                            rep.floor_bad = true
                            self.log("floor %s: ignored a trace %.0f cm away", name, lift)
                        end
                    end
                end
            end
        end
    end
end

-- Events from the timeline ------------------------------------------------------------
function Stage:handle(ev)
    if ev.type == "create" then self:create(ev)
    elseif ev.type == "destroy" then self:destroy(ev.name)
    elseif ev.type == "sound" then pcall(self.play, self, ev.name, "voice")
    elseif ev.type == "loop" then
        local kind = ev.name:find("foley") and "foley" or "music"
        pcall(self.play, self, ev.name, kind)
    elseif ev.type == "fade" then pcall(self.fade, self, ev)
    elseif ev.type == "error" then self.log("script error %s", ev.text)
    elseif ev.type == "note" then self.log("note %s", ev.text)
    elseif ev.type == "near_clip" then pcall(self.near_clip, self, (tonumber(ev.wu) or 0.0625) * 304.8)
    end
end

-- The original script pulls the near clip plane in to 0.01 units (3 cm) for
-- its close-ups of Keyes and Cortana; Unreal's 10 cm cut the front of Keyes'
-- face away in the eye close-up. Per camera where the engine allows it, and
-- the engine-wide setting as well; put back when the scene ends.
function Stage:near_clip(cm)
    local how = {}
    pcall(function()
        local cc = self.cam.CameraComponent
        cc.bOverride_CustomNearClippingPlane = true
        cc.CustomNearClippingPlane = cm
        how[#how + 1] = "camera"
    end)
    pcall(function()
        local k = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
        k:ExecuteConsoleCommand(self.pc, string.format("r.SetNearClipPlane %.2f", cm), self.pc)
        how[#how + 1] = "engine"
    end)
    self.near_set = true
    self.log("near clip %.1f cm (%s)", cm, table.concat(how, "+"))
end

function Stage:finish()
    pcall(self._unblock_restore, self)
    if self.near_set then
        pcall(function()
            local k = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
            k:ExecuteConsoleCommand(self.pc, "r.SetNearClipPlane 10", self.pc)
        end)
    end
    for _, a in ipairs(self.hidden or {}) do
        pcall(function() if a:IsValid() then a:SetActorHiddenInGame(false) end end)
    end
    self.hidden = {}
    for _, c in ipairs(self.players) do pcall(function() c.mp:Close() end) end
    for _, c in pairs(self.music) do pcall(function() c.mp:Close() end) end
    self:end_camera()
    for _, a in ipairs(self.actors) do pcall(function() a:K2_DestroyActor() end) end
    self.actors, self.reps = {}, {}
    pcall(function() self.pc.PlayerCameraManager:StopCameraFade() end)
end

return Stage
