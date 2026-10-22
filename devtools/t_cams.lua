local ce = require("ce_map")
local m = assert(ce.open(arg[1]))
local s = m:read_scenario()
for n, c in pairs(s.cameras) do
  print(string.format("%s\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f", n, c.pos[1], c.pos[2], c.pos[3], c.rot[1], c.rot[2], c.rot[3], c.fov))
end
