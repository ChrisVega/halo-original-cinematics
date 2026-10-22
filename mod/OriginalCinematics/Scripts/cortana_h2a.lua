-- Cortana from the player's Halo 2 Anniversary files (h2a.lua), posed by the
-- original's own Cortana animations: her H2A skeleton uses the same bone names
-- as the CE biped ("_b_l_upperarm" = "bip01 l upperarm"), so each CE node's
-- turn from its rest pose is put on the matching H2A bone, and her mesh is
-- skinned on the CPU (linear blend, up to four bones a vertex).
--
-- Spaces: H2A templates are metres, right-handed, x forward, y up, z right.
-- Everything here is done in CE's frame (x forward, y left, z up), still in
-- metres: (x, y, z)h2a -> (x, -z, y)ce.

local Q = require("qmath")
local RT = require("retarget")

local C = {}
C.__index = C

local function to_ce(v) return { v[1], -v[3], v[2] } end
local function sub(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local function add(a, b) return { a[1] + b[1], a[2] + b[2], a[3] + b[3] } end
local function unit(v)
    local l = math.sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
    if l < 1e-9 then return nil end
    return { v[1] / l, v[2] / l, v[3] / l }
end
local function from_to(a, b)
    local d = a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
    if d < -0.9999 then return { 0, 0, 1, 0 } end
    local c = { a[2] * b[3] - a[3] * b[2], a[3] * b[1] - a[1] * b[3], a[1] * b[2] - a[2] * b[1] }
    return Q.norm({ c[1], c[2], c[3], 1 + d })
end

-- "_b_l_upperarm" -> "bip01 l upperarm"; a few H2A names differ.
local RENAME = { ["_b_jaw"] = "frame jawbone", ["_b_l_toe"] = "bip01 l toe0", ["_b_r_toe"] = "bip01 r toe0" }
local function ce_name(bone)
    if RENAME[bone] then return RENAME[bone] end
    local rest = bone:match("^_b_(.+)$")
    if not rest then return nil end
    return "bip01 " .. rest:gsub("_", " ")
end

-- tpl: H2A template (h2a.lua); nodes/model_nodes: the CE graph's nodes and
-- the CE model's default nodes; keep: part indices to draw.
function C.new(tpl, nodes, model_nodes, log)
    local self = setmetatable({ log = log or function() end }, C)
    local rt = RT.new(nodes, model_nodes, {}, {})
    self.rt = rt
    local by_name = rt.by_name
    -- skeleton (object ids are 0-based)
    local bones = {}
    for _, o in ipairs(tpl.objects) do
        if o.bone and o.bind then
            bones[o.id] = { id = o.id, parent = o.parent, name = o.bone,
                B = to_ce({ o.bind[13], o.bind[14], o.bind[15] }), node = by_name[ce_name(o.bone) or ""] }
        end
    end
    local order = {}
    for _, b in pairs(bones) do
        local d, p = 0, bones[b.parent]
        while p and d < 64 do d = d + 1; p = bones[p.parent] end
        b.depth = d
        order[#order + 1] = b
    end
    table.sort(order, function(a, b) return a.depth < b.depth end)
    -- rest alignment: swing each mapped bone's bind direction (to its first
    -- mapped child) onto the CE rest direction of the same limb
    local mapped = 0
    for _, b in ipairs(order) do
        if b.node then
            mapped = mapped + 1
            for _, c in ipairs(order) do
                if c.parent == b.id and c.node then
                    local a0, c0 = rt.rest_world[b.node], rt.rest_world[c.node]
                    local ce = a0 and c0 and unit(sub(c0.pos, a0.pos))
                    local h2 = unit(sub(c.B, b.B))
                    if ce and h2 then b.align = from_to(h2, ce) end
                    break
                end
            end
        end
    end
    self.bones, self.order = bones, order
    log(string.format("cortana h2a: %d bones, %d follow the original's", #order, mapped))
    -- parts in CE space
    self.parts = {}
    for _, p in ipairs(tpl.parts) do
        local verts = {}
        for i, v in ipairs(p.verts) do verts[i] = to_ce(v) end
        self.parts[#self.parts + 1] = { src = p, verts = verts, skin = p.skin, tris = p.tris, uvs = p.uvs, mat = p.mat }
    end
    return self
end

-- Bone rotations and positions for a CE frame ([node] = {rot, pos}).
function C:solve(frame, jaw_open)
    local R, P = {}, {}
    local W
    if frame then
        local local_tf = {}
        for i, f in pairs(frame) do local_tf[i] = { rot = Q.conj(f.rot), pos = f.pos } end
        W = self.rt:_fk(local_tf)
    end
    for _, b in ipairs(self.order) do
        local pr = R[b.parent]
        local rot
        if b.node and W and W[b.node] and self.rt.rest_world[b.node] then
            local d = Q.mul(W[b.node].rot, Q.conj(self.rt.rest_world[b.node].rot))
            rot = b.align and Q.mul(d, b.align) or d
        else
            rot = pr or { 0, 0, 0, 1 }
        end
        if b.name == "_b_jaw" and jaw_open and jaw_open > 0 and pr then
            -- open around the head's left axis (CE +y), chin down
            local left = Q.rotate(pr, { 0, 1, 0 })
            rot = Q.mul(Q.from_axis_angle(left, jaw_open), rot)
        end
        R[b.id] = Q.norm(rot)
        local parent = self.bones[b.parent]
        if parent and P[parent.id] then
            P[b.id] = add(P[parent.id], Q.rotate(R[parent.id], sub(b.B, parent.B)))
        else
            P[b.id] = b.B
        end
    end
    return R, P
end

-- Skinned vertices of every part, in Unreal centimetres around her feet
-- (scale: the size she is drawn at). Per bone a 3x3 matrix is made once per
-- pose; each vertex keeps its offsets from its bones, so a pose costs a few
-- multiplies per vertex.
local function mat3(q)
    local x, y, z, w = q[1], q[2], q[3], q[4]
    return { 1 - 2 * (y * y + z * z), 2 * (x * y - z * w), 2 * (x * z + y * w),
             2 * (x * y + z * w), 1 - 2 * (x * x + z * z), 2 * (y * z - x * w),
             2 * (x * z - y * w), 2 * (y * z + x * w), 1 - 2 * (x * x + y * y) }
end

function C:_prepare()
    local bones = self.bones
    for _, part in ipairs(self.parts) do
        local inf = {}
        for i, v in ipairs(part.verts) do
            local list, tw = {}, 0
            for _, e in ipairs(part.skin[i] or {}) do
                local b = bones[e[1]]
                if b then tw = tw + e[2] end
            end
            for _, e in ipairs(part.skin[i] or {}) do
                local b = bones[e[1]]
                if b and tw > 0 then
                    list[#list + 1] = b.id; list[#list + 1] = e[2] / tw
                    list[#list + 1] = v[1] - b.B[1]; list[#list + 1] = v[2] - b.B[2]; list[#list + 1] = v[3] - b.B[3]
                end
            end
            inf[i] = list
        end
        part.inf = inf
    end
end

function C:skin(R, P, scale)
    if not self.parts[1] or not self.parts[1].inf then self:_prepare() end
    local s = 100 * (scale or 1)
    local M = {}
    for id, q in pairs(R) do M[id] = mat3(q) end
    local out = {}
    for pi, part in ipairs(self.parts) do
        local vs = {}
        for i, list in ipairs(part.inf) do
            local x, y, z = 0, 0, 0
            local n = #list
            if n == 0 then
                local v = part.verts[i]; x, y, z = v[1], v[2], v[3]
            else
                for k = 1, n, 5 do
                    local id, w = list[k], list[k + 1]
                    local m, p = M[id], P[id]
                    local dx, dy, dz = list[k + 2], list[k + 3], list[k + 4]
                    x = x + (p[1] + m[1] * dx + m[2] * dy + m[3] * dz) * w
                    y = y + (p[2] + m[4] * dx + m[5] * dy + m[6] * dz) * w
                    z = z + (p[3] + m[7] * dx + m[8] * dy + m[9] * dz) * w
                end
            end
            vs[i] = { X = x * s, Y = -y * s, Z = z * s }
        end
        out[pi] = vs
    end
    return out
end

return C
