local ce = require("ce_map"); local A = require("ce_anim")
local m = assert(ce.open(arg[1]))
for _, gp in ipairs({ [[characters\captain\captain.antr]], [[cinematics\animations\captain\x10\x10.antr]], [[characters\cortana\cortana.antr]] }) do
  local g = A.read_graph(m, m.by_path[gp])
  for i = 0, #g.animations do
    local a = g.animations[i]
    local fi = m:data(a.ptr + 72)
    local sx, sy, syaw = 0, 0, 0
    local stride = ({ [0] = 0, 8, 12, 16 })[a.frame_info_type]
    if stride > 0 then
      for f = 0, a.frame_count - 1 do
        local dx, dy = string.unpack("<ff", fi, f * stride + 1)
        sx, sy = sx + dx, sy + dy
        if a.frame_info_type == 2 then syaw = syaw + string.unpack("<f", fi, f * stride + 9) end
        if a.frame_info_type == 3 then syaw = syaw + string.unpack("<f", fi, f * stride + 13) end
      end
    end
    print(gp:match("[^\\]+$"), a.name, a.frame_count, "fi", a.frame_info_type, string.format("total dx %.3f dy %.3f dyaw %.2f", sx, sy, syaw))
  end
end
