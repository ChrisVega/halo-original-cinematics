local ce = require("ce_map"); local A = require("ce_anim"); local CM = require("ce_model")
local RT = require("retarget"); local Q = require("qmath"); local sheets = require("sheets_gen")
local m = assert(ce.open(arg[1]))
-- remake rest pose recorded by the lab run
local rest = {}
for line in io.lines(arg[2]) do
  local name, x, y, z, qx, qy, qz, qw = line:match("bone %d+ (%S+) parent=%S+ pos=%(([%-%d%.]+) ([%-%d%.]+) ([%-%d%.]+)%) q=%(([%-%d%.]+) ([%-%d%.]+) ([%-%d%.]+) ([%-%d%.]+)%)")
  if name and not rest[name] then rest[name] = { pos = { tonumber(x), tonumber(y), tonumber(z) }, rot = { tonumber(qx), tonumber(qy), tonumber(qz), tonumber(qw) } } end
end
local g = A.read_graph(m, m.by_path[ [[characters\captain\captain.antr]] ])
local model = CM.read(m, m.by_path[ [[characters\captain\captain.mod2]] ])
local rows = {}
for _, r in ipairs(sheets.bone_map) do if r.rig == "captain" then rows[#rows + 1] = r end end
local rt = RT.new(g.nodes, model.nodes, rows, rest)
print("mapped", #rt.map)
-- 1. the model's rest pose as a frame must give back the remake rest pose
local rf = {}
for _, mn in pairs(model.nodes) do local i = rt.by_name[mn.name]; if i then rf[i] = { rot = mn.rot, pos = mn.pos } end end
local worst = 0
for _, b in ipairs(rt:solve(rf)) do
  local r0 = rest[b.bone].rot
  local d = math.abs(b.rot[1]*r0[1] + b.rot[2]*r0[2] + b.rot[3]*r0[3] + b.rot[4]*r0[4])
  worst = math.max(worst, math.deg(2 * math.acos(math.min(1, d))))
end
print(string.format("rest round trip worst angle %.3f deg", worst))
-- 2. an idle frame: how far each bone turns from the remake rest pose
local idle = A.decode(m, g.by_name["alert unarmed idle%1"])
for _, b in ipairs(rt:solve(idle[0])) do
  local r0 = rest[b.bone].rot
  local d = math.abs(b.rot[1]*r0[1] + b.rot[2]*r0[2] + b.rot[3]*r0[3] + b.rot[4]*r0[4])
  local rr = Q.to_rotator(b.rot)
  print(string.format("  %-12s turn %6.1f deg  rotator p=%.1f y=%.1f r=%.1f", b.bone, math.deg(2 * math.acos(math.min(1, d))), rr.Pitch, rr.Yaw, rr.Roll))
end
local lt = {}
for i, f in pairs(idle[0]) do lt[i] = { rot = Q.conj(f.rot), pos = f.pos } end
local W = rt:_fk(lt)
for _, n in ipairs({ "bip01 l upperarm", "bip01 l forearm", "bip01 l hand", "bip01 r hand", "bip01 head", "bip01 l foot" }) do
  local p = W[rt.by_name[n]].pos; local p0 = rt.rest_world[rt.by_name[n]].pos
  print(string.format("%-18s idle ue (%.0f %.0f %.0f)  rest ue (%.0f %.0f %.0f)", n, p[1]*304.8, -p[2]*304.8, p[3]*304.8, p0[1]*304.8, -p0[2]*304.8, p0[3]*304.8))
end
