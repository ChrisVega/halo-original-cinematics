-- Scout pass: records how Campaign Evolved plays its cinematics, what the
-- characters' skeletons look like and where the player stands, so the real
-- cutscene player is built from facts. Read-only: it changes nothing in game.

local Probe = {}

local log_file
local function log(fmt, ...)
    local line = select("#", ...) == 0 and fmt or string.format(fmt, ...)
    if log_file then
        log_file:write(os.date("%H:%M:%S "), line, "\n")
        log_file:flush()
    end
    print("[OriginalCinematics] " .. line .. "\n")
end

local function safe(fn, ...)
    local ok, a, b, c = pcall(fn, ...)
    if ok then return a, b, c end
    return nil
end

local function name_of(obj)
    return safe(function() return obj:GetFullName() end) or "?"
end

local function str(v)
    if v == nil then return "nil" end
    local t = type(v)
    if t == "userdata" then
        local s = safe(function() return v:ToString() end)
        if s then return s end
        s = safe(function() return v:get():ToString() end)
        if s then return s end
        return name_of(v)
    end
    return tostring(v)
end

local function vec(v)
    if not v then return "nil" end
    return string.format("(%.2f, %.2f, %.2f)", v.X or 0, v.Y or 0, v.Z or 0)
end

local function rot(r)
    if not r then return "nil" end
    return string.format("(p=%.2f, y=%.2f, r=%.2f)", r.Pitch or 0, r.Yaw or 0, r.Roll or 0)
end

-- Media: which video plays, opened by whom ------------------------------------
local media_functions = {
    "/Script/MediaAssets.MediaPlayer:OpenSource",
    "/Script/MediaAssets.MediaPlayer:OpenFile",
    "/Script/MediaAssets.MediaPlayer:OpenUrl",
    "/Script/MediaAssets.MediaPlayer:OpenPlaylist",
    "/Script/MediaAssets.MediaPlayer:OpenPlaylistIndex",
    "/Script/MediaAssets.MediaPlayer:Play",
    "/Script/MediaAssets.MediaPlayer:Close",
    "/Script/MediaAssets.FileMediaSource:SetFilePath",
}

local function hook_media()
    for _, path in ipairs(media_functions) do
        local ok, err = pcall(function()
            RegisterHook(path, function(self, a, b)
                local player = self:get()
                local arg = ""
                if a then
                    local src = safe(function() return a:get() end)
                    if src and type(src) == "userdata" then
                        arg = name_of(src)
                        local fp = safe(function() return src.FilePath:ToString() end)
                        if fp then arg = arg .. " file=" .. fp end
                    else
                        arg = str(src)
                    end
                end
                log("MEDIA %s player=%s outer=%s arg=%s", path:match(":(.+)$"),
                    name_of(player), name_of(safe(function() return player:GetOuter() end)), arg)
            end)
        end)
        log("hook %s -> %s", path, ok and "ok" or tostring(err))
    end
    for _, cls in ipairs({ "/Script/MediaAssets.MediaPlayer", "/Script/MediaAssets.FileMediaSource",
        "/Script/MediaAssets.MediaSoundComponent" }) do
        pcall(function()
            NotifyOnNewObject(cls, function(obj)
                log("NEW %s", name_of(obj))
            end)
        end)
    end
end

-- Reflection dumps -------------------------------------------------------------
local function dump_functions(class_path)
    local cls = StaticFindObject(class_path)
    if not cls or not cls:IsValid() then
        log("class %s not found", class_path)
        return
    end
    log("CLASS %s", class_path)
    pcall(function()
        cls:ForEachFunction(function(fn)
            local params = {}
            pcall(function()
                fn:ForEachProperty(function(p)
                    params[#params + 1] = p:GetFName():ToString() .. ":" .. p:GetClass():GetFName():ToString()
                end)
            end)
            log("  fn %s(%s)", fn:GetFName():ToString(), table.concat(params, ", "))
        end)
    end)
    pcall(function()
        cls:ForEachProperty(function(p)
            log("  prop %s:%s", p:GetFName():ToString(), p:GetClass():GetFName():ToString())
        end)
    end)
end

local class_dump_done = false
local function dump_interesting_classes()
    if class_dump_done then return end
    class_dump_done = true
    local found = {}
    pcall(function()
        ForEachUObject(function(obj)
            local cname = safe(function() return obj:GetClass():GetFName():ToString() end)
            if cname == "Class" or cname == "BlueprintGeneratedClass" or cname == "WidgetBlueprintGeneratedClass" then
                local n = name_of(obj)
                local l = n:lower()
                if l:find("cinemat") or l:find("movie") or l:find("media") or l:find("campaign")
                    or l:find("cutscene") or l:find("sequence") or l:find("keyes") or l:find("cortana") then
                    found[#found + 1] = n
                end
            end
        end)
    end)
    table.sort(found)
    log("INTERESTING CLASSES (%d)", #found)
    for _, n in ipairs(found) do log("  %s", n) end
end

local function dump_bones(comp, label)
    local n = safe(function() return comp:GetNumBones() end) or 0
    local mesh = safe(function() return comp.SkeletalMeshAsset end) or safe(function() return comp.SkeletalMesh end)
    log("BONES %s mesh=%s count=%d", label, name_of(mesh), n)
    for i = 0, n - 1 do
        local bn = safe(function() return comp:GetBoneName(i):ToString() end) or "?"
        local parent = safe(function() return comp:GetParentBone(comp:GetBoneName(i)):ToString() end) or "?"
        local t = safe(function() return comp:GetRefPoseTransform(i) end)
        local p = t and t.Translation or safe(function() return comp:GetRefPosePosition(i) end)
        local q = t and t.Rotation
        log("  %d %s parent=%s ref=%s q=%s", i, bn, parent, vec(p),
            q and string.format("(%.4f,%.4f,%.4f,%.4f)", q.X, q.Y, q.Z, q.W) or "nil")
    end
end

local dumped_meshes = {}
local function dump_characters()
    local comps = FindAllOf("SkeletalMeshComponent") or {}
    for _, comp in ipairs(comps) do
        local mesh = safe(function() return comp.SkeletalMeshAsset end) or safe(function() return comp.SkeletalMesh end)
        local mname = name_of(mesh)
        local l = mname:lower()
        if not dumped_meshes[mname] and (l:find("keyes") or l:find("cortana") or l:find("chief")
            or l:find("spartan") or l:find("captain") or l:find("crew") or l:find("marine")
            or l:find("johnson") or l:find("cryo")) then
            dumped_meshes[mname] = true
            local owner = safe(function() return comp:GetOwner() end)
            log("CHAR owner=%s at %s", name_of(owner), vec(safe(function() return owner:K2_GetActorLocation() end)))
            dump_bones(comp, name_of(comp))
        end
    end
end

-- Periodic world state ----------------------------------------------------------
local last_world = ""
local function tick()
    local world = safe(function() return FindFirstOf("World") end)
    local wname = name_of(world)
    if wname ~= last_world then
        last_world = wname
        log("WORLD %s", wname)
        local levels = FindAllOf("Level") or {}
        for _, lv in ipairs(levels) do log("  level %s", name_of(lv)) end
    end
    local pc = safe(function() return FindFirstOf("PlayerController") end)
    if pc and pc:IsValid() then
        local pawn = safe(function() return pc.Pawn end)
        if pawn and pawn:IsValid() then
            log("PAWN %s at %s %s", name_of(pawn:GetClass()), vec(safe(function() return pawn:K2_GetActorLocation() end)),
                rot(safe(function() return pawn:K2_GetActorRotation() end)))
            local sync = safe(function()
                return pawn:GetComponentByClass(StaticFindObject("/Script/BlamSynchronization.BlamObjectSynchronizationComponent"))
            end)
            if sync and sync:IsValid() then
                log("  blam index=%s tag=%s", str(safe(function() return sync.BlamObjectIndex end)),
                    str(safe(function() return sync.BlamTagDefinitionIndex end)))
            end
        end
        local cam = safe(function() return pc.PlayerCameraManager end)
        if cam and cam:IsValid() then
            log("CAM %s %s fov=%.2f target=%s", vec(safe(function() return cam:GetCameraLocation() end)),
                rot(safe(function() return cam:GetCameraRotation() end)), safe(function() return cam:GetFOVAngle() end) or -1,
                name_of(safe(function() return cam.ViewTarget.Target end)))
        end
    end
    dump_characters()
end

function Probe.start(mod_dir)
    log_file = io.open(mod_dir .. "probe.log", "a")
    log("==== probe start")
    hook_media()
    local n = 0
    LoopAsync(2000, function()
        n = n + 1
        ExecuteInGameThread(function()
            local ok, err = pcall(tick)
            if not ok then log("tick error %s", tostring(err)) end
            if n == 15 then
                pcall(dump_interesting_classes)
                for _, c in ipairs({
                    "/Script/BlamCampaign.BlamCampaignFlowGameSubsystem",
                    "/Script/BlamSavedFilm.BlamSavedFilmGameInstanceSubsystem",
                    "/Script/BlamSynchronization.BlamObjectSynchronizationComponent",
                    "/Script/Engine.PoseableMeshComponent",
                }) do pcall(dump_functions, c) end
            end
        end)
        return false
    end)
end

return Probe
