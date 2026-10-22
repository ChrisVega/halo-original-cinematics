local M = require("ce_map")
local m = M.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
local s = m:scenario().data
for i, p in m:each(s + 0x4f0, 104) do
  local name = m:str32(p + 4)
  local x, y, z = m:f32(p + 40), m:f32(p + 44), m:f32(p + 48)
  if math.abs(x) < 10 and math.abs(y) < 10 and math.abs(z) < 10 then
    print(string.format("%-28s pos %7.2f %7.2f %7.2f  rot %6.3f %6.3f %6.3f", name, x, y, z,
      m:f32(p + 52), m:f32(p + 56), m:f32(p + 60)))
  end
end
