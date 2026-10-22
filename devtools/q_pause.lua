local out = {}
for _, a in ipairs(FindAllOf("LevelSequenceActor") or {}) do
  local seq = ""
  pcall(function() seq = a.LevelSequenceAsset:GetFName():ToString() end)
  if seq:find("POA%-cin01") then
    local sp = a.SequencePlayer
    out[#out+1] = "sequence " .. seq .. " playing=" .. tostring(sp:IsPlaying())
    sp:Pause()
    _G.OC_SEQ = sp
  end
end
for _, mp in ipairs(FindAllOf("MediaPlayer") or {}) do if mp:IsPlaying() then mp:Pause(); out[#out+1] = "paused media" end end
local w = FindFirstOf("World")
local WU = 304.8
local p = { 1.0380, 0.5731, -0.2163 }
if not (_G.OC_CAM and _G.OC_CAM:IsValid()) then
  _G.OC_CAM = w:SpawnActor(StaticFindObject("/Script/Engine.CameraActor"), { X = p[1]*WU, Y = -p[2]*WU, Z = p[3]*WU }, { Pitch = -5, Yaw = 24, Roll = 0 })
end
FindFirstOf("PlayerController"):SetViewTargetWithBlend(_G.OC_CAM, 0, 0, 0, false)
return table.concat(out, "\n")
