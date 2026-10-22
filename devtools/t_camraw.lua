local M = require("ce_map")
local m = M.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
local s = m:scenario().data
local n = 0
for i, p in m:each(s + 0x4f0, 104) do
  local name = m:str32(p + 4)
  if name == "bridge_zoom_1a" or name == "bridge_zoom_1b" or n == 0 then
    print("point", i, name)
    for off = 32, 72, 4 do
      print(string.format("  +%d  %.4f  (0x%08x)", off, m:f32(p + off), m:u32(p + off)))
    end
  end
  n = n + 1
end
print("count", n)
