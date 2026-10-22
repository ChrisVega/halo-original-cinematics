local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
local T = getmetatable(tl).__index
local orig = T.hs_vehicle_load_magic
T.hs_vehicle_load_magic = function(self, a)
  local cn, un = a[1], a[3]
  print("load_magic", tl.tick, tostring(cn.value or cn.global), tostring(a[2].value), tostring(un.value or un.global))
  return orig(self, a)
end
for n, pl in pairs(tl.placements) do if n:find("chair") or n:find("crew") then print("placement", n, pl.kind, pl.tag, pl.pos[1], pl.pos[2], pl.pos[3], pl.rot[1]) end end
while tl:step() and tl.tick <= 400 do tl:take_events() end
