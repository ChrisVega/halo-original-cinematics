local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local s = sc.scenario
for _, n in ipairs({"cortana_face_keyes", "keyes_face_cortana"}) do local f = s.flags[n]; print(n, f.pos[1], f.pos[2], f.pos[3], f.facing[1]) end
for _, n in ipairs({"keyes_to_cortana_1","keyes_to_cortana_2","keyes_to_cortana_3a","keyes_to_cortana_3b"}) do local c = s.cameras[n]; print(n, c.pos[1], c.pos[2], c.pos[3], c.rot[1], c.rot[2], c.rot[3]) end
local tl = sc:timeline("bridge,hangar_cryo")
while tl:step() and tl.tick <= 1990 do tl:take_events()
  if tl.tick % 30 == 0 and tl.tick > 1740 then
    local k, c = tl.objects["keyes_x10"], tl.objects["cortana_x10"]
    print(tl.tick, k and string.format("keyes %.2f %.2f %.2f", k.pos[1], k.pos[2], k.pos[3]), c and string.format("cortana %.2f %.2f %.2f", c.pos[1], c.pos[2], c.pos[3]), tl.camera and tl.camera.name)
  end
end
