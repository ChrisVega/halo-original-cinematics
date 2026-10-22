-- Original Cinematics: Halo: Campaign Evolved plays Halo: Combat Evolved's
-- original cutscenes in real time, read from the player's own Master Chief
-- Collection (cameras, script, animations, voices, music). Nothing from either
-- game ships with the mod.

local function mod_dir()
    local src = debug.getinfo(1, "S").source:gsub("^@", "")
    return src:gsub("[/\\]Scripts[/\\]main%.lua$", "") .. "\\"
end

local DIR = mod_dir()
-- which mission the unattended test starts (test_level.txt beside the mod, else A15)
local TEST_LEVEL = "A15"
do local f = io.open(DIR .. "test_level.txt", "rb"); if f then TEST_LEVEL = (f:read("l") or "A15"):match("%w+") or "A15"; f:close() end end
package.path = DIR .. "Scripts\\?.lua;" .. package.path

local DATA = (os.getenv("LOCALAPPDATA") or DIR) .. "\\OriginalCinematics"
do
    local probe = io.open(DATA .. "\\cache\\.probe", "wb")
    if probe then probe:close() else os.execute('mkdir "' .. DATA .. '\\cache" >nul 2>&1') end
end

local log_file = io.open(DATA .. "\\OriginalCinematics.log", "a")
local function log(fmt, ...)
    local line = select("#", ...) == 0 and fmt or string.format(fmt, ...)
    if log_file then log_file:write(os.date("%H:%M:%S "), line, "\n"); log_file:flush() end
    print("[OriginalCinematics] " .. line .. "\n")
end

local function exists(p) local f = io.open(p, "rb"); if f then f:close(); return true end; return false end

-- The player's MCC: Melty passes its folder; otherwise look in Steam's libraries.
-- Melty writes the player's folders into the mod's .env before every Play.
local function env_file(key)
    local f = io.open(DATA .. "/.env", "rb")
    if not f then return nil end
    local text = f:read("a"); f:close()
    local v = text:match(key .. '%s*=%s*"([^"\r\n]*)"') or text:match(key .. "%s*=%s*([^\r\n]*)")
    if v and v ~= "" then return (v:gsub("/", "\\")) end
end

local function find_mcc()
    local env = env_file("ORIGINAL_CINEMATICS_MCC_DIR") or os.getenv("OC_MCC_DIR")
    if env and exists(env .. "\\halo1\\maps\\a10.map") then return env end
    local steam = { "C:\\Program Files (x86)\\Steam", "C:\\Program Files\\Steam" }
    local libs = {}
    for _, s in ipairs(steam) do
        libs[#libs + 1] = s
        local f = io.open(s .. "\\steamapps\\libraryfolders.vdf", "rb")
        if f then
            for p in f:read("a"):gmatch('"path"%s+"([^"]+)"') do libs[#libs + 1] = p:gsub("\\\\", "\\") end
            f:close()
        end
    end
    for _, l in ipairs(libs) do
        local d = l .. "\\steamapps\\common\\Halo The Master Chief Collection"
        if exists(d .. "\\halo1\\maps\\a10.map") then return d end
    end
end

local sheets = require("sheets_gen")
local characters = {}
for _, c in ipairs(sheets.characters) do characters[c.ce_tag:lower()] = c end

local MCC = find_mcc()
log("==== Original Cinematics 0.3.003 starting; MCC at %s", tostring(MCC))

local Scene = require("ce_scene")
local Sound = require("ce_sound")
local RideWatch = require("ride_watch")
local sound, scenes = nil, {}

local function new_sound()
    return Sound.new(MCC .. "\\halo1\\sound\\pc", DIR .. "tools\\vgmstream\\vgmstream-cli.exe",
        DATA .. "\\cache", DIR .. "tools\\ffmpeg\\ffmpeg.exe")
end

local function load_scene(map_id)
    local t0 = os.clock()
    sound = sound or new_sound()
    if not scenes[map_id] then
        scenes[map_id] = Scene.load(MCC .. "\\halo1\\maps\\" .. map_id .. ".map", sound)
        -- borrowed animation graphs (characters sheet)
        local borrow = {}
        for _, c in ipairs(sheets.characters) do
            if c.borrow_graph and c.borrow_graph ~= "-" then borrow[c.ce_tag:lower()] = c.borrow_graph end
        end
        scenes[map_id].borrow = borrow
        log("loaded %s in %.1fs", map_id, os.clock() - t0)
    end
    return scenes[map_id], sound
end

-- Melty's automatic test leaves a file naming the checks it watches. While it
-- exists, start the first mission by itself and append a line per check.
local TEST = (function()
    local dir = (os.getenv("LOCALAPPDATA") or "") .. "\\Melty\\test\\"
    for _, name in ipairs({ "original-cinematics.json", "original-cinematics-2.json" }) do
        local f = io.open(dir .. name, "rb")
        if f then
            local body = f:read("a"); f:close()
            -- a JSON string: read up to the first unescaped quote, then unescape
            -- (Lua patterns have no alternation, so scan it by hand)
            local checks
            local s = select(2, body:find('"checks"%s*:%s*"'))
            if s then
                local out, i = {}, s + 1
                while i <= #body do
                    local ch = body:sub(i, i)
                    if ch == "\\" then out[#out + 1] = body:sub(i + 1, i + 1); i = i + 2
                    elseif ch == '"' then break
                    else out[#out + 1] = ch; i = i + 1 end
                end
                checks = table.concat(out)
            end
            return { checks = checks, seed = tonumber(body:match('"seed"%s*:%s*(-?%d+)')) }
        end
    end
end)()

if TEST then log("test mode: checks file %s", tostring(TEST.checks)) end

local CHECK_NAMES = { ready = "ready", scene_started = "scene-started", scene_finished = "scene-finished" }
local function report(key, value)
    log("Melty check %s: %s", key, tostring(value))
    local name = CHECK_NAMES[key]
    if TEST and TEST.checks and name then
        local text = tostring(value)
        local line
        if text:match("^fail") then line = "fail " .. name .. ": " .. text:gsub("^fail:?%s*", "") .. "\n"
        else line = "pass " .. name .. "\n" end
        local f = io.open(TEST.checks, "ab")
        if f then f:write(line); f:close() end
    end
end


local ready = false

local director = require("director").new({
    log = log, sheets = sheets, characters = characters, report = report,
    load_scene = load_scene, mcc = MCC, cache = DATA .. "\\cache", mod_dir = DIR,
})

-- Textures of characters drawn from the player's Halo 2 Anniversary files:
-- each picture becomes a .dds and then, with the bundled ffmpeg, a .png in
-- the mod's cache, which the remake loads at the scene.
local function prepare_h2a()
    local H = require("h2a")
    for _, row in ipairs(sheets.characters) do
        local h2 = row.h2a
        if h2 and h2.tpl then
            local pck = MCC .. "\\halo2\\preload\\paks\\shared.pck"
            local h, err = H.open(pck)
            if not h then log("h2a: %s", tostring(err)); return end
            local tpl = h:template(h2.tpl, function(sm, i) return false end)
            local names = {}
            for _, sm in ipairs(tpl and tpl.subs or {}) do
                if sm.mat and sm.mat.texture ~= "" then names[sm.mat.texture] = true end
            end
            for tex in pairs(names) do
                local png = DATA .. "\\cache\\h2a_" .. tex .. (h2.png_suffix or "") .. ".png"
                if not exists(png) then
                    local pic = h:picture(tex .. ".pct")
                    local dds = pic and H.dds(pic)
                    if dds then
                        local tmp = DATA .. "\\cache\\h2a_" .. tex .. ".dds"
                        local f = io.open(tmp, "wb"); f:write(dds); f:close()
                        os.execute('cmd /c ""' .. DIR .. 'tools\\ffmpeg\\ffmpeg.exe" -hide_banner -loglevel error -y -i "'
                            .. tmp .. '"' .. (h2.png_filter and (' -vf "' .. h2.png_filter .. '"') or '')
                            .. ' "' .. png .. '""')
                        os.remove(tmp)
                    end
                end
                log("h2a texture %s: %s", tex, exists(png) and "ready" or "missing")
                -- her colours for painting onto the model's points (use "vertex"):
                -- the texture tinted as the hologram, 256x256 raw RGBA
                if h2.vertex_filter then
                    local raw = DATA .. "\\cache\\h2a_" .. tex .. ".vtx2.rgba"
                    if not exists(raw) then
                        local pic = h:picture(tex .. ".pct")
                        local dds = pic and H.dds(pic)
                        if dds then
                            local tmp = DATA .. "\\cache\\h2a_" .. tex .. ".dds"
                            local f = io.open(tmp, "wb"); f:write(dds); f:close()
                            os.execute('cmd /c ""' .. DIR .. 'tools\\ffmpeg\\ffmpeg.exe" -hide_banner -loglevel error -y -i "'
                                .. tmp .. '" -vf "' .. h2.vertex_filter .. ',scale=256:256,format=rgba" -f rawvideo -pix_fmt rgba "' .. raw .. '""')
                            os.remove(tmp)
                        end
                    end
                    log("h2a vertex colours %s: %s", tex, exists(raw) and "ready" or "missing")
                end
            end
            h:close()
        end
    end
end

-- Everything that touches the game runs from callbacks on the game's own
-- frame loop. (Queuing a fresh ExecuteInGameThread from an async loop every
-- 16 ms raced the loader's callback registry and got the hook dropped
-- mid-scene: "Ref was not function ... removing hook", camera frozen.)
-- Touch the game only once a mission level has been up for a few seconds;
-- while levels load or at the menus, look just twice a second.
local settled = { world = nil, since = 0, frames = 0 }
local ride = require("ride").new({
    log = log, sheets = sheets, report = report,
    get_sound = function() sound = sound or new_sound(); return sound end,
})
local function frame()
    settled.frames = settled.frames + 1
    -- read-only ride survey (only with <mod>\dev\enabled present)
    local _w = FindFirstOf("World")
    local _wn = ((_w and _w:IsValid()) and _w:GetFullName() or ""):gsub("/_Generated_/.*$", ""):gsub("%.[^/]*$", "")
    RideWatch.maybe(_wn)
    if ride.active or (_wn:find("/Levels/Halo1/") and not director.active) then
        local ok, err = pcall(ride.update, ride, _wn)
        if not ok then log("ride error: %s", tostring(err)); ride.active = nil end
    end
    if director.active then
        local ok, err = pcall(director.update, director)
        if not ok then log("director error: %s", tostring(err)); pcall(director.stop, director, "error") end
        return
    end
    if settled.frames % 30 ~= 0 then return end
    local w = FindFirstOf("World")
    -- streamed cells report their own world names; key on the level itself
    local wn = ((w and w:IsValid()) and w:GetFullName() or ""):gsub("/_Generated_/.*$", ""):gsub("%.[^/]*$", "")
    if wn ~= settled.world then settled.world, settled.since = wn, os.time(); return end
    if not wn:find("/Levels/Halo1/") or os.time() - settled.since < 3 then return end
    local ok, err = pcall(director.update, director)
    if not ok then
        log("director error: %s", tostring(err))
        pcall(director.stop, director, "error")
    end
end

-- Test mode for Melty's automatic test: start the first mission by itself.
-- Started straight from the title screen, the mission loads but stays on its
-- loading screen for good (the title's "press Enter" signs the player in and
-- loads their profile, which the mission waits for). So the title screen is
-- passed first (Melty's test input presses Enter), and the mission is started
-- once the title has gone and the front end's menus are up.
local TITLE_MARKS = { "Title", "PressStart", "Press", "Attract", "Splash", "Intro" }
local function viewport_widgets()
    local names = {}
    local ok, list = pcall(FindAllOf, "UserWidget")
    for _, w in ipairs(ok and list or {}) do
        pcall(function() if w:IsInViewport() then names[#names + 1] = w:GetClass():GetFName():ToString() end end)
    end
    table.sort(names)
    return names
end

-- Started from the menus by test mode, the title screen's background video
-- stays up behind the mission: take its widget down and close its player.
local function close_menu_video()
    local n = 0
    pcall(function()
        local list = FindAllOf("WBP_MenuVideo_C") or {}
        if type(list) ~= "table" then list = { list } end
        for _, wdg in ipairs(list) do
            if wdg:IsValid() then pcall(function() wdg:RemoveFromParent() end); n = n + 1 end
        end
    end)
    local m = 0
    pcall(function()
        local list = FindAllOf("MediaPlayer") or {}
        if type(list) ~= "table" then list = { list } end
        for _, mp in ipairs(list) do
            local url = ""
            pcall(function() url = mp:GetUrl():ToString() end)
            local playing = false
            pcall(function() playing = mp:IsPlaying() end)
            local name = ""
            pcall(function() name = mp:GetFName():ToString() end)
            -- only the front end's own background video; the mission's intro and
            -- its cutscene players must be left alone or the level never starts
            if playing and (url:find("MainMenu", 1, true) or name:find("MainMenu", 1, true)) then
                pcall(function() mp:Close() end); m = m + 1
                log("test mode: closed media %s (%s)", name, url)
            end
        end
    end)
    if n + m > 0 then log("test mode: menu video closed (%d widgets, %d players)", n, m) end
end

local function test_start()
    local last_try, tries, last_seen, last_world, title_gone_at = 0, 0, "", nil, nil
    LoopInGameThreadWithDelay(2000, function()
        if director.active then return end
        -- only until the mission's level is up: in the mission the same widget
        -- shows its intro, and taking it down every 2 s left the level waiting
        if tries > 0 and not ride.active then
            local w = FindFirstOf("World")
            local wn = (w and w:IsValid()) and w:GetFullName() or ""
            if not wn:find("/Levels/Halo1/", 1, true) then close_menu_video() end
        end
        local ok, err = pcall(function()
            local w = FindFirstOf("World")
            local wn = "none"
            pcall(function() wn = w:GetFullName() end)
            if wn ~= last_world then last_world = wn; log("test mode: world %s", wn) end
            if not wn:find("Frontend") then return end
            local names = viewport_widgets()
            local seen = table.concat(names, ",")
            if seen ~= last_seen then last_seen = seen; log("test mode: on screen %s", seen) end
            local title = false
            for _, n in ipairs(names) do
                for _, m in ipairs(TITLE_MARKS) do if n:find(m) then title = true end end
            end
            if title or #names == 0 then title_gone_at = nil; return end
            title_gone_at = title_gone_at or os.time()
            if os.time() - title_gone_at < 4 or tries >= 3 or os.time() - last_try < 15 then return end
            local sub = FindFirstOf("BlamCampaignFlowGameSubsystem")
            local camp = StaticFindObject("/Game/Blueprints/Campaign/DA_FirstPlayableCampaign.DA_FirstPlayableCampaign")
            if sub and sub:IsValid() and camp and camp:IsValid() then
                last_try, tries = os.time(), tries + 1
                local ok2, res = pcall(function()
                    return sub:SetAndBeginCampaign(camp, FName(TEST_LEVEL), { bLoadFromCoreSave = false, SaveSlot = 0, SavedFilmName = "",
                        CampaignDifficultyLevel = 1, InsertionPoint = 0, bFriendlyFireEnabled = false, bIsLASO = false })
                end)
                log("test mode: start " .. TEST_LEVEL .. " try %d (menus %s) = %s", tries, seen, tostring(res))
            end
        end)
        if not ok then log("test mode error: %s", tostring(err)) end
    end)
end

local function start_game_loops()
    LoopInGameThreadAfterFrames(1, function()
        local ok, err = pcall(frame)
        if not ok then log("frame error: %s", tostring(err)) end
    end)
    if TEST or os.getenv("OC_TEST") == "1" then test_start() end
end

if MCC then
    -- Prepare every scene's sounds once, off the game thread, then hand over
    -- to the game thread for good.
    LoopAsync(100, function()
        local ok, err = pcall(function()
            sound = Sound.new(MCC .. "\\halo1\\sound\\pc", DIR .. "tools\\vgmstream\\vgmstream-cli.exe",
                DATA .. "\\cache", DIR .. "tools\\ffmpeg\\ffmpeg.exe")
            for _, row in ipairs(sheets.scenes) do
                local sc = load_scene(row.map)
                local names = sc:sounds_used(row.ce_script)
                if row.music_start and row.music_start.sound then names[#names + 1] = row.music_start.sound end
                local n, missing = sound:prepare(names)
                log("scene %s: %d sounds (%d new steps), missing %d", row.id, #names, n, #missing)
            end
        end)
        if ok then
            local hok, herr = pcall(prepare_h2a)
            if not hok then log("h2a setup failed: %s", tostring(herr)) end
            ready = true; report("ready", "yes")
            start_game_loops()
        else
            log("setup failed: %s", tostring(err)); report("ready", "fail: " .. tostring(err))
        end
        return true
    end)
else
    log("Halo: The Master Chief Collection not found; original cutscenes are off.")
    report("ready", "fail: Halo: The Master Chief Collection not found")
end

require("repl").start(DIR, TEST ~= nil)
