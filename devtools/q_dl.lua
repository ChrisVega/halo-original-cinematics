local out = {}
for _, cls in ipairs({ "DataLayerInstanceWithAsset", "DataLayerInstance" }) do
  local l = FindAllOf(cls) or {}
  out[#out+1] = cls .. " " .. #l
  for i, d in ipairs(l) do if i <= 80 then out[#out+1] = "  " .. d:GetFullName():match("[^%.]+$") end end
end
local m = FindAllOf("DataLayerManager") or {}
out[#out+1] = "managers " .. #m
for _, cls in ipairs({ "BlamZoneSetDataAsset", "BlamZoneSet", "BlamBspTagDataAsset", "BlamStructureBspTagDataAsset" }) do
  out[#out+1] = cls .. " " .. #(FindAllOf(cls) or {})
end
return table.concat(out, "\n")
