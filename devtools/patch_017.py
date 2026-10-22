"""One-off edit for 0.1.7: the lower lip, teeth and tongue open with the jaw."""
from pathlib import Path
p = Path(__file__).resolve().parent.parent / "mod" / "OriginalCinematics" / "Scripts" / "ue_stage.lua"
s = p.read_text(encoding="utf-8")


def rep(a, b):
    global s
    assert s.count(a) == 1, a[:80]
    s = s.replace(a, b)


# helpers after world_quat
rep('''-- Turn the face's follow bones as far as their body bones have turned.''', '''local function world_pos(comp, bone)
    local t = comp:GetBoneTransformByName(FName(bone), 0).Translation
    local v = { tonumber(t.X), tonumber(t.Y), tonumber(t.Z) }
    for i = 1, 3 do if type(v[i]) ~= "number" then return nil end end
    return v
end

local function vsub(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local function vadd(a, b) return { a[1] + b[1], a[2] + b[2], a[3] + b[3] } end

-- Turn the face's follow bones as far as their body bones have turned.''')

# init: collect the mouth group after the jaw is found
rep('''                    rep.jaw = { bone = n, parent = parent, local_q = Q.mul(Q.conj(pw), jw) }
                    self.log("mouth %s: jaw bone %s (parent %s)", rep.row.id, n, parent)''',
'''                    rep.jaw = { bone = n, parent = parent, local_q = Q.mul(Q.conj(pw), jw) }
                    self.log("mouth %s: jaw bone %s (parent %s)", rep.row.id, n, parent)
                    rep.jaw.group = self:_mouth_group(rep, n, jaw.with or {})''')

rep('''function Stage:_jaw(rep)''', '''-- The face's lips, teeth and tongue hang off the face root, not the jaw, so
-- turning the jaw alone only drops the chin. Every bone whose name matches a
-- "with" pattern (and whose ancestors don't) is carried round the jaw's pivot
-- by the same turn, times its weight (lip corners half way).
function Stage:_mouth_group(rep, jaw_bone, with)
    local face = rep.face
    local nb = 0
    pcall(function() nb = face:GetNumBones() end)
    local names, parent_of = {}, {}
    for b = 0, nb - 1 do
        pcall(function()
            local bn = face:GetBoneName(b):ToString()
            names[#names + 1] = bn
            parent_of[bn] = face:GetParentBone(FName(bn)):ToString()
        end)
    end
    local function weight(bn)
        for _, w in ipairs(with) do
            if bn:find(w[1], 1, true) then return w[2] end
        end
    end
    local function under(bn, set)
        local p = parent_of[bn]
        local guard = 0
        while p and p ~= "None" and guard < 64 do
            if set[p] then return true end
            p = parent_of[p]; guard = guard + 1
        end
        return false
    end
    local picked = {}
    for _, bn in ipairs(names) do if bn ~= jaw_bone and weight(bn) then picked[bn] = true end end
    local group, list = {}, {}
    for bn in pairs(picked) do
        if not under(bn, picked) and not under(bn, { [jaw_bone] = true }) then
            local par = parent_of[bn]
            local pw, bw = world_quat(face, par), world_quat(face, bn)
            local pp, bp = world_pos(face, par), world_pos(face, bn)
            if pw and bw and pp and bp then
                group[#group + 1] = { bone = bn, parent = par, w = weight(bn),
                    lq = Q.mul(Q.conj(pw), bw), lp = Q.rotate(Q.conj(pw), vsub(bp, pp)) }
                list[#list + 1] = bn
            end
        end
    end
    table.sort(list)
    self.log("mouth %s: %d bones open with the jaw: %s", rep.row.id, #group, table.concat(list, ","))
    return group
end

function Stage:_jaw(rep)''')

# apply each frame: replace the final set of jaw rotation
rep('''        local open = Q.from_axis_angle(right, j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp))
        q = Q.norm(Q.mul(open, q))
    end
    rep.face:SetBoneRotationByName(FName(j.bone), Q.to_rotator(q), 0)''',
'''        local open = Q.from_axis_angle(right, j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp))
        q = Q.norm(Q.mul(open, q))
        j.right = right
    end
    local angle = j.right and j.sign and j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp) or 0
    -- the mouth group first, from the face as it is before the jaw turns
    if j.group and #j.group > 0 then
        local pivot = world_pos(rep.face, j.bone)
        local moves = {}
        for _, g in ipairs(j.group) do
            local pw, pp = world_quat(rep.face, g.parent), world_pos(rep.face, g.parent)
            if pw and pp and pivot then
                local rq = Q.mul(pw, g.lq)
                local rp = vadd(pp, Q.rotate(pw, g.lp))
                if angle ~= 0 and rep.jaw_amp > 0.02 then
                    local r = Q.from_axis_angle(j.right, angle * g.w)
                    rq = Q.norm(Q.mul(r, rq))
                    rp = vadd(pivot, Q.rotate(r, vsub(rp, pivot)))
                end
                moves[#moves + 1] = { g.bone, rq, rp }
            end
        end
        for _, m in ipairs(moves) do
            rep.face:SetBoneLocationByName(FName(m[1]), { X = m[3][1], Y = m[3][2], Z = m[3][3] }, 0)
            rep.face:SetBoneRotationByName(FName(m[1]), Q.to_rotator(m[2]), 0)
        end
    end
    rep.face:SetBoneRotationByName(FName(j.bone), Q.to_rotator(q), 0)''')
p.write_text(s, encoding="utf-8")
print("patched")
