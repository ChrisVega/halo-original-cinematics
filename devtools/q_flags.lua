local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local s = sc:timeline("bridge,hangar_cryo").d.scenario
local function ue(p) return p[1]*304.8, -p[2]*304.8, p[3]*304.8 end
for _, n in ipairs({"keyes_x10_display","keyes_face_cortana","keyes_x10_peer","keyes_x10_deck"}) do
  local f = s.flags[n]; if f then print("flag", n, string.format("%.0f %.0f %.0f", ue(f.pos)), "yaw" , math.deg(f.facing[1])) end
end
for n, c in pairs(s.cameras) do
  if n:find("display_rev") or n:find("keyes_to_cortana") or n:find("peer_walk") or n:find("thats_it") then
    print("cam", n, string.format("%.0f %.0f %.0f", ue(c.pos)), string.format("rot %.1f %.1f %.1f fov %.1f", math.deg(c.rot[1]), math.deg(c.rot[2]), math.deg(c.rot[3]), math.deg(c.fov)))
  end
end
