local out = {}
local inst = FindAllOf("DataLayerInstanceWithAsset") or {}
local props = {}
inst[1]:GetClass():ForEachProperty(function(p) props[#props+1] = p:GetFName():ToString() .. ":" .. p:GetClass():GetFName():ToString() end)
out[#out+1] = "props: " .. table.concat(props, ", ")
local mgr = FindFirstOf("DataLayerManager")
for _, d in ipairs(inst) do
  local asset = "?"
  pcall(function() asset = d.DataLayerAsset:GetFName():ToString() end)
  local init = "?"
  pcall(function() init = tostring(d.InitialRuntimeState) end)
  local eff = "?"
  pcall(function() eff = tostring(mgr:GetDataLayerInstanceEffectiveRuntimeState(d)) end)
  out[#out+1] = string.format("%s asset=%s initial=%s effective=%s", d:GetFName():ToString():sub(11, 18), asset, init, eff)
end
return table.concat(out, "\n")
