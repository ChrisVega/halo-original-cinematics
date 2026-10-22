-- Loads everything one original cutscene needs from the player's MCC map and
-- builds its timeline: scenario, decompiled scripts, animation graphs (cached),
-- decoded animations (cached) and the sounds' lengths.

local ce_map = require("ce_map")
local ce_script = require("ce_script")
local ce_anim = require("ce_anim")
local T = require("ce_timeline")

local Scene = {}
Scene.__index = Scene

function Scene.load(map_path, sound)
    local map = assert(ce_map.open(map_path))
    local self = setmetatable({ map = map, sound = sound, graphs = {}, decoded = {} }, Scene)
    self.scenario = map:read_scenario()
    self.scripts = ce_script.read(map)
    return self
end

function Scene:graph(path)
    if not path then return nil end
    local key = path:lower()
    local g = self.graphs[key]
    if g == nil then
        local t = self.map.by_path[path .. ".antr"]
        if not t then
            for k, v in pairs(self.map.by_path) do
                if k:lower() == key .. ".antr" then t = v; break end
            end
        end
        -- an object whose graph lives elsewhere (crewmen use the marine's):
        -- the object tag's animation graph reference
        if not t then
            for _, ext in ipairs({ ".bipd", ".vehi", ".scen" }) do
                local o = self.map.by_path[path .. ext]
                local ok, d = false, nil
                if o then ok, d = pcall(self.map.dependency, self.map, o.data + 0x38) end
                if ok and d and d.path then t = self.map.by_path[d.path .. ".antr"]; break end
            end
        end
        g = t and ce_anim.read_graph(self.map, t) or false
        self.graphs[key] = g
    end
    return g or nil
end

-- frames of an animation, decoded once
function Scene:frames(anim)
    local f = self.decoded[anim]
    if not f then f = ce_anim.decode(self.map, anim); self.decoded[anim] = f end
    return f
end

-- Some of the marine graph's animations read back as garbage from the map
-- (stand pistol/rifle move-front, turns, aims): finite, sane numbers only.
function Scene:anim_ok(anim)
    if anim._ok == nil then
        local ok, fr = pcall(self.frames, self, anim)
        local good = ok and fr ~= nil
        if good then
            for _, f in pairs(fr) do
                for _, x in pairs(f) do
                    for k = 1, 3 do
                        local v = x.pos and x.pos[k] or 0
                        if v ~= v or math.abs(v) > 5 then good = false end
                    end
                    for k = 1, 4 do
                        local v = x.rot and x.rot[k] or 0
                        if v ~= v then good = false end
                    end
                end
                if not good then break end
            end
        end
        anim._ok = good
    end
    return anim._ok
end

-- Every sound tag the script tree of `root` (and the scripts it calls or wakes) uses.
function Scene:sounds_used(root)
    local seen, names, set = {}, {}, {}
    local scripts = self.scripts.scripts
    local function walk(e)
        if type(e) ~= "table" then return end
        if e.fn then
            if (e.fn == "sound_impulse_start" or e.fn == "sound_looping_start" or e.fn == "sound_impulse_time")
                and e.args[1] and e.args[1].value then
                local n = e.args[1].value
                if not set[n] then set[n] = true; names[#names + 1] = n end
            end
            local target = scripts[e.fn] and e.fn or (e.fn == "wake" and e.args[1] and e.args[1].value)
            if target and scripts[target] and not seen[target] then seen[target] = true; walk(scripts[target].body) end
            for _, a in ipairs(e.args) do walk(a) end
        end
    end
    for r in root:gmatch("[^,]+") do seen[r] = true; walk(scripts[r].body) end
    return names
end

-- opts (scenes sheet, per scene; nil for the bridge): fly_to = where each flying
-- vehicle ends, camera_remake = keep the remake's camera, math_ops = max/min work
function Scene:timeline(root, opts)
    opts = opts or {}
    local tl = T.new({
        fly_to = opts.fly_to, camera_remake = opts.camera_remake, math_ops = opts.math_ops,
        map = self.map, scenario = self.scenario, scripts = self.scripts,
        graphs = function(p) return self:graph(p) end,
        anim_ok = function(a) return self:anim_ok(a) end,
        borrow = function(tag) return self.borrow and tag and self.borrow[tag:lower()] or nil end,
        sound_ticks = function(n)
            local w = self.sound and self.sound:wav(n)
            if w then return math.floor(self.sound.wav_seconds(w) * 30 + 0.5) end
            return 60
        end,
    })
    tl:start(root)
    return tl
end

return Scene
