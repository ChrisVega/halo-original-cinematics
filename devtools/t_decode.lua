local S = require("ce_scene")
local sc = S.load(POSE_MAP, nil)
for _, p in ipairs({[[cinematics\animations\crewman\x10\x10]], [[characters\marine\marine]], [[cinematics\animations\captain\x10\x10]]}) do
  local g = sc:graph(p)
  for name, a in pairs(g.by_name) do
    if p:find("x10") or name:find("pchair") or name:find("stand pistol") or name:find("fidget") then
    local ok, fr = pcall(function() return sc:frames(a) end)
    local bad, maxp, nf = 0, 0, 0
    if ok and fr then
      for fi, f in pairs(fr) do nf = nf + 1
        for i, x in pairs(f) do
          local q = x.rot; local l = q[1]^2+q[2]^2+q[3]^2+q[4]^2
          if l ~= l or math.abs(l - 1) > 0.05 then bad = bad + 1 end
          for k = 1, 3 do local v = math.abs(x.pos[k]); if v ~= v or v > maxp then maxp = v end end
        end
      end
    end
    print(string.format("%-45s ok=%s frames=%d/%d badq=%d maxpos=%.2f compressed=%s", name, tostring(ok), nf, a.frame_count, bad, maxp, tostring(a.compressed)))
    end
  end
end
