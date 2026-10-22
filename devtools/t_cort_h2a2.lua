local H = require("h2a"); local C = require("cortana_h2a"); local S = require("ce_scene"); local CM = require("ce_model")
local h = assert(H.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo2\preload\paks\shared.pck]]))
local keep = { [3] = true, [4] = true, [5] = true, [6] = true, [8] = true, [9] = true }
local tpl = assert(h:template("cortana__h.tpl", function(sm, i) return keep[i] end))
local sc = S.load(POSE_MAP, nil)
local g = sc:graph([[characters\cortana\cortana]])
local model = CM.read(sc.map, sc.map.by_path[ [[characters\cortana\cortana.mod2]] ])
local c = C.new(tpl, g.nodes, model.nodes, print)
local a = g.by_name["stand unarmed idle%1"] or g.by_name["stand unarmed idle"]
local frames = sc:frames(a)
local t0 = os.clock()
local R, P = c:solve(frames[1], 0)
local out = c:skin(R, P, 1)
print("first skin", os.clock() - t0)
t0 = os.clock(); for k=1,10 do R,P=c:solve(frames[k],0.2); out=c:skin(R,P,1) end; print("per pose", (os.clock()-t0)/10)
-- dump a wireframe as JSON-ish for python rendering
local f = io.open(OUT, "w")
for pi, vs in ipairs(out) do
  for _, t in ipairs(c.parts[pi].tris) do
    local a1, b1, c1 = vs[t[1]], vs[t[2]], vs[t[3]]
    if a1 and b1 and c1 then f:write(string.format("%.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f\n", a1.X,a1.Y,a1.Z,b1.X,b1.Y,b1.Z,c1.X,c1.Y,c1.Z)) end
  end
end
f:close()
