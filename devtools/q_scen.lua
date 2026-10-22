for _, a in ipairs(FindAllOf("BlamCampaignDataAsset") or {}) do
    local name = a:GetFName():ToString()
    local list = a.ScenarioList
    local n = list:GetArrayNum()
    local items = {}
    list:ForEach(function(i, e)
        local v = e:get()
        local s = "?"
        pcall(function() s = v:ToString() end)
        if s == "?" then pcall(function() s = v:GetFullName() end) end
        if s == "?" then
            pcall(function()
                local parts = {}
                for _, k in ipairs({ "ScenarioName", "Name", "MapName", "Scenario", "ScenarioPath", "DisplayName" }) do
                    local ok, x = pcall(function() return v[k] end)
                    if ok and x ~= nil then
                        local ok2, t = pcall(function() return x:ToString() end)
                        parts[#parts + 1] = k .. "=" .. (ok2 and t or tostring(x))
                    end
                end
                s = table.concat(parts, " ")
            end)
        end
        items[#items + 1] = s
    end)
    print(name, n, table.concat(items, " | "))
end
return "ok"
