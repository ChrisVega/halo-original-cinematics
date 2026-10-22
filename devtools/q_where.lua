local pc = FindFirstOf("PlayerController")
local cm = pc.PlayerCameraManager
local l = cm:GetCameraLocation()
local out = { string.format("view camera %.0f %.0f %.0f", l.X, l.Y, l.Z) }
local k = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
local col = { R = 0, G = 0, B = 0, A = 0 }
local n = 0
for x = -2000, 1500, 250 do for y = -1500, 1500, 250 do
  local o = {}
  if k:LineTraceSingle(pc, { X = x, Y = y, Z = 400 }, { X = x, Y = y, Z = -600 }, 0, false, {}, 0, o, true, col, col, 0) then n = n + 1 end
end end
out[#out + 1] = "hits near origin: " .. n
return table.concat(out, "\n")
