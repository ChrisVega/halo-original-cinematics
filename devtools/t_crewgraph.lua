local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local g = sc:graph([[characters\crewman\crewman]])
print("graph", g)
if g then local n = {} for k in pairs(g.by_name) do n[#n+1] = k end table.sort(n) print(#n, table.concat(n, " | ")) end
