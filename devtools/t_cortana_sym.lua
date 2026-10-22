local S = require("ce_scene"); local CM = require("ce_model")
local sc = S.load(POSE_MAP, nil)
local mt = sc.map.by_path[ [[characters\cortana\cortana.mod2]] ]
local m = CM.read(sc.map, mt, 4)
local zmax, zmin = -1e9, 1e9
for _, part in ipairs(m.parts) do for v = 0, part.vcount - 1 do local z = part.verts[v].pos[3]; zmax = math.max(zmax, z); zmin = math.min(zmin, z) end end
local sy, n, sx = 0, 0, 0
for _, part in ipairs(m.parts) do for v = 0, part.vcount - 1 do local p = part.verts[v].pos
  if p[3] > zmax - (zmax - zmin) * 0.12 then sy = sy + p[2]; sx = sx + p[1]; n = n + 1 end end end
print("CE head verts", n, "mean y (left+)", sy / n, "mean x (fwd+)", sx/n, "height", zmax - zmin)
