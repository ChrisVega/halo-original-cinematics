-- Offline: compare bone directions of the CE rest pose (mirrored to UE) with the
-- remake's rest pose, per mapped limb, to find rest-pose mismatches.
local CM = require("ce_model")
local RT = require("retarget")
local Q = require("qmath")
local S = require("ce_scene")
local sheets = require("sheets_gen")
local rest = assert(loadfile(POSE_REST))()
local by = {}
for _, b in ipairs(rest) do by[b.name] = b end
local scene = S.load(POSE_MAP, nil)
local g = scene:graph([[characters\captain\captain]])
local model = CM.read(scene.map, scene.map.by_path[ [[characters\captain\captain.mod2]] ])
local rows = {}
for _, r in ipairs(sheets.bone_map) do if r.rig == "captain" then rows[#rows + 1] = r end end
local rt = RT.new(g.nodes, model.nodes, rows, by)
local W = rt.rest_world
local pairs_ = { {"bip01 l thigh","bip01 l calf","Hip_L","Knee_L"}, {"bip01 r thigh","bip01 r calf","Hip_R","Knee_R"},
  {"bip01 l calf","bip01 l foot","Knee_L","Ankle_L"}, {"bip01 r calf","bip01 r foot","Knee_R","Ankle_R"},
  {"bip01 l upperarm","bip01 l forearm","Shoulder_L","Elbow_L"}, {"bip01 r upperarm","bip01 r forearm","Shoulder_R","Elbow_R"},
  {"bip01 l forearm","bip01 l hand","Elbow_L","Wrist_L"}, {"bip01 r forearm","bip01 r hand","Elbow_R","Wrist_R"},
  {"bip01 pelvis","bip01 spine","Root_M","Spine1_M"}, {"bip01 spine1","bip01 neck","Chest_M","Neck_M"} }
local function norm(v) local l = math.sqrt(v[1]^2+v[2]^2+v[3]^2); return {v[1]/l,v[2]/l,v[3]/l} end
for _, p in ipairs(pairs_) do
  local a, b = W[rt.by_name[p[1]]], W[rt.by_name[p[2]]]
  local ce = norm({ b.pos[1]-a.pos[1], -(b.pos[2]-a.pos[2]), b.pos[3]-a.pos[3] })
  local ra, rb = by[p[3]], by[p[4]]
  local re = norm({ rb.pos[1]-ra.pos[1], rb.pos[2]-ra.pos[2], rb.pos[3]-ra.pos[3] })
  local dot = ce[1]*re[1]+ce[2]*re[2]+ce[3]*re[3]
  print(string.format("%-12s ce=(%.2f,%.2f,%.2f) remake=(%.2f,%.2f,%.2f) angle=%.1f", p[3], ce[1],ce[2],ce[3], re[1],re[2],re[3], math.deg(math.acos(math.max(-1,math.min(1,dot))))))
end
