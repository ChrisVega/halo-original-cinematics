-- What the campaign subsystem needs to start a mission.
local sub = FindFirstOf("BlamCampaignFlowGameSubsystem")
print("subsystem", sub and sub:IsValid() and sub:GetFullName() or "none")
for _, a in ipairs(FindAllOf("BlamCampaignDataAsset") or {}) do
    print("campaign", a:GetFullName())
    pcall(function()
        a:GetClass():ForEachProperty(function(p)
            local n = p:GetFName():ToString()
            local v = ""
            pcall(function() v = tostring(a[n]) end)
            print("   ", n, p:GetClass():GetFName():ToString(), v)
        end)
    end)
end
local fn = StaticFindObject("/Script/BlamEngine.BlamCampaignFlowGameSubsystem:BeginCampaign")
if fn and fn:IsValid() then
    fn:ForEachProperty(function(p)
        if p:GetFName():ToString() == "Options" then
            local ok, st = pcall(function() return p:GetStruct() end)
            print("Options struct", ok and st:GetFullName() or "?")
            if ok then st:ForEachProperty(function(q) print("   opt", q:GetFName():ToString(), q:GetClass():GetFName():ToString()) end) end
        end
    end)
end
return "ok"
