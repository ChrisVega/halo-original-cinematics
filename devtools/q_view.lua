local pc = FindFirstOf("PlayerController")
local cm = pc.PlayerCameraManager
local l = cm:GetCameraLocation()
local vt = "?"
pcall(function() vt = cm.ViewTarget.Target:GetFullName() end)
return string.format("cam %.0f %.0f %.0f fov %.1f target %s", l.X, l.Y, l.Z, cm:GetFOVAngle(), vt)
