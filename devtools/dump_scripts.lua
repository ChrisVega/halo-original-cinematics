-- Dumps a CE map's scripts (offline, under lupa).
-- usage: luarun.py <mod Scripts dir> <this file> <map path> [filter]
local Map = require("ce_map")
local Script = require("ce_script")

local path = arg[1]
local filt = arg[2]
local map = Map.open(path)
local sc = Script.read(map)
map:close()

local names = {}
for name, s in pairs(sc.scripts) do names[#names + 1] = name end
table.sort(names)
for _, name in ipairs(names) do
    if not filt or name:find(filt) then
        local s = sc.scripts[name]
        print("=== " .. name .. " (" .. (s.type or "?") .. ")")
        print(Script.format(s.body))
        print("")
    end
end
