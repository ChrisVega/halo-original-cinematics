local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
for _, n in ipairs({"crewman", "captain"}) do
  local t = sc.map.by_path["characters\\" .. n .. "\\" .. n .. ".bipd"]
  print(n, t)
  if t then
    for off = 0, 0x100, 4 do local ok, d = pcall(sc.map.dependency, sc.map, t.data + off); if ok and d and d.path then print(string.format("  %x %s", off, d.path)) end end
  end
end
