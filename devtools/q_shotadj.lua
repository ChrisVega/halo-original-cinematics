local S = require("ce_scene")
local G = require("sheets_gen")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
local row = G.scenes[1]
tl.shot_adjust, tl.chain_ease = row.shot_adjust, row.chain_ease
local last
while tl:step() and tl.tick <= 1870 do
  for _, e in ipairs(tl:take_events()) do if e.type == "note" and (e.text:find("shot_adjust") or (e.text:find("camera_set") and tl.tick < 800)) then print(tl.tick, e.text) end end
  local c = tl.camera
  if c and tl.tick >= 381 and tl.tick <= 760 and tl.tick % 15 == 0 then
    local sp = last and math.sqrt((c.pos[1]-last[1])^2 + (c.pos[2]-last[2])^2 + (c.pos[3]-last[3])^2) * 304.8 / 15 or 0
    print(tl.tick, string.format("walk pan speed %.1f cm/tick", sp))
  end
  if c then last = { c.pos[1], c.pos[2], c.pos[3] } end
  if tl.tick == 1180 or tl.tick == 1860 then print(tl.tick, string.format("cam %.0f %.0f %.0f", c.pos[1]*304.8, -c.pos[2]*304.8, c.pos[3]*304.8)) end
end
