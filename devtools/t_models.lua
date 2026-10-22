local CM = require("ce_model")
local ce = require("ce_map")
local m = ce.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
local function dump(path)
    local tag = m.by_path[path]
    if not tag then print("no tag", path); return end
    local model = CM.read(m, tag, 4)
    local mn = { 1e9, 1e9, 1e9 }
    local mx = { -1e9, -1e9, -1e9 }
    local nv = 0
    for _, p in ipairs(model.parts) do
        nv = nv + p.vcount
        for v = 0, p.vcount - 1 do
            local x = p.verts[v]
            for k = 1, 3 do
                if x.pos[k] < mn[k] then mn[k] = x.pos[k] end
                if x.pos[k] > mx[k] then mx[k] = x.pos[k] end
            end
        end
    end
    print(string.format("%-40s nodes=%d parts=%d verts=%d bbox=(%.3f,%.3f,%.3f)-(%.3f,%.3f,%.3f)",
        path, #model.nodes, #model.parts, nv, mn[1], mn[2], mn[3], mx[1], mx[2], mx[3]))
end
dump("characters\\cortana\\cortana.mod2")
dump("characters\\captain\\captain.mod2")
dump("characters\\cyborg\\cyborg.mod2")
dump("characters\\marine\\marine.mod2")
