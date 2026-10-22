-- Offline check: where do the retargeted feet sit relative to the actor
-- origin (the floor) across the whole x10 intro?
-- run: python devtools/run_feet.py
local CM = require("ce_model")
local RT = require("retarget")
local Q = require("qmath")
local S = require("ce_scene")
local sheets = require("sheets_gen")

local MAP = POSE_MAP
local REST = POSE_REST

local rest = assert(loadfile(REST))()
local by_name, kids, order = {}, {}, {}
for _, b in ipairs(rest) do by_name[b.name] = b end
local function depth(b)
    local d, n = 0, b
    while n and n.parent and by_name[n.parent] and d < 64 do d = d + 1; n = by_name[n.parent] end
    return d
end
for _, b in ipairs(rest) do order[#order + 1] = b end
table.sort(order, function(a, b) return depth(a) < depth(b) end)
-- local rest transform (relative to parent)
local local_rest = {}
for _, b in ipairs(rest) do
    local p = by_name[b.parent]
    if p then
        local d = { b.pos[1] - p.pos[1], b.pos[2] - p.pos[2], b.pos[3] - p.pos[3] }
        local_rest[b.name] = { rot = Q.norm(Q.mul(Q.conj(p.rot), b.rot)), pos = Q.rotate(Q.conj(p.rot), d) }
    else
        local_rest[b.name] = { rot = b.rot, pos = b.pos }
    end
end

local scene = S.load(MAP, nil)
local tl = scene:timeline("bridge,hangar_cryo")
local g = scene:graph([[characters\captain\captain]])
local model = CM.read(scene.map, scene.map.by_path[ [[characters\captain\captain.mod2]] ])
local rows = {}
for _, r in ipairs(sheets.bone_map) do if r.rig == "captain" then rows[#rows + 1] = r end end
local rt = RT.new(g.nodes, model.nodes, rows, by_name)
print("mapped bones: " .. #rt.map)

local feet = {}
for _, b in ipairs(rest) do
    if b.name:find("Ankle") or b.name:find("Foot") or b.name:find("Toe") or b.name:find("Ball")
        or b.name:find("Heel") or b.name:find("Sole") then
        feet[#feet + 1] = b.name
    end
end
print("foot bones: " .. table.concat(feet, ", "))

-- component-space transforms of the posed skeleton for one solved pose
local function posed(items)
    local rot, pos, loc_root = {}, {}, nil
    for _, it in ipairs(items) do rot[it.bone] = it.rot; if it.loc then loc_root = it.loc end end
    for _, b in ipairs(order) do
        local p = by_name[b.parent]
        local pr = p and rot[p.name] or { 0, 0, 0, 1 }
        local pp = p and pos[p.name] or { 0, 0, 0 }
        local lr = local_rest[b.name]
        if b.name == "Root_M" and loc_root then
            rot[b.name] = rot[b.name] or lr.rot
            pos[b.name] = { loc_root[1], loc_root[2], loc_root[3] }
        else
            rot[b.name] = rot[b.name] or Q.norm(Q.mul(pr, lr.rot))
            local off = Q.rotate(pr, lr.pos)
            pos[b.name] = { pp[1] + off[1], pp[2] + off[2], pp[3] + off[3] }
        end
    end
    return pos
end

local stats = { min = 1e9, max = -1e9, n = 0 }
local samples = {}
for tick = 1, 9000 do
    local ok = pcall(function() return tl:step() end)
    if not ok then break end
    local o = tl.objects and tl.objects.keyes_x10
    if o then
        local anim, frame = tl:pose_of(o)
        local f = anim and scene:frames(anim)
        f = f and f[frame]
        if f then
            local ok2, items = pcall(function() return rt:solve(f) end)
            if ok2 then
                local pos = posed(items)
                local lo, lo_name = 1e9, nil
                for _, n in ipairs(feet) do
                    local z = pos[n] and pos[n][3]
                    if z and z < lo then lo, lo_name = z, n end
                end
                if lo < 1e9 then
                    stats.min = math.min(stats.min, lo); stats.max = math.max(stats.max, lo); stats.n = stats.n + 1
                    if stats.n % 300 == 0 then
                        samples[#samples + 1] = string.format("tick %d: lowest %s z=%.1f cm (unit z=%.1f, yaw %.1f)",
                            tick, lo_name, lo, o.pos[3] * 304.8, math.deg(o.yaw))
                    end
                end
            end
        end
    end
end
print(string.format("lowest foot over %d posed frames: %.1f cm (max of the lowest %.1f)",
    stats.n, stats.min, stats.max))
for _, s in ipairs(samples) do print("  " .. s) end
