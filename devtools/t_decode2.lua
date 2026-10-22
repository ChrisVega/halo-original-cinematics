local A = require("ce_anim")
local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local map = sc.map
local g = sc:graph([[characters\marine\marine]])
local function bit(flags, n) local w = flags[(n // 32) + 1] or 0; return (w >> (n % 32)) & 1 == 1 end
for _, name in ipairs({"stand pistol move-front", "stand pistol aim-still", "stand pistol idle", "pchair-driver unarmed idle%0", "stand pistol turn-left"}) do
  local a = g.by_name[name]
  local nr, nt, ns = 0, 0, 0
  for n = 0, a.node_count - 1 do if bit(a.rot_flags, n) then nr = nr + 1 end; if bit(a.trans_flags, n) then nt = nt + 1 end; if bit(a.scale_flags, n) then ns = ns + 1 end end
  local fd = map:data(a.ptr + 160)
  print(name, "type", a.type, "nodes", a.node_count, "rot", nr, "trans", nt, "scale", ns, "calc", nr*8+nt*12+ns*4, "frame_size", a.frame_size, "frames", a.frame_count, "data", #fd, "fi", a.frame_info_type)
end
for _, name in ipairs({"stand pistol move-front", "stand pistol aim-still", "stand pistol idle", "pchair-driver unarmed idle%0", "stand pistol turn-left", "stand pistol move-back"}) do
  local a = g.by_name[name]
  local dd = map:data(a.ptr + 140)
  local nr, nt, ns = 0, 0, 0
  for n = 0, a.node_count - 1 do if not bit(a.rot_flags, n) then nr = nr + 1 end; if not bit(a.trans_flags, n) then nt = nt + 1 end; if not bit(a.scale_flags, n) then ns = ns + 1 end end
  print(name, "default bytes", #dd, "per-missing", nr*8+nt*12+ns*4, "full", a.node_count*24)
end
