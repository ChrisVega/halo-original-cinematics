-- Switch the Blam zone set to the bridge candidate and park a camera on the original bridge shot.
local k = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
local w = FindFirstOf("World")
for _, mp in ipairs(FindAllOf("MediaPlayer") or {}) do if mp:IsPlaying() then mp:Close() end end
k:ExecuteConsoleCommand(w, "hs:switch_zone_set zs_02", nil)
local WU = 304.8
local p = { 1.0380, 0.5731, -0.2163 }
local cam = w:SpawnActor(StaticFindObject("/Script/Engine.CameraActor"), { X = p[1] * WU, Y = -p[2] * WU, Z = p[3] * WU }, { Pitch = -5, Yaw = 24, Roll = 0 })
FindFirstOf("PlayerController"):SetViewTargetWithBlend(cam, 0, 0, 0, false)
_G.OC_CAM = cam
return "switched; camera " .. cam:GetFName():ToString()
