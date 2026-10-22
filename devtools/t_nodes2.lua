local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local g = sc:graph([[characters\crewman\crewman]])
for i, n in pairs(g.nodes) do print(i, n.name, n.parent) end
