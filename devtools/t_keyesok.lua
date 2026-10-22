local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
for _, p in ipairs({[[characters\captain\captain]], [[cinematics\animations\captain\x10\x10]]}) do
  local g = sc:graph(p)
  local bad = {}
  for n, a in pairs(g.by_name) do if not sc:anim_ok(a) then bad[#bad+1] = n end end
  table.sort(bad); print(p, "bad:", table.concat(bad, " | "))
end
local tl = sc:timeline("bridge,hangar_cryo")
local used = {}
while tl:step() and tl.tick <= 2000 do tl:take_events(); local o = tl.objects["keyes_x10"]; if o then local a = tl:pose_of(o); if a then used[a.name] = (used[a.name] or 0) + 1 end end end
for n, c in pairs(used) do print("keyes uses", n, c) end
