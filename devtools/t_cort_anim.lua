local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
local last
while tl:step() and tl.tick <= 3000 do
  tl:take_events()
  local c = tl.objects["cortana_x10"]
  if c then
    local a, f = tl:pose_of(c)
    local n = a and a.name or "-"
    if n ~= last then print(string.format("t=%.1f anim=%s frames=%s pos=(%.2f,%.2f,%.2f) yaw=%.2f", tl.tick/30, n, a and a.frame_count or 0, c.pos[1], c.pos[2], c.pos[3], c.yaw)); last = n end
  end
end
local g = sc:graph([[characters\cortana\cortana]])
local names = {}
for i, n in pairs(g.nodes) do names[#names+1] = i .. ":" .. n.name end
table.sort(names); print(#names, table.concat(names, ", "))
