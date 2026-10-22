local w = FindFirstOf("World")
local WU = 304.8
local p = { 1.0380, 0.5731, -0.2163 }
if not (_G.OC_CAM and _G.OC_CAM:IsValid()) then
  _G.OC_CAM = w:SpawnActor(StaticFindObject("/Script/Engine.CameraActor"), { X = p[1]*WU, Y = -p[2]*WU, Z = p[3]*WU }, { Pitch = -5, Yaw = 24, Roll = 0 })
end
local pc = FindFirstOf("PlayerController")
pc:SetViewTargetWithBlend(_G.OC_CAM, 0, 0, 0, false)
local vt = pc:GetViewTarget()
return "view " .. (vt and vt:IsValid() and vt:GetFName():ToString() or "nil")
