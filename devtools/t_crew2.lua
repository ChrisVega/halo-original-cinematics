local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil); sc.borrow = { [ [[characters\crewman\crewman]] ] = [[characters\captain\captain]] }
local tl = sc:timeline("bridge,hangar_cryo")
while tl:step() and tl.tick <= 2100 do
  tl:take_events()
  if tl.tick % 300 == 10 then
    for name, o in pairs(tl.objects) do
      if name:find("crew") then
        local a = tl:pose_of(o)
        print(string.format("t=%.0f %s pos=(%.2f,%.2f,%.2f) yaw=%.2f seat=%s anim=%s", tl.tick/30, name, o.pos[1], o.pos[2], o.pos[3], o.yaw, tostring(o.seat), a and a.name or "-"))
      end
    end
  end
end
