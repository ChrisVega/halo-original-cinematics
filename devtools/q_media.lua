local out = {}
for _, mp in ipairs(FindAllOf("MediaPlayer") or {}) do
  if mp:IsPlaying() then out[#out+1] = mp:GetFName():ToString() .. " " .. mp:GetUrl():ToString() end
end
local cs = FindFirstOf("BlamCinematicSubsystem")
out[#out+1] = "cinematic in progress=" .. tostring(cs:IsCinematicInProgress())
for _, a in ipairs(FindAllOf("LevelSequenceActor") or {}) do
  local seq = ""
  pcall(function() seq = a.LevelSequenceAsset:GetFullName() end)
  out[#out+1] = "LSA " .. a:GetFName():ToString() .. " " .. seq
end
return table.concat(out, "\n")
