local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local map = sc.map
for _, path in ipairs({
  "levels\\a10\\devices\\chairs\\chair pilot\\chair pilot",
  "levels\\a10\\devices\\chairs\\chair pod\\chair pod",
}) do
  local mt = map.by_path[path .. ".mod2"]
  print("model", path, mt and "found" or "MISSING")
  if mt then
    for _, m in map:each(mt.data + 0xAC, 64) do
      local name = map:str32(m)
      io.write("  marker ", name, ":")
      for _, inst in map:each(m + 52, 32) do
        local x, y, z = string.unpack("<fff", map.tag_data, map:ofs(inst + 4))
        io.write(string.format(" (%.3f, %.3f, %.3f)", x, y, z))
      end
      print()
    end
  end
end
