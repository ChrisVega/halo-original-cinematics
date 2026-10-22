local CM = require("ce_model")
local ce = require("ce_map")
local m = ce.open([[C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map]])
local tag = m.by_path["characters\\cortana\\cortana.mod2"]
print("tag", tag and tag.path)
local model = CM.read(m, tag, 4)
print("nodes", #model.nodes, "parts", #model.parts)
for i = 0, #model.nodes do
    local n = model.nodes[i]
    if n then
        print(string.format("node %d %-16s parent=%-16s pos=%.2f %.2f %.2f rot=%.3f %.3f %.3f %.3f",
            i, n.name, n.parent or "-", n.pos[1], n.pos[2], n.pos[3], n.rot[1], n.rot[2], n.rot[3], n.rot[4]))
    end
end
for si, p in ipairs(model.parts) do
    local mn = { 1e9, 1e9, 1e9 }
    local mx = { -1e9, -1e9, -1e9 }
    for v = 0, p.vcount - 1 do
        local x = p.verts[v]
        for k = 1, 3 do
            if x.pos[k] < mn[k] then mn[k] = x.pos[k] end
            if x.pos[k] > mx[k] then mx[k] = x.pos[k] end
        end
    end
    print(string.format("part %d verts=%d tris=%d bbox=(%.2f,%.2f,%.2f)-(%.2f,%.2f,%.2f)",
        si, p.vcount, #p.tris, mn[1], mn[2], mn[3], mx[1], mx[2], mx[3]))
end
