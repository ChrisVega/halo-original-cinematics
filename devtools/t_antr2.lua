local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local g = sc:graph([[characters\crewman\crewman]])
print("graph", g)
local n = {} for k in pairs(g.by_name) do if k:find("idle") or k:find("move%-front") or k:find("pchair") then n[#n+1] = k end end table.sort(n) print(#n) for _, k in ipairs(n) do print(k) end
local g2 = sc:graph([[cinematicsnimations\crewman]])
local n = {} for k in pairs(g2.by_name) do n[#n+1] = k end table.sort(n) print("x10:", table.concat(n, " | "))
