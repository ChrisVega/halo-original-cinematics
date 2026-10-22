local ce = require("ce_map")
local m = assert(ce.open(arg[1]))
local s = m:read_scenario()
for i, src in pairs(s.source) do io.write("==== source ", tostring(i), "\n", src.text or "", "\n") end
