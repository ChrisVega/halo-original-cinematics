-- World Partition data layers and their states, plus Blam zone/bsp hints.
local out = 0
for _, cls in ipairs({ "DataLayerInstance", "DataLayerInstanceWithAsset", "DataLayerAsset" }) do
    for _, d in ipairs(FindAllOf(cls) or {}) do
        local name = d:GetFullName()
        local st = ""
        pcall(function() st = tostring(d:GetRuntimeState()) end)
        pcall(function() if st == "" then st = tostring(d:GetInitialRuntimeState()) end end)
        local asset = ""
        pcall(function() asset = d:GetAsset():GetFName():ToString() end)
        print(cls, name:match("[^%.:]+$"), asset, "state", st)
        out = out + 1
        if out > 120 then return "truncated" end
    end
end
for _, cls in ipairs({ "LevelStreaming", "LevelStreamingDynamic", "WorldPartitionLevelStreamingDynamic" }) do
    local n = #(FindAllOf(cls) or {})
    print(cls, n)
end
return out
