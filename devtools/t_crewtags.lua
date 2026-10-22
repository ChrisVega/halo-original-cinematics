local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
for p in pairs(sc.map.by_path) do if (p:find("crewman") or p:find("marine")) and (p:find("%.antr$") or p:find("%.mod2$") or p:find("%.bipd$")) then print(p) end end
