local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
while tl:step() and tl.tick <= 1500 do
  tl:take_events()
  local k = tl.objects["keyes_x10"]
  if k and tl.tick % 30 == 0 then
    print(string.format("t=%5.1f body=%7.1f look=%7.1f off=%6.1f anim=%s", tl.tick/30, math.deg(k.yaw), math.deg(k.look_yaw or k.yaw), math.deg((k.look_yaw or k.yaw)-k.yaw), (tl:pose_of(k) or {}).name or "-"))
  end
end
