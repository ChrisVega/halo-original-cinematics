-- Offline check: does the retarget reproduce the original's pose shape?
-- For a few moments of the x10 intro it compares, for bone pairs, the
-- original's own relative orientation (ground truth, mirrored) with what the
-- current delta-on-rest method and an absolute-orientation transfer give.
-- run: python devtools/run_pose.py
local ce = require("ce_map")
local CM = require("ce_model")
local RT = require("retarget")
local Q = require("qmath")
local S = require("ce_scene")
local sheets = require("sheets_gen")

local MAP = POSE_MAP
local REST = POSE_REST

local rest = assert(loadfile(REST))()
local by_name = {}
for _, b in ipairs(rest) do by_name[b.name] = b end

local scene = S.load(MAP, nil)
local tl = scene:timeline("bridge,hangar_cryo")

local g = scene:graph([[characters\captain\captain]])
local model = CM.read(scene.map, scene.map.by_path[ [[characters\captain\captain.mod2]] ])
local rows = {}
for _, r in ipairs(sheets.bone_map) do if r.rig == "captain" then rows[#rows + 1] = r end
end
local rt = RT.new(g.nodes, model.nodes, rows, by_name)
print("mapped bones: " .. #rt.map)

local function angle(q)
    local w = math.min(1, math.abs(q[4]))
    return math.deg(2 * math.acos(w))
end
local function rel(a, b) return Q.norm(Q.mul(Q.conj(a), b)) end

local PAIRS = {
    { "Root_M", "Spine1_M" }, { "Spine1_M", "Chest_M" }, { "Chest_M", "Neck_M" },
    { "Chest_M", "Head_M" }, { "Neck_M", "Head_M" }, { "Chest_M", "Shoulder_R" },
}

local function report(tag, f)
    local lt = {}
    for i, n in pairs(f) do lt[i] = { rot = Q.conj(n.rot), pos = n.pos } end
    local W = rt:_fk(lt)
    local cur, abso = {}, {}
    for _, m in ipairs(rt.map) do
        local w, w0 = W[m.node], rt.rest_world[m.node]
        if w and w0 then
            local rr = rt.remake_rest[m.bone]
            local delta = Q.mul(w.rot, Q.conj(w0.rot))
            cur[m.bone] = Q.norm(Q.mul(Q.mirror_y(delta), rr.rot))
            abso[m.bone] = Q.norm(Q.mul(Q.mul(rr.rot, Q.conj(Q.mirror_y(w0.rot))), Q.mirror_y(w.rot)))
        end
    end
    local line = { tag }
    local node_of = {}
    for _, m in ipairs(rt.map) do node_of[m.bone] = m.node end
    for _, p in ipairs(PAIRS) do
        local ia, ib = node_of[p[1]], node_of[p[2]]
        local wa, wb = ia and W[ia], ib and W[ib]
        if wa and wb and cur[p[1]] and cur[p[2]] then
            local ideal = rel(Q.mirror_y(wa.rot), Q.mirror_y(wb.rot))
            local ec = angle(rel(ideal, rel(cur[p[1]], cur[p[2]])))
            local ea = angle(rel(ideal, rel(abso[p[1]], abso[p[2]])))
            line[#line + 1] = string.format("%s>%s cur %.1f abs %.1f", p[1]:sub(1, 6), p[2]:sub(1, 6), ec, ea)
        end
    end
    print(table.concat(line, "  "))
    -- per-bone turn from rest, current method, plus the original's own turn
    local turns = {}
    for _, m in ipairs(rt.map) do
        local w, w0 = W[m.node], rt.rest_world[m.node]
        if w and w0 and cur[m.bone] then
            turns[#turns + 1] = string.format("%s ce %.0f cur %.0f", m.bone, angle(rel(w0.rot, w.rot)),
                angle(rel(rt.remake_rest[m.bone].rot, cur[m.bone])))
        end
    end
    print("    " .. table.concat(turns, "  "))
end

local seen = 0
for tick = 1, 6000 do
    local ok = pcall(function() return tl:step() end)
    if not ok then break end
    local o = tl.objects and tl.objects.keyes_x10
    if o then
        local anim, frame = tl:pose_of(o)
        if anim then
            local frames = scene:frames(anim)
            local f = frames and frames[frame]
            if f then
                seen = seen + 1
                if seen == 30 or seen == 150 or seen == 400 or seen == 900 or seen == 1500 or seen == 2000 or seen == 2600 then
                    report(string.format("tick %d frame %d:", tick, frame), f)
                end
            end
        end
    end
end
print("posed frames seen: " .. seen)
