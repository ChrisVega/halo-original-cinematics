local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
local seen = {}
while tl:step() and tl.tick <= 2000 do
  tl:take_events()
  if tl.tick % 300 == 0 then
    for name, o in pairs(tl.objects) do
      if name:find("crew") then
        local a, f = tl:pose_of(o)
        print(string.format("t=%.0f %s pos=(%.2f,%.2f,%.2f) seat=%s anim=%s", tl.tick/30, name, o.pos[1], o.pos[2], o.pos[3], tostring(o.seat), a and a.name or "-"))
      end
    end
  end
end
