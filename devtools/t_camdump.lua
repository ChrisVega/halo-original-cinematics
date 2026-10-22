-- Offline: camera and Keyes state over the first 15 s of the bridge scene.
local S = require("ce_scene")
local MAP = POSE_MAP
local sc = S.load(MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
local function fmt(v) return v and string.format("%.2f", v) or "-" end
local last_cam
while tl:step() and tl.tick <= 450 do
  for _, e in ipairs(tl:take_events()) do
    if e.type == "sound" or e.type == "note" then
      print(string.format("t=%5.2f %s %s", tl.tick / 30, e.type, e.name or e.text or ""))
    end
  end
  if tl.tick % 15 == 0 then
    local c = tl.camera
    local k = tl.objects["keyes_x10"]
    print(string.format("t=%5.2f cam=(%s,%s,%s) rot=(%s,%s,%s) fov=%s keyes=(%s,%s,%s) yaw=%s anim=%s",
      tl.tick / 30, fmt(c and c.pos[1]), fmt(c and c.pos[2]), fmt(c and c.pos[3]),
      fmt(c and c.rot[1]), fmt(c and c.rot[2]), fmt(c and c.rot[3]), fmt(c and c.fov),
      fmt(k and k.pos[1]), fmt(k and k.pos[2]), fmt(k and k.pos[3]), fmt(k and k.yaw),
      tostring((k and tl:pose_of(k) or {}).name or "-")))
  end
end
