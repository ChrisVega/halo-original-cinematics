local ce = require("ce_map"); local cs = require("ce_script")
local m = assert(ce.open(arg[1]))
local s = cs.read(m)
for _, n in ipairs({"x10", "autumn_glory_1"}) do print(n, s.scripts[n].type, cs.format(s.scripts[n].body)) end
