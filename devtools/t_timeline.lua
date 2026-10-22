local Scene = require("ce_scene"); local S = require("ce_sound")
local snd = S.new(arg[2], arg[3], arg[4])
local sc = Scene.load(arg[1], snd)
local names = sc:sounds_used("x10")
local n, missing = snd:prepare(names)
print("sounds", #names, "decoded now", n, "missing", #missing, table.concat(missing, ","))
local tl = sc:timeline("x10")
local last_cam = ""
local guard = 0
while tl:step() and guard < 30 * 600 do
  guard = guard + 1
  for _, e in ipairs(tl:take_events()) do
    if e.type ~= "create" and e.type ~= "destroy" then
      print(string.format("%6.1fs %s %s", tl.tick / 30, e.type, e.name or e.text or e.into or tostring(e.on or "")))
    end
  end
  if tl.tick % 30 == 0 and tl.tick > 900 and tl.tick < 3200 then
    local k = tl.objects["keyes_x10"]
    local c = tl.camera
    print(string.format("%6.1fs cam (%.2f %.2f %.2f) keyes %s", tl.tick / 30, c and c.pos[1] or 0, c and c.pos[2] or 0, c and c.pos[3] or 0,
      k and string.format("(%.2f %.2f) %s", k.pos[1], k.pos[2], (tl:pose_of(k) or {}).name or "-") or "-"))
  end
end
print("finished at", tl.tick / 30, "s", tl.done)
