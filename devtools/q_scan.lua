local pc = FindFirstOf("PlayerController")
local k = StaticFindObject("/Script/Engine.Default__KismetSystemLibrary")
local col = { R = 0, G = 0, B = 0, A = 0 }
local f = io.open((os.getenv("LOCALAPPDATA") or ".") .. "/OriginalCinematics/survey_remake.tsv", "wb")
local n = 0
for x = -2200, 1700, 50 do for y = -1600, 1600, 50 do
  local o = {}
  local ok, hit = pcall(function() return k:LineTraceSingle(pc, { X = x, Y = y, Z = 400 }, { X = x, Y = y, Z = -600 }, 0, false, {}, 0, o, true, col, col, 0) end)
  if ok and hit then
    local z, cn, mn = 0, "?", "?"
    pcall(function() z = tonumber(o.Location.Z) or 0 end)
    pcall(function() local c = o.Component:Get(); cn = c:GetFName():ToString(); pcall(function() mn = c.StaticMesh:GetFName():ToString() end) end)
    f:write(string.format("HIT\t%d\t%d\t%.1f\t%s\t%s\n", x, y, z, mn, cn)); n = n + 1
  end
end end
f:close()
return "hits " .. n
