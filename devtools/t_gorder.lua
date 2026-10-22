local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local function names(p) local g = sc:graph(p); local t = {}; for i = 0, 60 do if g.nodes[i] then t[#t+1] = i .. "=" .. g.nodes[i].name end end; return t end
for _, p in ipairs({[[characters\marine\marine]], [[cinematics\animations\crewman\x10\x10]], [[characters\captain\captain]], [[cinematics\animations\captain\x10\x10]]}) do
  local t = names(p); print(p, #t, table.concat(t, " ", 1, math.min(#t, 22)))
end
