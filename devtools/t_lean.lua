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


local WU = 304.8
local function ce_world(o, w)  -- CE model-space node -> UE world cm
    local cy, sy = math.cos(o.yaw), math.sin(o.yaw)
    local x, y, z = w.pos[1], w.pos[2], w.pos[3]
    return { (o.pos[1] + cy * x - sy * y) * WU, -(o.pos[2] + sy * x + cy * y) * WU, (o.pos[3] + z) * WU }
end
local function ue_world(o, p)  -- remake component space -> UE world cm (actor yaw = -deg(o.yaw))
    local a = -o.yaw
    local c, s = math.cos(a), math.sin(a)
    return { o.pos[1] * WU + c * p[1] - s * p[2], -o.pos[2] * WU + s * p[1] + c * p[2], o.pos[3] * WU + p[3] }
end
local idx = {}
for i, n in pairs(g.nodes) do idx[n.name] = i end
local pairs_ = { {"bip01 l hand","Wrist_L"}, {"bip01 r hand","Wrist_R"}, {"bip01 head","Head_M"}, {"bip01 neck","Neck_M"}, {"bip01 pelvis","Root_M"} }
local function d3(a, b) return math.sqrt((a[1]-b[1])^2 + (a[2]-b[2])^2 + (a[3]-b[3])^2) end
for tick = 1, 9000 do
    local ok = pcall(function() return tl:step() end)
    if not ok then break end
    local o = tl.objects and tl.objects.keyes_x10
    local crew = tl.objects and tl.objects.x10_crew_1l
    if o and o.custom and (tick % 10 == 0) then
        local anim, frame = tl:pose_of(o)
        local f = anim and scene:frames(anim); f = f and f[frame]
        if f then
            local items = rt:solve(f)
            local pos = posed(items)
            local line = string.format("tick %d %s f%d keyes(%.0f,%.0f) crew(%.0f,%.0f):", tick, anim.name, frame,
                o.pos[1]*WU, -o.pos[2]*WU, crew and crew.pos[1]*WU or 0, crew and -crew.pos[2]*WU or 0)
            for _, pr in ipairs(pairs_) do
                local ce = ce_world(o, rt.last_W[idx[pr[1]]])
                local us = ue_world(o, pos[pr[2]])
                line = line .. string.format(" %s orig(%.0f,%.0f,%.0f) ours(%.0f,%.0f,%.0f) d=%.0f |", pr[2], ce[1],ce[2],ce[3], us[1],us[2],us[3], d3(ce,us))
            end
            print(line)
        end
    end
end
