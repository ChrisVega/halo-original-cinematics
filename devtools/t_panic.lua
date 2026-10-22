local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
while tl:step() and tl.tick <= 2000 do tl:take_events()
  if tl.tick >= 1925 then
    for n, o in pairs(tl.objects) do if n:find("panic") then
      local a, f = tl:pose_of(o)
      print(tl.tick, n, o.pos[1], o.pos[2], o.yaw, o.look_yaw, a and a.name, f, o.custom and "custom" or "", o.rec and "rec" or "")
    end end
  end
end
