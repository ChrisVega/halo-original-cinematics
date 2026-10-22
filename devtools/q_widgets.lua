local out = {}
for _, w in ipairs(FindAllOf("UserWidget") or {}) do
  local ok, inv = pcall(function() return w:IsInViewport() end)
  local vis = -1
  pcall(function() vis = w:GetVisibility() end)
  if ok and inv then out[#out+1] = w:GetClass():GetFName():ToString() .. " vis=" .. tostring(vis) .. " " .. w:GetFName():ToString() end
end
return table.concat(out, "\n")
