local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
for name, s in pairs(sc.scripts) do
  local function walk(e, out)
    if type(e) ~= "table" then return end
    if e.fn then
      local txt = e.fn
      for _, a in ipairs(e.args or {}) do txt = txt .. " " .. tostring(a.value or a.global or (a.fn and ("(" .. a.fn .. ")")) or "?") end
      if txt:find("cortana") then out[#out+1] = txt end
    end
    for _, a in ipairs(e.args or {}) do walk(a, out) end
  end
  local out = {}
  walk(s.body, out)
  if #out > 0 and (name == "bridge" or name:find("x10") or name:find("cortana")) then print("==", name); for _, l in ipairs(out) do print("  ", l) end end
end
