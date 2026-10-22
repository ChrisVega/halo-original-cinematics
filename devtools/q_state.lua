local out = {}
for _, mp in ipairs(FindAllOf("MediaPlayer") or {}) do
  if mp:IsPlaying() then out[#out+1] = "PLAYING " .. mp:GetUrl():ToString():match("[^/]+$") end
end
local pc = FindFirstOf("PlayerController")
out[#out+1] = "view " .. pc:GetViewTarget():GetFullName()
local cm = pc.PlayerCameraManager
local l = cm:GetCameraLocation()
out[#out+1] = string.format("cam %.0f %.0f %.0f fov %.1f", l.X, l.Y, l.Z, cm:GetFOVAngle())
out[#out+1] = "cinematic " .. tostring(FindFirstOf("BlamCinematicSubsystem"):IsCinematicInProgress())
return table.concat(out, "\n")
