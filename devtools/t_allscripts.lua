local ce = require("ce_map")
local cs = require("ce_script")
local m = assert(ce.open(arg[1]))
local s = cs.read(m)
local names = {}
for n in pairs(s.scripts) do names[#names + 1] = n end
table.sort(names)
for _, n in ipairs(names) do
    print("=== " .. n .. " (" .. tostring(s.scripts[n].type) .. ")")
    print(cs.format(s.scripts[n].body))
    print("")
end
