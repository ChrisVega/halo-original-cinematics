local S = require("ce_scene")
local RT = require("retarget")
local CM = require("ce_model")
local sc = S.load(POSE_MAP, nil)
local tag = [[characters\crewman\crewman]]
local g = sc:graph(tag)
local model = CM.read(sc.map, sc.map.by_path[tag .. ".mod2"])
local rt = RT.new(g.nodes, model.nodes, {}, {})
local function show(label, W)
  local function p(n) local i = rt.by_name[n]; local w = W[i]; return w and string.format("(%.2f,%.2f,%.2f)", w.pos[1]*304.8, w.pos[2]*304.8, w.pos[3]*304.8) or "-" end
  print(label, "pelvis", p("bip01 pelvis"), "lfoot", p("bip01 l foot"), "head", p("bip01 head"), "lhand", p("bip01 l hand"))
end
show("rest", rt.rest_world)
for _, an in ipairs({"pchair-driver unarmed idle%0", "pchair-driver unarmed idle%2", "stand pistol idle"}) do
  local a = g.by_name[an]
  local f = sc:frames(a)[0]
  local lt = {}
  for i, x in pairs(f) do lt[i] = { rot = require("qmath").conj(x.rot), pos = x.pos } end
  show(an, rt:_fk(lt))
end
