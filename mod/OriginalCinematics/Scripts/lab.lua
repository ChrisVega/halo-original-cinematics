-- Lab pass: tries each building block of a real-time cutscene inside
-- Campaign Evolved, once, when the first mission (A15) loads, and logs
-- what worked. Pieces: stop the opening video, take the camera, place and
-- pose Keyes, play an original voice line, show a runtime-built shape.

local Lab = {}

local log_file
local function log(fmt, ...)
    local line = select("#", ...) == 0 and fmt or string.format(fmt, ...)
    if log_file then log_file:write(os.date("%H:%M:%S "), line, "\n"); log_file:flush() end
    print("[OriginalCinematics] " .. line .. "\n")
end

local function try(label, fn)
    local ok, a, b = pcall(fn)
    log("%s %s %s", ok and "OK  " or "FAIL", label, ok and tostring(a or "") or tostring(a))
    if ok then return a, b end
end

local function name_of(o)
    local ok, n = pcall(function() return o:GetFullName() end)
    return ok and n or "?"
end

local WU = 304.8 -- one Halo world unit in centimetres; the remake mirrors Y
local function ce_to_ue(p) return { X = p[1] * WU, Y = -p[2] * WU, Z = p[3] * WU } end

-- Blam scenario points for the bridge (CE a10, flag keyes_deck and nearby)
local KEYES_DECK = { 2.2010, -0.0163, -0.3999 }
local CAMERA_AT = { 1.0380, 0.5731, -0.2163 } -- keyes_x10_deck_1a

local state = { done = false, world = nil, actors = {} }

local function cls(path)
    local c = StaticFindObject(path)
    assert(c and c:IsValid(), "class missing " .. path)
    return c
end

local function world()
    local w = FindFirstOf("World")
    assert(w and w:IsValid(), "no world")
    return w
end

local function spawn(class_path, loc, rot)
    local a = world():SpawnActor(cls(class_path), loc, rot or { Pitch = 0, Yaw = 0, Roll = 0 })
    assert(a and a:IsValid(), "spawn failed " .. class_path)
    state.actors[#state.actors + 1] = a
    return a
end

local function add_component(actor, class_path)
    local c = actor:AddComponentByClass(cls(class_path), false,
        { Translation = { X = 0, Y = 0, Z = 0 }, Rotation = { X = 0, Y = 0, Z = 0, W = 1 }, Scale3D = { X = 1, Y = 1, Z = 1 } }, false)
    assert(c and c:IsValid(), "component failed " .. class_path)
    return c
end

-- 1. The cinematic video: list players and close the one that plays
local function stop_videos()
    local n = 0
    for _, mp in ipairs(FindAllOf("MediaPlayer") or {}) do
        local playing = mp:IsPlaying()
        local url = mp:GetUrl():ToString()
        log("  player %s playing=%s url=%s", name_of(mp), tostring(playing), url)
        if playing and url:find("CinematicsPreRenders") then mp:Close(); n = n + 1 end
    end
    return "closed " .. n
end

local function dump_cinematic_classes()
    for _, path in ipairs({ "/Script/BlamEngine.BlamCinematicSubsystem", "/Script/BlamEngine.BlamCinematicCamera",
        "/Script/BlamEngine.BlamCampaignFlowGameSubsystem" }) do
        local c = StaticFindObject(path)
        if c and c:IsValid() then
            c:ForEachFunction(function(fn)
                local ps = {}
                fn:ForEachProperty(function(p) ps[#ps + 1] = p:GetFName():ToString() .. ":" .. p:GetClass():GetFName():ToString() end)
                log("  %s:%s(%s)", path:match("%.(.+)$"), fn:GetFName():ToString(), table.concat(ps, ", "))
            end)
            c:ForEachProperty(function(p) log("  %s.%s:%s", path:match("%.(.+)$"), p:GetFName():ToString(), p:GetClass():GetFName():ToString()) end)
        else
            log("  missing %s", path)
        end
    end
    for _, o in ipairs(FindAllOf("BlamCinematicSubsystem") or {}) do log("  instance %s", name_of(o)) end
    for _, o in ipairs(FindAllOf("BlamCinematicCamera") or {}) do log("  camera instance %s", name_of(o)) end
end

-- 2. Camera: a camera actor at an original camera point, made the view target
local function take_camera()
    local loc = ce_to_ue(CAMERA_AT)
    local cam = spawn("/Script/Engine.CameraActor", loc, { Pitch = -5, Yaw = 30, Roll = 0 })
    state.cam = cam
    local pc = FindFirstOf("PlayerController")
    pc:SetViewTargetWithBlend(cam, 0, 0, 0, false)
    -- keep the World Partition cells around the camera loaded
    pcall(function()
        local src = add_component(cam, "/Script/Engine.WorldPartitionStreamingSourceComponent")
        src:EnableStreamingSource()
        log("  streaming source added")
    end)
    return name_of(cam)
end

-- 3. Keyes: his remake body, head and hair as poseable meshes at his original mark
local KEYES_MESHES = {
    "/Game/characters/keyes/Common/Skeleton/SK_Keyes.SK_Keyes",
    "/Game/MetaHumans/CaptainKeyes_Head/Mesh/Face/SK_CaptainKeyes_Head_Gameplay.SK_CaptainKeyes_Head_Gameplay",
    "/Game/MetaHumans/CaptainKeyes_Head/Mesh/Hair/SK_CaptainKeyes_Hair_Gameplay.SK_CaptainKeyes_Hair_Gameplay",
}

local function place_keyes()
    local actor = spawn("/Script/Engine.Actor", ce_to_ue(KEYES_DECK))
    state.keyes = actor
    local comps = {}
    for i, path in ipairs(KEYES_MESHES) do
        local mesh = LoadAsset(path)
        log("  asset %s -> %s", path, name_of(mesh))
        if mesh and mesh:IsValid() then
            local c = add_component(actor, "/Script/Engine.PoseableMeshComponent")
            local ok = pcall(function() c:SetSkinnedAssetAndUpdate(mesh, false) end)
            if not ok then pcall(function() c:SetSkeletalMesh(mesh, false) end) end
            if i > 1 and comps[1] then pcall(function() c:SetLeaderPoseComponent(comps[1], false, false) end) end
            comps[#comps + 1] = c
            local n = c:GetNumBones()
            log("  component %d bones=%d", i, n)
            if i == 1 then
                for b = 0, n - 1 do
                    local bn = c:GetBoneName(b):ToString()
                    local t = c:GetBoneTransformByName(FName(bn), 1)
                    log("    bone %d %s parent=%s pos=(%.1f %.1f %.1f) q=(%.3f %.3f %.3f %.3f)", b, bn,
                        c:GetParentBone(FName(bn)):ToString(), t.Translation.X, t.Translation.Y, t.Translation.Z,
                        t.Rotation.X, t.Rotation.Y, t.Rotation.Z, t.Rotation.W)
                end
            end
        end
    end
    state.keyes_comps = comps
    actor:K2_SetActorLocation(ce_to_ue(KEYES_DECK), false, {}, true)
    return #comps .. " meshes"
end

-- 4. Pose test: swing one arm bone in component space
local function pose_test()
    local c = state.keyes_comps and state.keyes_comps[1]
    assert(c, "no keyes")
    local target
    for b = 0, c:GetNumBones() - 1 do
        local bn = c:GetBoneName(b):ToString()
        if bn:lower():find("upperarm") or bn:lower():find("upper_arm") or bn:lower():find("arm_l") then target = bn; break end
    end
    assert(target, "no arm bone found")
    c:SetBoneRotationByName(FName(target), { Pitch = 0, Yaw = 0, Roll = 80 }, 1)
    local r = c:GetBoneRotationByName(FName(target), 1)
    return string.format("%s -> (%.1f %.1f %.1f)", target, r.Pitch, r.Yaw, r.Roll)
end

-- 5. Voice: an original line decoded from the player's MCC, played by a media player
local function play_voice()
    local file = (os.getenv("LOCALAPPDATA") or "") .. "\\OriginalCinematics\\cache\\keyes02.wav"
    local f = io.open(file, "rb"); assert(f, "missing " .. file); f:close()
    local mp = StaticConstructObject(cls("/Script/MediaAssets.MediaPlayer"), state.keyes)
    assert(mp and mp:IsValid(), "no media player")
    mp.PlayOnOpen = true
    local snd = add_component(state.keyes, "/Script/MediaAssets.MediaSoundComponent")
    snd:SetMediaPlayer(mp)
    state.voice_player, state.voice_sound = mp, snd
    local opened = mp:OpenUrl("file://" .. file:gsub("\\", "/"))
    return "open=" .. tostring(opened)
end

-- 6. Runtime-built shape (Cortana placeholder route): one triangle
local function proc_mesh()
    local actor = spawn("/Script/Engine.Actor", ce_to_ue({ 2.0, 0.3, -0.2 }))
    local pm = add_component(actor, "/Script/ProceduralMeshComponent.ProceduralMeshComponent")
    pm:CreateMeshSection_LinearColor(0,
        { { X = 0, Y = 0, Z = 0 }, { X = 0, Y = 60, Z = 0 }, { X = 0, Y = 0, Z = 120 } },
        { 0, 1, 2 }, {}, {}, {}, {}, {}, {}, {}, false)
    return "sections=" .. tostring(pm:GetNumSections())
end

local function run()
    log("==== lab start in %s", name_of(FindFirstOf("World")))
    try("dump cinematic classes", dump_cinematic_classes)
    try("stop videos", stop_videos)
    try("take camera", take_camera)
    try("place keyes", place_keyes)
    try("pose test", pose_test)
    try("play voice", play_voice)
    try("procedural mesh", proc_mesh)
    log("==== lab steps done")
end

function Lab.start(mod_dir)
    log_file = io.open(mod_dir .. "lab.log", "a")
    log("==== lab armed")
    local ticks = 0
    LoopAsync(1000, function()
        ExecuteInGameThread(function()
            local ok, err = pcall(function()
                local w = FindFirstOf("World")
                local wn = name_of(w)
                if wn:find("/A15/") then
                    ticks = ticks + 1
                    if ticks == 6 and not state.done then state.done = true; run() end
                    if state.done and ticks % 2 == 0 then
                        pcall(stop_videos)
                        local pc = FindFirstOf("PlayerController")
                        if state.cam and pc then
                            local vt = name_of(pc:GetViewTarget())
                            log("  view target %s", vt)
                            if not vt:find("CameraActor") then pc:SetViewTargetWithBlend(state.cam, 0, 0, 0, false) end
                        end
                        if state.voice_player then
                            log("  voice playing=%s time=%s", tostring(state.voice_player:IsPlaying()),
                                tostring(state.voice_player:GetTime().Ticks))
                        end
                    end
                else
                    ticks = 0
                end
            end)
            if not ok then log("loop error %s", tostring(err)) end
        end)
        return false
    end)
end

return Lab
