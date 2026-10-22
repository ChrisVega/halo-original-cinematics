local H = require("h2a")
local h = assert(H.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo2\preload\paks\shared.pck]]))
local tpl = h:template("cortana__h.tpl", function() return false end)
local names = {}
for _, sm in ipairs(tpl.subs) do names[sm.mat.texture] = (names[sm.mat.texture] or "") .. sm.mat.material .. " " end
for k, v in pairs(names) do print("tex", k, v) end
local pic = h:picture("ch_cortana_04_hair.pct")
local tmp = OUTDIR .. "/t.dds"
local f = io.open(tmp, "wb"); f:write(H.dds(pic)); f:close()
os.execute('cmd /c ""' .. FF .. '" -hide_banner -loglevel error -y -i "' .. tmp .. '" -vf scale=256:-1 "' .. OUTDIR .. '/hair.png""')
os.remove(tmp)
