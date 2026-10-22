-- Offline: where Keyes sits in each original shot, for both pitch signs.
local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
local tl = sc:timeline("bridge,hangar_cryo")
local function ang(a) while a > math.pi do a = a - 2*math.pi end while a < -math.pi do a = a + 2*math.pi end return a end
local shot = "-"
while tl:step() and tl.tick <= 6000 do
  for _, e in ipairs(tl:take_events()) do
    if e.type == "note" and e.text:find("camera_set") then shot = e.text:match("camera_set (%S+)") end
    if e.type == "sound" then print(string.format("t=%6.2f   sound %s", tl.tick/30, e.name)) end
  end
  if tl.tick % 15 == 0 then
    local c, k = tl.camera, tl.objects["keyes_x10"]
    if c and k then
      local hz = k.pos[3] + 0.55
      local dx, dy, dz = k.pos[1]-c.pos[1], k.pos[2]-c.pos[2], hz-c.pos[3]
      local d = math.sqrt(dx*dx+dy*dy+dz*dz)
      local h = ang(math.atan(dy, dx) - c.rot[1])
      local v = math.atan(dz, math.sqrt(dx*dx+dy*dy))
      print(string.format("t=%6.2f %-22s dist=%4.0fcm yawoff=%6.1f headpitch=%6.1f campitch=%6.1f roll=%6.1f",
        tl.tick/30, shot, d*304.8, math.deg(h), math.deg(v), math.deg(c.rot[2]), math.deg(c.rot[3])))
    end
  end
end
