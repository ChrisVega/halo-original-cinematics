local out = {}
local gs = StaticFindObject("/Script/Engine.Default__GameplayStatics")
local w = FindFirstOf("World")
out[#out+1] = "paused " .. tostring(gs:IsGamePaused(w))
for _, x in ipairs(FindAllOf("UserWidget") or {}) do
  local n = x:GetClass():GetFName():ToString()
  if n:lower():find("pause") or n:lower():find("menu") or n:lower():find("roster") then
    local vis = -1; pcall(function() vis = x:GetVisibility() end)
    out[#out+1] = n .. " vis=" .. vis .. " " .. x:GetFName():ToString()
  end
end
return table.concat(out, "\n")
