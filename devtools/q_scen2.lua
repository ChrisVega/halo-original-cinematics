local a = StaticFindObject("/Game/Blueprints/Campaign/DA_FirstPlayableCampaign.DA_FirstPlayableCampaign")
local out = {}
a.ScenarioList:ForEach(function(i, e)
    local h = e:get()
    out[#out + 1] = h.RowName:ToString()
end)
return table.concat(out, ", ")
