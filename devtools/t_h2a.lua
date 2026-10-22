local H = require("h2a")
local t0 = os.clock()
local h = assert(H.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo2\preload\paks\shared.pck]]))
print("entries", #h.top, "contiguous", h.contiguous, os.clock() - t0)
local tpl = assert(h:template("cortana__h.tpl"))
print("objects", #tpl.objects, "parts", #tpl.parts, os.clock() - t0)
for _, p in ipairs(tpl.parts) do
  local hi = -1e9; for _, v in ipairs(p.verts) do hi = math.max(hi, v[2]) end
  print(p.index, #p.verts, #p.tris, #p.uvs, #p.skin, p.mat.texture, p.mat.material, string.format("%.3f", hi))
end
print(tpl.objects[14].bone, tpl.objects[14].bind[14])
local pic = h:picture("ch_cortana_04.pct"); print(pic.w, pic.h, pic.format, pic.mips, #pic.data, #H.dds(pic))
local s = tpl.parts[3].skin[100]; print("skin", s[1][1], s[1][2], s[2] and s[2][1])
