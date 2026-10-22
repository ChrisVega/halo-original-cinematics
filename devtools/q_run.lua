local S = require("ce_scene"); local G = require("sheets_gen")
local sc = S.load(POSE_MAP, nil); local tl = sc:timeline("bridge,hangar_cryo")
local row = G.scenes[1]; tl.shot_adjust, tl.chain_ease, tl.walk_off, tl.start_facing = row.shot_adjust, row.chain_ease, row.walk_off, row.start_facing
local last = {}
while tl:step() and tl.tick <= 1700 do
  tl:take_events()
  for _, n in ipairs({ "x10_crew_panic_1", "x10_crew_panic_2" }) do
    local o = tl.objects[n]
    if o then
      local a = tl:pose_of(o)
      local p = last[n]; local sp = p and math.sqrt((o.pos[1]-p[1])^2 + (o.pos[2]-p[2])^2) * 304.8 or 0
      if tl.tick % 15 == 0 and (o.walk_on or o.rec) then print(tl.tick, n, string.format("%.1f cm/tick", sp), a and a.name or "-", o.walk_on and "running-on" or "rec") end
      last[n] = { o.pos[1], o.pos[2] }
    end
  end
end
