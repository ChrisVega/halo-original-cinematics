local ce = require("ce_map"); local CM = require("ce_model")
local m = assert(ce.open(arg[1]))
for k, t in pairs(m.by_path) do if k:find("cortana") and k:find("mod2") then print(k) end end
local t = m.by_path[ [[characters\cortana\cortana.mod2]] ]
local model = CM.read(m, t)
local nn = 0; for _ in pairs(model.nodes) do nn = nn + 1 end
print("nodes", nn, "parts", #model.parts)
local minz, maxz = 1e9, -1e9
for i, p in ipairs(model.parts) do
  print(" part", i, "verts", p.vcount, "tris", #p.tris)
  for v = 0, p.vcount - 1 do local z = p.verts[v].pos[3]; if z < minz then minz = z end; if z > maxz then maxz = z end end
end
print("height (wu)", minz, maxz)
