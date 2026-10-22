local cam = _G.OC_CAM
local out = { "cam valid " .. tostring(cam and cam:IsValid()) }
local l = cam:K2_GetActorLocation()
out[#out+1] = string.format("cam at %.0f %.0f %.0f", l.X, l.Y, l.Z)
local cls = StaticFindObject("/Script/Engine.WorldPartitionStreamingSourceComponent")
local src = cam:AddComponentByClass(cls, false, { Translation = {X=0,Y=0,Z=0}, Rotation = {X=0,Y=0,Z=0,W=1}, Scale3D = {X=1,Y=1,Z=1} }, false)
out[#out+1] = "src " .. tostring(src and src:IsValid())
pcall(function() src.Priority = 0 end)
pcall(function() src.TargetBehavior = 0 end)
src:EnableStreamingSource()
out[#out+1] = "enabled " .. tostring(src:IsStreamingSourceEnabled())
local pc = FindFirstOf("PlayerController")
pc:SetViewTargetWithBlend(cam, 0, 0, 0, false)
return table.concat(out, "\n")
