-- Transfers an original CE pose onto a remake skeleton.
-- CE stores node rotations as conjugated quaternions in a right-handed,
-- Z-up frame (x forward, y left) measured in 10-foot world units; Unreal is
-- left-handed (x forward, y right) in centimetres. For each mapped node:
--   delta = W_anim(node) * W_rest(node)^-1        (CE model space)
--   bone  = mirror_y(delta) * C * R_rest(bone)     (remake component space)
-- C (limbs with an "align" row) swings the remake bone's rest direction onto
-- the original's rest direction first: the remake rests legs apart and
-- forearms forward, the original hangs them straight.

local Q = require("qmath")

local RT = {}
RT.__index = RT

local WU = 304.8

local function unit(v)
    local l = math.sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
    if l < 1e-9 then return nil end
    return { v[1] / l, v[2] / l, v[3] / l }
end

-- shortest rotation taking unit vector a onto unit vector b
local function from_to(a, b)
    local d = a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
    if d < -0.9999 then return { 0, 0, 1, 0 } end
    local c = { a[2] * b[3] - a[3] * b[2], a[3] * b[1] - a[1] * b[3], a[1] * b[2] - a[2] * b[1] }
    return Q.norm({ c[1], c[2], c[3], 1 + d })
end

-- nodes: CE nodes [0..n-1] with .name/.parent; rest: CE model nodes (pos/rot);
-- rows: bone_map rows for this rig; remake_rest: bone name -> {rot = quat, pos = {x,y,z}} component space
function RT.new(nodes, rest_model_nodes, rows, remake_rest)
    local self = setmetatable({ nodes = nodes, map = {}, order = {}, remake_rest = remake_rest }, RT)
    local by_name = {}
    for i, n in pairs(nodes) do by_name[n.name] = i end
    self.by_name = by_name
    -- rest world rotations from the model's default node transforms (same node order by name)
    local rest_local = {}
    for _, mn in pairs(rest_model_nodes) do
        local i = by_name[mn.name]
        if i then rest_local[i] = { rot = Q.conj(Q.norm(mn.rot)), pos = mn.pos } end
    end
    self.rest_world = self:_fk(rest_local)
    for _, r in ipairs(rows) do
        local i = by_name[r.ce_node]
        if i and r.mode ~= "skip" and remake_rest[r.remake_bone] then
            local m = { node = i, bone = r.remake_bone, root = r.mode:find("root") ~= nil }
            local al = r.align
            if al and al[1] == "inherit" then m.inherit = true end
            if al and #al == 2 and by_name[al[1]] and remake_rest[al[2]] then
                local a, b = self.rest_world[i], self.rest_world[by_name[al[1]]]
                local ce = unit({ b.pos[1] - a.pos[1], -(b.pos[2] - a.pos[2]), b.pos[3] - a.pos[3] })
                local ra, rb = remake_rest[r.remake_bone].pos, remake_rest[al[2]].pos
                local re = unit({ rb[1] - ra[1], rb[2] - ra[2], rb[3] - ra[3] })
                if ce and re then m.align = from_to(re, ce) end
            end
            self.map[#self.map + 1] = m
        end
    end
    -- parents before children
    table.sort(self.map, function(a, b) return self:_depth(a.node) < self:_depth(b.node) end)
    -- end bones keep their rest bend: they take their mapped parent's swing
    local by_node = {}
    for _, m in ipairs(self.map) do by_node[m.node] = m end
    for _, m in ipairs(self.map) do
        if m.inherit then
            local pm = by_node[nodes[m.node].parent]
            m.align = pm and pm.align or nil
        end
    end
    return self
end

function RT:_depth(i)
    local d, n = 0, self.nodes[i]
    while n and n.parent and n.parent >= 0 and n.parent ~= i and d < 64 do
        d = d + 1; i = n.parent; n = self.nodes[i]
    end
    return d
end

function RT:_fk(local_tf)
    local W = {}
    local function solve(i)
        if W[i] then return W[i] end
        local l = local_tf[i]
        if not l then W[i] = { rot = { 0, 0, 0, 1 }, pos = { 0, 0, 0 } }; return W[i] end
        local n = self.nodes[i]
        local p = n.parent
        if p == nil or p < 0 or p == i then
            W[i] = { rot = l.rot, pos = { l.pos[1], l.pos[2], l.pos[3] } }
        else
            local pw = solve(p)
            local off = Q.rotate(pw.rot, l.pos)
            W[i] = { rot = Q.norm(Q.mul(pw.rot, l.rot)), pos = { pw.pos[1] + off[1], pw.pos[2] + off[2], pw.pos[3] + off[3] } }
        end
        return W[i]
    end
    for i in pairs(self.nodes) do solve(i) end
    return W
end

-- A frame from another graph with the same body (by node name) in this one's
-- node order.
function RT:remap(frame, graph)
    self.remaps = self.remaps or {}
    local m = self.remaps[graph]
    if not m then
        m = {}
        for i, n in pairs(graph.nodes) do
            local j = self.by_name[n.name]
            if j then m[i] = j end
        end
        self.remaps[graph] = m
    end
    local out = {}
    for i, x in pairs(frame) do
        local j = m[i]
        if j then out[j] = x end
    end
    return out
end

-- frame: decoded animation frame [node] = {rot, pos}. Returns a list of
-- { bone, rot = quat (component space), loc = {x,y,z} or nil } in parent-first order.
function RT:solve(frame)
    local local_tf = {}
    for i, f in pairs(frame) do local_tf[i] = { rot = Q.conj(f.rot), pos = f.pos } end
    local W = self:_fk(local_tf)
    self.last_W = W
    local out = {}
    for _, m in ipairs(self.map) do
        local w, w0 = W[m.node], self.rest_world[m.node]
        if w and w0 then
            local delta = Q.mul(w.rot, Q.conj(w0.rot))
            local rr = self.remake_rest[m.bone]
            local base = m.align and Q.mul(m.align, rr.rot) or rr.rot
            local item = { bone = m.bone, rot = Q.norm(Q.mul(Q.mirror_y(delta), base)) }
            if m.root then
                local d = { (w.pos[1] - w0.pos[1]) * WU, -(w.pos[2] - w0.pos[2]) * WU, (w.pos[3] - w0.pos[3]) * WU }
                item.loc = { rr.pos[1] + d[1], rr.pos[2] + d[2], rr.pos[3] + d[3] }
            end
            out[#out + 1] = item
        end
    end
    return out
end

return RT
