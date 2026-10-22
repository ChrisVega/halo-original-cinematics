local S = require("ce_scene")
local scene = S.load(POSE_MAP, nil)
local tl = scene:timeline("bridge,hangar_cryo")
for tick = 1, 2600 do
  local ok = pcall(function() return tl:step() end)
  if not ok then break end
  if tick % 300 == 0 and tl.camera then
    print(string.format("tick %d fov %.1f cam z %.2f", tick, tl.camera.fov, tl.camera.pos[3]))
  end
end
