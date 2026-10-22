local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local g = sc:graph([[characters\marine\marine]])
local names = {}
for n in pairs(g.by_name) do if n:find("move%-front") or n:find(" idle") then names[#names+1] = n end end
table.sort(names)
for _, n in ipairs(names) do
  local fr = sc:frames(g.by_name[n])
  local ok = true
  for _, f in pairs(fr) do for _, x in pairs(f) do for k = 1, 3 do local v = x.pos[k]; if v ~= v or math.abs(v) > 5 then ok = false end end end end
  print(ok and "ok " or "BAD", n)
end
