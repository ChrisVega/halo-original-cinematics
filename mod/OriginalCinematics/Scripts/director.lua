-- Watches Campaign Evolved's cutscenes. When one listed in the scenes sheet
-- starts, it holds the remake's own cutscene (sequence paused, video closed),
-- plays the original scene in real time with ue_stage, then lets the remake
-- carry on. Remake cutscenes the original replaces are skipped.

local Stage = require("ue_stage")

local D = {}
D.__index = D

-- ctx: { log, sheets, load_scene = function(map_id) -> scene, sound, characters, report = function(key, value) }
function D.new(ctx)
    return setmetatable({ ctx = ctx, active = nil, handled = {}, skipped = {} }, D)
end

local function seq_name(actor)
    local n = ""
    pcall(function() n = actor.LevelSequenceAsset:GetFName():ToString() end)
    return n
end

-- Wall-clock seconds; the same source is used for a whole scene. Object
-- lookups are slow on this build (full scans), so everything is found once.
local cache = {}
local function cdo(path)
    local o = cache[path]
    if not (o and o:IsValid()) then o = StaticFindObject(path); cache[path] = o end
    return o
end
local CLOCKS = {
    function() return cdo("/Script/Engine.Default__KismetMathLibrary"):Now().Ticks / 1e7 end,
    function() return os.clock() end,
}

local function now(src)
    for i = src or 1, #CLOCKS do
        local ok, t = pcall(CLOCKS[i])
        if ok and type(t) == "number" then return t, i end
        if src then break end
    end
    return os.clock(), #CLOCKS
end

-- FindAllOf returns a table normally, but some builds hand back the single
-- object it found; ipairs on that is the "got UObject" error.
local function each_of(name)
    local ok, list = pcall(FindAllOf, name)
    if not ok or not list then return {} end
    if type(list) == "table" then return list end
    return { list }
end

function D:_find_sequences()
    local out = {}
    for _, a in ipairs(each_of("LevelSequenceActor")) do
        if a:IsValid() then out[#out + 1] = { actor = a, name = seq_name(a) } end
    end
    return out
end

function D:_hs(cmd)
    pcall(function()
        cdo("/Script/Engine.Default__KismetSystemLibrary"):ExecuteConsoleCommand(self.world, "hs:" .. cmd, nil)
    end)
end

local MUTED_CLASSES = { "music", "scripted_dialog_player", "scripted_dialog_other",
    "scripted_dialog_force_unspatialized", "scripted_effect", "unit_dialog" }

-- Objects of the remake's (its movie players, its sequence) are freed once
-- their cutscene is over; calling into a freed one jumps into garbage and
-- takes the game down. Check before every touch.
local function alive(o)
    local ok, v = pcall(function() return o:IsValid() end)
    return ok and v == true
end

local function mp_label(mp)
    local n, u, playing = "", "", false
    pcall(function() n = mp:GetFName():ToString() end)
    pcall(function() u = mp:GetUrl():ToString() end)
    pcall(function() playing = mp:IsPlaying() end)
    return string.format("%s url=%s playing=%s", n, u, tostring(playing))
end

-- the remake's cutscene video players, found once per scene
function D:_video_players()
    local list = {}
    for _, mp in ipairs(each_of("MediaPlayer")) do
        local n, u = "", ""
        pcall(function() n = mp:GetFName():ToString() end)
        pcall(function() u = mp:GetUrl():ToString() end)
        if n:find("Preroll") or n:find("Animatic") or u:find("CinematicsPreRenders") then
            list[#list + 1] = mp
        end
    end
    return list
end

-- Stop the remake's pre-rendered video: no auto-play when the sequence
-- re-opens it, and the current stream closed. PlayOnOpen belongs to the shared
-- MediaPlayer asset, so remember it and put it back when the takeover ends.
local saved_playonopen = {}
local function mp_key(mp)
    local k = ""
    pcall(function() k = mp:GetFullName() end)
    return k
end

function D:_silence_videos(list)
    for _, mp in ipairs(list or {}) do
        if alive(mp) then pcall(function()
            local k = mp_key(mp)
            if saved_playonopen[k] == nil then saved_playonopen[k] = mp.PlayOnOpen end
            mp.PlayOnOpen = false
            if mp:IsPlaying() then mp:Pause() end
            mp:Close()
        end) end
    end
end

function D:_restore_videos(list)
    for _, mp in ipairs(list or {}) do
        if alive(mp) then pcall(function()
            local k = mp_key(mp)
            local v = saved_playonopen[k]
            if v ~= nil then mp.PlayOnOpen = v; saved_playonopen[k] = nil end
        end) end
    end
end

-- The remake streams its pre-render through a FileMediaSource and shows it on
-- a MediaTexture/MediaPlate. Closing the player alone is not enough: the
-- sequence opens the source again. Point every file source at a file that is
-- not there for the takeover, take the player off every media texture, and
-- hide the plates; put it all back when the original scene ends.
local saved_sources = {}
local saved_textures = {}
local saved_plates = {}

local function saved_has(list, o)
    for _, e in ipairs(list) do if e.o == o then return true end end
    return false
end

-- Point every media source at another file (the mod's own video), and remember
-- the original so it can be put back. The plates and textures are left alone:
-- the video is meant to be seen.
function D:_point_sources_at(path)
    local n = 0
    for _, cn in ipairs({ "FileMediaSource", "MediaSource" }) do
        for _, src in ipairs(each_of(cn)) do
            pcall(function()
                local fp = nil
                pcall(function() fp = src.FilePath end)
                if fp then
                    if not saved_has(saved_sources, src) then
                        saved_sources[#saved_sources + 1] = { o = src, v = fp }
                    end
                    src.FilePath = path
                    n = n + 1
                end
            end)
        end
    end
    return n
end

-- The video's own sound: Electra's sound component, which sits on a level
-- actor and carries the movie's audio. Muting it every frame is what keeps
-- the intro movie silent - the sound outlives the movie otherwise, because
-- the component belongs to the level and not to the cutscene.
-- The component is found once and kept: looking it up every time is a full
-- scan of the world, and that is what made the game stutter.
-- with_wwise: the remake also posts the movie's soundtrack on Wwise; that is
-- stopped too, but only while a movie is actually up (stopping Wwise all the
-- time would silence the level's music and ambience).
function D:_mute_video_audio(with_wwise)
    if self.media_sound == nil then
        self.media_sound = false
        for _, ms in ipairs(each_of("MediaSoundComponent")) do
            if alive(ms) then self.media_sound = ms break end
        end
    end
    local ms = self.media_sound
    if ms and alive(ms) then
        pcall(function() ms:SetVolumeMultiplier(0) end)
        pcall(function() if ms:IsPlaying() then ms:Stop() end end)
    end
    if not with_wwise then return end
    for _, cn in ipairs({ "AkComponent", "AkAmbientSound" }) do
        for _, ak in ipairs(each_of(cn)) do
            if alive(ak) then
                pcall(function() ak:Stop() end)
                pcall(function() ak:SetActive(false) end)
            end
        end
    end
    pcall(function() cdo("/Script/AkAudio.Default__AkGameplayStatics"):StopAll() end)
end

function D:_block_video()
    local sources, textures, plates = 0, 0, 0
    -- Every kind of media source, not just the file ones: the remake's
    -- movies come from a source of its own kind, and a source that is left
    -- alone keeps its movie playing.
    for _, cn in ipairs({ "FileMediaSource", "MediaSource" }) do
        for _, src in ipairs(each_of(cn)) do
            pcall(function()
                local path = nil
                pcall(function() path = src.FilePath end)
                if path then
                    if not saved_has(saved_sources, src) then
                        saved_sources[#saved_sources + 1] = { o = src, v = path }
                    end
                    src.FilePath = "OriginalCinematics/preroll-disabled.mp4"
                    sources = sources + 1
                else
                    local url = nil
                    pcall(function() url = src.Url end)
                    if url then
                        if not saved_has(saved_sources, src) then
                            saved_sources[#saved_sources + 1] = { o = src, v = url, url = true }
                        end
                        src.Url = ""
                        sources = sources + 1
                    end
                end
            end)
        end
    end
    for _, tex in ipairs(each_of("MediaTexture")) do
        pcall(function()
            if not saved_has(saved_textures, tex) then
                saved_textures[#saved_textures + 1] = { o = tex, v = tex.MediaPlayer }
            end
            tex.MediaPlayer = nil
            textures = textures + 1
        end)
    end
    for _, name in ipairs({ "MediaPlate", "MediaPlateActor" }) do
        for _, a in ipairs(each_of(name)) do
            pcall(function()
                if not saved_has(saved_plates, a) then
                    saved_plates[#saved_plates + 1] = { o = a, v = a:IsHidden() }
                end
                a:SetActorHiddenInGame(true)
                plates = plates + 1
            end)
        end
    end
    return sources, textures, plates
end

function D:_unblock_video()
    for _, e in ipairs(saved_sources) do
        if alive(e.o) then pcall(function()
            if e.url then e.o.Url = e.v else e.o.FilePath = e.v end
        end) end
    end
    saved_sources = {}
    for _, e in ipairs(saved_textures) do
        if alive(e.o) then pcall(function() e.o.MediaPlayer = e.v end) end
    end
    saved_textures = {}
    for _, e in ipairs(saved_plates) do
        if alive(e.o) then pcall(function() e.o:SetActorHiddenInGame(e.v) end) end
    end
    saved_plates = {}
end

-- The sequence re-opens its video while it runs, so keep closing it under the
-- takeover even though it is paused.
function D:_close_videos(list)
    local reopened = false
    for _, mp in ipairs(list or {}) do
        if alive(mp) then pcall(function()
            if mp:IsPlaying() then mp:Close(); reopened = true end
        end) end
    end
    return reopened
end

-- The remake's cutscene sound can come through Unreal's own audio or a Bink
-- movie rather than Wwise or a MediaPlayer. Keep our channels; stop the rest.
function D:_hush_others(a)
    local st = a.stage
    local ours = {}
    for _, ch in ipairs(st.players or {}) do pcall(function() ours[ch.snd.AudioComponent:GetFullName()] = true end) end
    for _, ch in pairs(st.music or {}) do pcall(function() ours[ch.snd.AudioComponent:GetFullName()] = true end) end
    a.hushed = a.hushed or {}
    -- What the remake is playing, once per scene: the names and classes of
    -- every sound source it has. This is how the movie's own sound was found.
    if not a.sources_logged then
        a.sources_logged = true
        for _, cn in ipairs({ "AudioComponent", "MediaSoundComponent", "AkComponent", "AkAmbientSound", "AkAudioEvent" }) do
            local n = 0
            for _, o in ipairs(each_of(cn)) do
                if alive(o) then
                    local fn, playing = "?", false
                    pcall(function() fn = o:GetFullName() end)
                    pcall(function() playing = o:IsPlaying() end)
                    n = n + 1
                    if playing and not ours[fn] then
                        self.ctx.log("sound source: %s (%s) playing", fn, cn)
                    end
                end
            end
            self.ctx.log("sound sources %s: %d", cn, n)
        end
    end
    for _, ac in ipairs(each_of("AudioComponent")) do
        if alive(ac) then pcall(function()
            if ac:IsPlaying() then
                local fn = ac:GetFullName()
                if not ours[fn] then
                    local snd = "?"
                    pcall(function() snd = ac.Sound and ac.Sound:GetFullName() or "?" end)
                    ac:Stop()
                    if not a.hushed[fn] then a.hushed[fn] = true; self.ctx.log("stopped other sound: %s (%s)", fn, snd) end
                end
            end
        end) end
    end
    -- video sound (the remake's menu and intro movies): any MediaSoundComponent
    -- that is not one of our channels
    local our_snd = {}
    for _, ch in ipairs(st.players or {}) do pcall(function() our_snd[ch.snd:GetFullName()] = true end) end
    for _, ch in pairs(st.music or {}) do pcall(function() our_snd[ch.snd:GetFullName()] = true end) end
    for _, ms in ipairs(each_of("MediaSoundComponent")) do
        if alive(ms) then pcall(function()
            local fn = ms:GetFullName()
            if not our_snd[fn] then
                local was = false
                pcall(function() was = ms:IsPlaying() end)
                pcall(function() ms:Stop() end)
                pcall(function() ms:SetVolumeMultiplier(0) end)
                if not a.hushed[fn] then a.hushed[fn] = true; self.ctx.log("muted video sound: %s (playing %s)", fn, tostring(was)) end
            end
        end) end
    end
    -- Wwise: the remake's own sounds (its intro's ships, slipspace) are posted
    -- on Wwise components, so stopping Unreal's channels does not touch them.
    for _, cn in ipairs({ "AkComponent", "AkAmbientSound" }) do
        for _, ak in ipairs(each_of(cn)) do
            if alive(ak) then pcall(function()
                local fn = "?"
                pcall(function() fn = ak:GetFullName() end)
                pcall(function() ak:Stop() end)
                pcall(function() ak:SetActive(false) end)
                if not a.hushed[fn] then a.hushed[fn] = true; self.ctx.log("stopped wwise sound: %s (%s)", fn, cn) end
            end) end
        end
    end
    for _, cn in ipairs({ "BinkMediaPlayer" }) do
        for _, bp in ipairs(each_of(cn)) do
            if alive(bp) then pcall(function()
                if bp:IsPlaying() then
                    bp:Stop()
                    local fn = bp:GetFullName()
                    if not a.hushed[fn] then a.hushed[fn] = true; self.ctx.log("stopped Bink movie: %s", fn) end
                end
            end) end
        end
    end
end

-- The creator's own video plays first, in the remake's video slot, silent.
-- The remake's cutscene is PAUSED, not ended: its Blam script stays inside
-- f_play_cinematic, so the mission's scripts are never woken while our
-- original scene plays. When that scene is over the cutscene is ended and the
-- mission starts. Returns false when there is no video to play.
function D:_start_preroll(row, seq)
    local log = self.ctx.log
    local rel = row.preroll_video
    if not rel or rel == "" then return false end
    local path = rel
    if self.ctx.mod_dir then path = self.ctx.mod_dir .. rel end
    -- put back the plates and textures the idle blocker took down, so the
    -- video is actually on screen
    self:_unblock_video()
    local videos = self:_video_players()
    self:_restore_videos(videos)
    local n = self:_point_sources_at(path)
    if n == 0 then
        log("preroll: no media source to point at %s", path)
        return false
    end
    -- the player has to open our file, and it has to open it now: the remake
    -- is not going to, because we are about to pause its cutscene
    for _, mp in ipairs(videos) do
        pcall(function()
            mp.PlayOnOpen = true
            mp:Open()
            mp:Play()
        end)
    end
    self.preroll = { row = row, seq = seq, videos = videos, started = false, t0 = now() }
    self.handled[seq.name] = true
    -- Pause the remake's cutscene. Its Blam script is waiting inside
    -- f_play_cinematic for this cutscene to end, and it does not end until we
    -- say so: so the mission's scripts stay asleep for as long as our cutscene
    -- plays. The mission cannot start while the cutscene is playing.
    pcall(function() seq.actor.SequencePlayer:Pause() end)
    self:_hs("player_enable_input 0")
    log("preroll: %s plays in the remake's video slot, silent; the remake's cutscene is paused", path)
    return true
end

-- The video is over: our original scene takes over. The remake's cutscene
-- stays paused, so the mission is still asleep.
function D:_preroll_done()
    local pr = self.preroll
    self.preroll = nil
    local log = self.ctx.log
    log("preroll: video over, our scene takes over")
    self:_stop_remake_audio()
    self:_restore_videos(pr.videos)
    self:_unblock_video()
    self.ctx.report("scene_started", pr.row.id)
    -- a beat later our own scene takes over
    self.pending = { row = pr.row, seq = pr.seq, at = now() + 1.0, videos = pr.videos }
end

-- The remake's cutscene audio is a Wwise event posted when its sequence
-- began; ending the sequence leaves it playing under ours. Stop Wwise's
-- sounds once (ours go through Unreal's own audio, not Wwise).
function D:_stop_remake_audio()
    local ok_ak, err_ak = pcall(function() cdo("/Script/AkAudio.Default__AkGameplayStatics"):StopAll() end)
    self.ctx.log("wwise stop: %s", ok_ak and "done" or tostring(err_ak))
    -- The remake runs the original's scripts underneath: its own remastered
    -- intro dialogue and music start with ours. Mute those sound classes for
    -- the scene (ours play through Unreal, not the Blam sound classes).
    for _, c in ipairs(MUTED_CLASSES) do self:_hs(string.format('sound_class_set_gain "%s" 0 0', c)) end
end

function D:start(row, seq)
    local log = self.ctx.log
    log("takeover: %s replaces %s", row.ce_script, seq.name)
    self.world = Stage.main_world()
    local sp = seq.actor.SequencePlayer
    -- its movie's audio component goes away with the sequence: learn it first
    pcall(Stage.capture_media_sound, log)
    -- End the remake's cutscene instead of holding it: its movie goes away for
    -- good, and the mission it was sitting on top of is free to load. The
    -- original scene starts a couple of seconds later, once the bridge and
    -- Keyes' skeleton actually exist in the level under our camera.
    pcall(function() sp:GoToEndAndStop() end)
    pcall(function() sp:Stop() end)
    self:_stop_remake_audio()
    local videos = self:_video_players()
    for _, mp in ipairs(videos) do log("video to disable: %s", mp_label(mp)) end
    self:_silence_videos(videos)
    local ns, nt, np = self:_block_video()
    log("video block: %d sources, %d textures, %d plates", ns, nt, np)
    self:_hs("player_enable_input 0")
    self.handled[seq.name] = true
    self.pending = { row = row, seq = seq, at = now() + 3.0, videos = videos }
    self.ctx.report("scene_started", row.id)
end

-- The mission's world is loaded enough: build the scene and take the camera.
function D:_begin(row, seq, videos)
    local log = self.ctx.log
    self.world = self.world or Stage.main_world()
    local scene, sound = self.ctx.load_scene(row.map)
    local tl = scene:timeline(row.ce_script)
    tl.shot_adjust, tl.chain_ease, tl.walk_off = row.shot_adjust, row.chain_ease, row.walk_off
    tl.start_facing = row.start_facing
    local stage = Stage.new({ log = log, scene = scene, sound = sound, sheets = self.ctx.sheets, characters = self.ctx.characters,
        camera = { source_aspect = row.source_aspect, target_aspect = row.target_aspect, letterbox_aspect = row.letterbox_aspect, closeup = row.closeup, framing = row.framing, aim = row.aim, unblock = row.unblock },
        mcc = self.ctx.mcc, cache = self.ctx.cache, hide = row.hide, skip_objects = row.skip_objects })
    pcall(stage.hide_remake_cast, stage)
    stage:begin_camera()
    -- music the original started before the part we take over (x10 starts its
    -- theme before the space flyby, which the remake still shows)
    local ms = row.music_start
    if ms and ms.sound and ms.sound ~= "" then pcall(stage.play, stage, ms.sound, "music", ms.at) end
    local t0, src = now()
    self.active = { row = row, seq = seq, sp = seq.actor.SequencePlayer, held = false, tl = tl, stage = stage, t0 = t0, clock = src, ticks = 0, videos = videos }
    log("clock source %d", src)
end

function D:stop(reason)
    local a = self.active
    if not a then return end
    self.muted_for_intro = false
    self.ctx.log("scene %s ended (%s) after %.1fs", a.row.id, reason, a.ticks / 30)
    pcall(function() a.stage:finish() end)
    -- Release the remake's cutscene. When it was paused for the takeover, its
    -- Blam script has been waiting inside f_play_cinematic for it to end: this
    -- is the moment the mission's scripts are woken, and it is deliberately
    -- after our scene has finished, so the mission cannot start while the
    -- cutscene plays.
    if alive(a.sp) then
        pcall(function() a.sp:GoToEndAndStop() end)
        pcall(function() a.sp:Stop() end)
    end
    self:_hs("player_enable_input 1")
    for _, c in ipairs(MUTED_CLASSES) do self:_hs(string.format('sound_class_set_gain "%s" 1 0', c)) end
    self:_skip_remake(a.row)
    self:_restore_videos(a.videos)
    self:_unblock_video()
    self.active = nil
    self.ctx.report("scene_finished", a.row.id .. ":" .. reason .. ":" .. math.floor(a.ticks / 30))
end

function D:_skip_remake(row)
    for _, seq in ipairs(self:_find_sequences()) do
        local playing = false
        pcall(function() playing = seq.actor.SequencePlayer:IsPlaying() end)
        if playing then
            local hit = seq.name:find(row.trigger)
            for _, pat in ipairs(row.skip) do if seq.name:find(pat) then hit = true end end
            if hit then
                pcall(function() seq.actor.SequencePlayer:GoToEndAndStop() end)
                -- its Wwise audio keeps going after the sequence ends
                pcall(function() cdo("/Script/AkAudio.Default__AkGameplayStatics"):StopAll() end)
                self.ctx.log("ended remake cutscene %s under ours", seq.name)
            end
        end
    end
end

-- One step, on the game thread, called many times a second.
function D:update()
    -- The creator's video plays first, in the remake's video slot, silent.
    -- Wait for it to finish, then our original scene takes over. The remake's
    -- cutscene stays paused, so the mission cannot start meanwhile.
    if self.preroll then
        local pr = self.preroll
        local playing = false
        for _, mp in ipairs(pr.videos) do
            if alive(mp) then pcall(function() if mp:IsPlaying() then playing = true end end) end
        end
        if playing and not pr.started then
            pr.started = true
            pr.played_at = now()
            self.ctx.log("preroll: the video is playing")
        end
        -- the video must not be heard: its sound is a MediaSoundComponent on a
        -- level actor, and the remake posts its soundtrack on Wwise
        self:_mute_video_audio(true)
        -- keep the video running: pausing the cutscene can pause the player
        if pr.started and not playing then
            for _, mp in ipairs(pr.videos) do
                pcall(function() if not mp:IsPlaying() then mp:Play() end end)
            end
            pr.resumes = (pr.resumes or 0) + 1
            if pr.resumes == 1 or pr.resumes % 60 == 0 then
                self.ctx.log("preroll: the video player stopped, resumed it (%d)", pr.resumes)
            end
        end
        -- the video's own length is the clock: it is known, and it is short
        local total = pr.row.preroll_seconds or 45
        local elapsed = pr.played_at and (now() - pr.played_at) or 0
        if pr.started and elapsed >= total then
            self.ctx.log("preroll: the video is over (%.1fs)", elapsed)
            self:_preroll_done()
        elseif (now() - pr.t0) > 180 then
            self.ctx.log("preroll: gave up waiting for the video")
            self:_preroll_done()
        end
        return
    end
    local p = self.pending
    if p then
        if now() >= p.at then
            self.pending = nil
            self:_begin(p.row, p.seq, p.videos)
        else
            self:_close_videos(p.videos)
            return
        end
    end
    local a = self.active
    if a then
        if not a.stage:alive() then self:stop("world-lost"); return end
        local target = math.floor((now(a.clock) - a.t0) * 30)
        local guard = 0
        while a.ticks < target and guard < 8 do
            a.ticks = a.ticks + 1; guard = guard + 1
            -- the bridge's collision streams in after the takeover: survey 5 s in
            if a.ticks == 150 then
                local sok, serr = pcall(a.stage.survey, a.stage)
                if not sok then self.ctx.log("survey failed: %s", tostring(serr)) end
            end
            -- the camera as it was before this tick, to blend from (smooth_camera)
            local c0 = a.tl.camera
            a.prev_cam = c0 and { pos = { c0.pos[1], c0.pos[2], c0.pos[3] }, rot = { c0.rot[1], c0.rot[2], c0.rot[3] }, fov = c0.fov } or nil
            local ok, alive = pcall(function() return a.tl:step() end)
            if not ok then
                a.step_errors = (a.step_errors or 0) + 1
                if a.step_errors <= 3 then self.ctx.log("timeline step failed: %s", tostring(alive)) end
                alive = true
            end
            for _, ev in ipairs(a.tl:take_events()) do
                local eok, err = pcall(function() a.stage:handle(ev) end)
                if not eok then self.ctx.log("event %s failed: %s", tostring(ev.type), tostring(err)) end
            end
            if not alive then self:stop("done"); return end
        end
        -- The original moves its camera once per script tick (30 a second);
        -- shown as it is, it steps on a faster screen. Blend between the last
        -- two ticks by how far into the next tick we are (one tick behind);
        -- a cut is not blended.
        local shown = a.tl.camera
        local sm = a.row.smooth_camera
        if sm and shown and a.prev_cam then
            local c0 = a.prev_cam
            local dx, dy, dz = shown.pos[1] - c0.pos[1], shown.pos[2] - c0.pos[2], shown.pos[3] - c0.pos[3]
            local jump = math.sqrt(dx * dx + dy * dy + dz * dz) * 304.8
            if jump < (sm.jump_cm or 60) then
                local u = (now(a.clock) - a.t0) * 30 - a.ticks
                u = math.max(0, math.min(1, u))
                local function ang(x, y) local d = (y - x + math.pi) % (2 * math.pi) - math.pi; return x + d * u end
                shown = {
                    pos = { c0.pos[1] + dx * u, c0.pos[2] + dy * u, c0.pos[3] + dz * u },
                    rot = { ang(c0.rot[1], shown.rot[1]), ang(c0.rot[2], shown.rot[2]), ang(c0.rot[3], shown.rot[3]) },
                    fov = c0.fov + (shown.fov - c0.fov) * u,
                }
            end
        end
        local cok, cerr = pcall(function() a.stage:update_camera(shown) end)
        if not cok then
            a.cam_errors = (a.cam_errors or 0) + 1
            if a.cam_errors <= 3 then self.ctx.log("camera update failed: %s", tostring(cerr)) end
        end
        local ook, oerr = pcall(function() a.stage:update_objects(a.tl) end)
        if not ook then
            a.obj_errors = (a.obj_errors or 0) + 1
            if a.obj_errors <= 3 then self.ctx.log("object update failed: %s", tostring(oerr)) end
        end
        a.frames = (a.frames or 0) + 1
        -- The remake's audio engine keeps posting its cinematic audio (the
        -- movie's soundtrack and its remastered dialogue) as Wwise events
        -- under our scene; stopping them once at the start is not enough.
        -- Ours plays through Unreal's own audio, so keep Wwise stopped.
        if a.frames % 5 == 0 then
            pcall(function() cdo("/Script/AkAudio.Default__AkGameplayStatics"):StopAll() end)
        end
        -- keep the remake's own opening videos out of the way while ours plays
        if a.frames % 30 == 0 and self:_close_videos(a.videos) then
            a.reopens = (a.reopens or 0) + 1
            if a.reopens == 1 or a.reopens % 60 == 0 then
                self.ctx.log("video re-opened after the block (%d)", a.reopens)
            end
            -- Its video is still coming back, so end the remake's cutscene
            -- rather than sit under a movie.
            if a.reopens >= 3 and a.held and alive(a.sp) then
                self.ctx.log("stopping the remake's sequence to end its video")
                pcall(function() a.sp:GoToEndAndStop() end)
                a.held = false
            end
        end
        if a.frames % 60 == 0 then self:_skip_remake(a.row) end
        -- anything else making sound under our scene (Unreal audio components,
        -- Bink movies): named in the log once, and stopped
        if a.frames % 15 == 7 then pcall(self._hush_others, self, a) end
        -- every ~5 s: what else is making picture or sound under our scene
        if a.frames % 300 == 150 then
            local playing = {}
            for _, mp in ipairs(each_of("MediaPlayer")) do
                if alive(mp) then
                    local on = false
                    pcall(function() on = mp:IsPlaying() end)
                    if on then playing[#playing + 1] = mp_label(mp) end
                end
            end
            local seqs = {}
            for _, s in ipairs(self:_find_sequences()) do
                local on = false
                pcall(function() on = s.actor.SequencePlayer:IsPlaying() end)
                if on then seqs[#seqs + 1] = s.name end
            end
            self.ctx.log("playing now: media [%s] sequences [%s]", table.concat(playing, "; "), table.concat(seqs, ", "))
        end
        if a.frames % 150 == 0 then
            local c = a.tl.camera
            local px, py, pz = 0, 0, 0
            if type(c) == "table" and type(c.pos) == "table" then
                px, py, pz = c.pos[1] or 0, c.pos[2] or 0, c.pos[3] or 0
            end
            self.ctx.log("scene %s t=%.1fs tick=%d cam=(%.1f, %.1f, %.1f)",
                a.row.id, a.ticks / 30, a.ticks, px, py, pz)
        end
        -- a sequence may construct a new MediaPlayer for its video
        if a.frames % 300 == 0 then
            local more = self:_video_players()
            for _, mp in ipairs(more) do
                if alive(mp) and mp:IsPlaying() then self.ctx.log("video re-opened, closing it: %s", mp_label(mp)) end
            end
            a.videos = more
            self:_silence_videos(more)
            self:_block_video()
        end
        return
    end
    -- No remake intro video at all: while waiting for our scene, its
    -- pre-rendered movie is closed and blocked the moment it opens, and the
    -- sound posted with it stopped. Check every frame, not every 10.
    self.idle_frames = (self.idle_frames or 0) + 1
    for _, mp in ipairs(self:_video_players()) do
        local on, u = false, ""
        pcall(function() on = mp:IsPlaying() end)
        pcall(function() u = mp:GetUrl():ToString() end)
        if u:find("CinematicsPreRenders") and not self.preroll then
            if on then
                self.ctx.log("blocked the remake's intro video: %s", mp_label(mp))
                self:_silence_videos({ mp })
                pcall(function() cdo("/Script/AkAudio.Default__AkGameplayStatics"):StopAll() end)
                self.muted_for_intro = true
            end
            -- always block sources/textures/plates even if not playing yet
            self:_block_video()
        end
    end
    -- The intro movie's sound is a MediaSoundComponent on a level actor. It
    -- is muted every frame, so the movie is never heard - not before our
    -- scene starts, not during it, and not after it.
    self:_mute_video_audio(false)
    -- A scene with a creator's video: it wants the video slot left alone, so
    -- it is checked before the blocker above and before the takeover.
    for _, seq in ipairs(self:_find_sequences()) do
        local playing = false
        pcall(function() playing = seq.actor.SequencePlayer:IsPlaying() end)
        if playing then
            for _, row in ipairs(self.ctx.sheets.scenes) do
                if seq.name:find(row.trigger) and not self.handled[seq.name] then
                    if row.preroll_video and row.preroll_video ~= "" then
                        if self:_start_preroll(row, seq) then return end
                    end
                end
            end
        end
    end
    -- Intro videos removed outright (sheet video_skips): every frame, a
    -- matching sequence goes straight to its end so the level carries on
    -- from where the video leaves it, and its movie is closed as it opens.
    local vskips = self.ctx.sheets.video_skips or {}
    if #vskips > 0 then
        for _, mp in ipairs(self:_video_players()) do
            local u = ""
            pcall(function() u = mp:GetUrl():ToString() end)
            for _, v in ipairs(vskips) do
                if u:find(v.video) then
                    local on = false
                    pcall(function() on = mp:IsPlaying() end)
                    if on then
                        self.ctx.log("video_skip %s: closed its movie", v.id)
                        self:_silence_videos({ mp })
                        pcall(function() cdo("/Script/AkAudio.Default__AkGameplayStatics"):StopAll() end)
                        self.vskip_hold = 90
                    end
                end
            end
        end
    end
    -- the level's later cutscenes play again once the skipped one is over
    if self.vskip_hold then
        self.vskip_hold = self.vskip_hold - 1
        if self.vskip_hold <= 0 then
            self.vskip_hold = nil
            self:_restore_videos(self:_video_players())
            self.ctx.log("video_skip: later videos allowed again")
        end
    end
    for _, seq in ipairs(self:_find_sequences()) do
        local playing = false
        pcall(function() playing = seq.actor.SequencePlayer:IsPlaying() end)
        if playing then
            for _, v in ipairs(vskips) do
                if seq.name:find(v.trigger) then
                    self.ctx.log("video_skip %s: sent %s to its end", v.id, seq.name)
                    self:_silence_videos(self:_video_players())
                    pcall(function() seq.actor.SequencePlayer:GoToEndAndStop() end)
                    pcall(function() cdo("/Script/AkAudio.Default__AkGameplayStatics"):StopAll() end)
                    self.vskip_hold = 90
                end
            end
            for _, row in ipairs(self.ctx.sheets.scenes) do
                if seq.name:find(row.trigger) and not self.handled[seq.name] then
                    self:start(row, seq)
                    return
                end
                for _, pat in ipairs(row.skip) do
                    if seq.name:find(pat) then
                        self.ctx.log("skipping remake cutscene %s (the original covers it)", seq.name)
                        local videos = self:_video_players()
                        self:_silence_videos(videos)
                        self:_block_video()
                        pcall(function() seq.actor.SequencePlayer:GoToEndAndStop() end)
                        self:_restore_videos(videos)
                        self:_unblock_video()
                    end
                end
            end
        end
    end
end

return D
