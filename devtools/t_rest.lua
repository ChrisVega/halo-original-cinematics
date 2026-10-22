-- Rest pose of the CE captain in model space, under two quaternion conventions,
-- converted to Unreal centimetres, to compare with the remake's Keyes bones.
local ce = require("ce_map"); local CM = require("ce_model"); local Q = require("qmath")
local m = assert(ce.open(arg[1]))
local model = CM.read(m, m.by_path[ [[characters\captain\captain.mod2]] ])
local function fk(conj)
    local W = {}
    for i = 0, 40 do
        local n = model.nodes[i]
        if not n then break end
        local q = Q.norm(n.rot); if conj then q = Q.conj(q) end
        if n.parent < 0 or i == 0 then W[i] = { rot = q, pos = { n.pos[1], n.pos[2], n.pos[3] } }
        else
            local p = W[n.parent]
            local off = Q.rotate(p.rot, n.pos)
            W[i] = { rot = Q.mul(p.rot, q), pos = { p.pos[1] + off[1], p.pos[2] + off[2], p.pos[3] + off[3] } }
        end
    end
    return W
end
for _, conj in ipairs({ false, true }) do
    local W = fk(conj)
    print("conj", conj)
    for i = 0, 40 do
        local n = model.nodes[i]; if not n then break end
        if n.name:find("^bip01") then
            local p = W[i].pos
            print(string.format("  %-20s ue (%.1f %.1f %.1f)", n.name, p[1] * 304.8, -p[2] * 304.8, p[3] * 304.8))
        end
    end
end
