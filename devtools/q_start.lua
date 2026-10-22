local sub = FindFirstOf("BlamCampaignFlowGameSubsystem")
local camp = StaticFindObject("/Game/Blueprints/Campaign/DA_FirstPlayableCampaign.DA_FirstPlayableCampaign")
local ok = sub:SetAndBeginCampaign(camp, FName("A15"), { bLoadFromCoreSave = false, SaveSlot = 0, SavedFilmName = "", CampaignDifficultyLevel = 1, InsertionPoint = 0, bFriendlyFireEnabled = false, bIsLASO = false })
return tostring(ok) .. " err=" .. sub:GetLastBlamErrorName():ToString()
