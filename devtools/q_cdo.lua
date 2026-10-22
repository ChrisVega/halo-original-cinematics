local out = {}
for _, p in ipairs({ "/Script/Engine.Default__GameplayStatics", "/Script/Engine.Default__KismetSystemLibrary", "/Script/Engine.Default__KismetMathLibrary", "/Script/Engine.GameplayStatics" }) do
  local o = StaticFindObject(p)
  local s = type(o)
  pcall(function() s = s .. " valid=" .. tostring(o:IsValid()) end)
  pcall(function() s = s .. " " .. o:GetFullName() end)
  out[#out+1] = p .. " -> " .. s
end
local w = FindFirstOf("World")
pcall(function() local gs = StaticFindObject("/Script/Engine.Default__GameplayStatics"); out[#out+1] = "real " .. tostring(gs:GetRealTimeSeconds(w)) end)
pcall(function() local km = StaticFindObject("/Script/Engine.Default__KismetMathLibrary"); local n = km:Now(); out[#out+1] = "now ticks " .. tostring(n.Ticks) end)
local ok, e = pcall(function() local gs = UEHelpers and UEHelpers.GetGameplayStatics() end)
return table.concat(out, "\n")
