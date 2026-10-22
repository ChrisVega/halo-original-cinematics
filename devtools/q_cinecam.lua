local pc = FindFirstOf("PlayerController")
local cam = pc.PlayerCameraManager.ViewTarget.Target
local out = { cam:GetFullName() }
local comps = cam:K2_GetComponentsByClass(StaticFindObject("/Script/Engine.ActorComponent"))
out[#out+1] = "type " .. type(comps)
for k, e in pairs(comps) do
  local c = e
  if type(e) == "userdata" and e.get then pcall(function() c = e:get() end) end
  local cls, nm = "?", "?"
  pcall(function() cls = c:GetClass():GetFName():ToString() end)
  pcall(function() nm = c:GetFName():ToString() end)
  local extra = ""
  pcall(function() extra = " mesh=" .. c.StaticMesh:GetFName():ToString() end)
  pcall(function() local m = c:GetMaterial(0); extra = extra .. " mat=" .. m:GetFName():ToString() end)
  pcall(function() extra = extra .. " visible=" .. tostring(c:IsVisible()) end)
  out[#out+1] = "  " .. cls .. " " .. nm .. extra
end
return table.concat(out, "\n")
