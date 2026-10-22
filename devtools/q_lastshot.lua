local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
print("recording exists:", tl.d.scenario.recordings["keyes_x10_look_at_cortana"] ~= nil)
while tl:step() and tl.tick <= 1960 do
  tl:take_events()
  if tl.tick >= 1740 and tl.tick % 20 == 0 then
    local o = tl.objects["keyes_x10"]
    if o then
      local a, f = tl:pose_of(o)
      print(tl.tick, string.format("pos %.3f %.3f %.3f yaw %.1f", o.pos[1], o.pos[2], o.pos[3], math.deg(o.yaw or 0)),
        "rec", tostring(o.rec ~= nil), "look", o.look and string.format("%.2f %.2f", o.look[1] or 0, o.look[2] or 0) or "-",
        "anim", a and a.name or "-", f)
    end
  end
end
