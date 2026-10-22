local pc = FindFirstOf("PlayerController")
local cam = pc.PlayerCameraManager.ViewTarget.Target
_G.OC_CINE = cam
local WU = 304.8
local p = { 1.0380, 0.5731, -0.2163 }
cam:K2_SetActorLocationAndRotation({ X = p[1]*WU, Y = -p[2]*WU, Z = p[3]*WU }, { Pitch = -5, Yaw = 24, Roll = 0 }, false, {}, true)
local cc = cam.CameraComponent
local pp = ""
pcall(function()
  local b = cc.PostProcessSettings.WeightedBlendables.Array
  pp = "blendables " .. tostring(b:GetArrayNum())
  b:ForEach(function(i, e) local x = e:get(); pcall(function() pp = pp .. " | " .. x.Object:GetFullName() .. " w=" .. tostring(x.Weight) end) end)
end)
local l = cam:K2_GetActorLocation()
return string.format("moved to %.0f %.0f %.0f; %s; ppweight %s", l.X, l.Y, l.Z, pp, tostring(cc.PostProcessBlendWeight))
