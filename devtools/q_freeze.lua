local gs = StaticFindObject("/Script/Engine.Default__GameplayStatics")
local w = FindFirstOf("World")
gs:SetGlobalTimeDilation(w, 0.0001)
return "dilation " .. tostring(gs:GetGlobalTimeDilation(w))
