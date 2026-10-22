-- Heights of original models (rest pose geometry) in cm, and the remake Keyes skeleton (keyes_rest.lua).
local ce = require("ce_map"); local CM = require("ce_model")
local m = assert(ce.open(arg[1]))
for _, path in ipairs({ "characters/captain/captain", "characters/marine/marine", "characters/cortana/cortana" }) do
  local mt = m.by_path[path:gsub("/", "\\") .. ".mod2"]
  if mt then
    local model = CM.read(m, mt, 4)
    local lo, hi = 1e9, -1e9
    for _, part in ipairs(model.parts) do for _, v in ipairs(part.verts) do lo = math.min(lo, v.pos[3]); hi = math.max(hi, v.pos[3]) end end
    print(string.format("%s: %.1f cm tall (z %.1f..%.1f)", path, (hi - lo) * 304.8, lo * 304.8, hi * 304.8))
  else print(path, "no model") end
end
local rest = assert(loadfile(arg[2]))()
local lo, hi, head = 1e9, -1e9
for _, b in ipairs(rest) do lo = math.min(lo, b.pos[3]); hi = math.max(hi, b.pos[3]); if b.name == "Head_M" or b.name == "HeadEnd_M" then print("remake", b.name, b.pos[3]) end end
print(string.format("remake Keyes bones z %.1f..%.1f", lo, hi))
