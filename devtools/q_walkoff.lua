local S = require("ce_scene"); local G = require("sheets_gen")
local sc = S.load(POSE_MAP, nil); local tl = sc:timeline("bridge,hangar_cryo")
local row = G.scenes[1]; tl.shot_adjust, tl.chain_ease, tl.walk_off = row.shot_adjust, row.chain_ease, row.walk_off
while tl:step() and tl.tick <= 2000 do
  for _, e in ipairs(tl:take_events()) do
    if e.type == "destroy" and e.name:find("panic") then print(tl.tick, "removed", e.name) end
  end
  local o = tl.objects["x10_crew_panic_1"]
  if o and o.walk_on and tl.tick % 30 == 0 then print(tl.tick, "panic_1 walking", string.format("%.2f %.2f", o.pos[1], o.pos[2])) end
end
