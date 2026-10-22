local M = require("ce_map")
local m = M.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
local c = m:read_scenario().cameras
local mn, mx, n = { 1e9, 1e9, 1e9 }, { -1e9, -1e9, -1e9 }, 0
for _, v in pairs(c) do
  n = n + 1
  for i = 1, 3 do
    if v.rot[i] < mn[i] then mn[i] = v.rot[i] end
    if v.rot[i] > mx[i] then mx[i] = v.rot[i] end
  end
end
print("n", n)
for i = 1, 3 do print(i, string.format("%.3f .. %.3f", mn[i], mx[i])) end
local keys = {}
for k in pairs(c) do keys[#keys + 1] = k end
table.sort(keys)
for _, k in ipairs(keys) do
  if k:find("bridge") then
    print(k, string.format("pos %.2f %.2f %.2f rot %.3f %.3f %.3f fov %.2f",
      c[k].pos[1], c[k].pos[2], c[k].pos[3], c[k].rot[1], c[k].rot[2], c[k].rot[3], c[k].fov))
  end
end

