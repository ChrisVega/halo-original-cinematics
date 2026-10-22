"""One-off edit for 0.1.8: body vs look direction, head turn, mouth axis from the
head, padded voice clips."""
from pathlib import Path
S = Path(__file__).resolve().parent.parent / "mod" / "OriginalCinematics" / "Scripts"


def edit(name, pairs):
    p = S / name
    s = p.read_text(encoding="utf-8")
    for a, b in pairs:
        assert s.count(a) == 1, (name, a[:70])
        s = s.replace(a, b)
    p.write_text(s, encoding="utf-8")


# --- timeline: body turns only when walking or when the look is far off ------
edit("ce_timeline.lua", [
    ('''    local moving = false
    if o.rec then
        local c = o.rec:step()
        local fx, fy = c.facing[1], c.facing[2]
        if fx * fx + fy * fy > 1e-6 then o.yaw = math.atan(fy, fx) end
        local tx, ty = c.throttle[1], c.throttle[2]
        if math.abs(tx) + math.abs(ty) > 0.01 then
            moving = true''',
     '''    local moving = false
    if o.rec then
        local c = o.rec:step()
        local fx, fy = c.facing[1], c.facing[2]
        local face = (fx * fx + fy * fy > 1e-6) and math.atan(fy, fx) or o.yaw
        local lx, ly = c.looking[1], c.looking[2]
        o.look_yaw = (lx * lx + ly * ly > 1e-6) and math.atan(ly, lx) or face
        local tx, ty = c.throttle[1], c.throttle[2]
        local walking = math.abs(tx) + math.abs(ty) > 0.01
        -- A standing biped keeps its feet planted: small changes of facing are
        -- a look (head, neck and chest turn), only a large one turns the body,
        -- at a walking turn's pace. Walking, the body follows the facing.
        local d = face - o.yaw
        while d > math.pi do d = d - 2 * math.pi end
        while d < -math.pi do d = d + 2 * math.pi end
        if walking then o.yaw = face
        elseif math.abs(d) > BODY_TURN_AT then
            local step = math.min(math.abs(d) - BODY_TURN_AT * 0.5, BODY_TURN_RATE)
            o.yaw = o.yaw + (d > 0 and step or -step)
        end
        if walking then
            moving = true'''),
    ('''local function frame_info(map, a, f)''',
     '''-- Standing still, a turn of the facing larger than this (radians) turns the
-- body, at most this far per tick; smaller ones are carried by head and chest.
local BODY_TURN_AT = math.rad(70)
local BODY_TURN_RATE = math.rad(4)

local function frame_info(map, a, f)'''),
])

# --- stage: head/neck/chest carry the look; mouth axis from the head ---------
edit("ue_stage.lua", [
    ('''                        for _, b in ipairs(posed) do
                            if type(b.bone) ~= "string" or type(b.rot) ~= "table" then''',
     '''                        -- The look: what the facing/look direction is off the
                        -- body is shared out to chest, neck and head (each bone's
                        -- component-space rotation carries the turn so far).
                        local look = 0
                        if o.look_yaw then
                            look = o.look_yaw - o.yaw
                            while look > math.pi do look = look - 2 * math.pi end
                            while look < -math.pi do look = look + 2 * math.pi end
                            look = math.max(-LOOK_MAX, math.min(LOOK_MAX, look))
                        end
                        rep.look = (rep.look or 0) + (look - (rep.look or 0)) * 0.25
                        for _, b in ipairs(posed) do
                            local share = LOOK_SHARE[b.bone]
                            if share and math.abs(rep.look) > 0.005 and type(b.rot) == "table" then
                                b.rot = Q.norm(Q.mul(Q.from_axis_angle({ 0, 0, 1 }, -rep.look * share), b.rot))
                            end
                        end
                        for _, b in ipairs(posed) do
                            if type(b.bone) ~= "string" or type(b.rot) ~= "table" then'''),
    ('''local FOOT_MARKS = { "Toes", "Ankle", "Foot", "Ball", "Heel", "Sole" }''',
     '''local FOOT_MARKS = { "Toes", "Ankle", "Foot", "Ball", "Heel", "Sole" }

-- How a look off the body is carried (cumulative share at each bone, root to
-- tip), and the furthest the head turns before the body has to.
local LOOK_SHARE = { Spine1_M = 0.15, Chest_M = 0.35, Neck_M = 0.65, Head_M = 1.0 }
local LOOK_MAX = math.rad(80)'''),
    # mouth: axis in the jaw parent's own frame, sign fixed at the start
    ('''                if pw and jw then
                    rep.jaw = { bone = n, parent = parent, local_q = Q.mul(Q.conj(pw), jw) }''',
     '''                if pw and jw then
                    rep.jaw = { bone = n, parent = parent, local_q = Q.mul(Q.conj(pw), jw) }
                    -- his left-right axis and forward, kept in the head's own
                    -- frame, so the jaw opens the same way however the head turns
                    local yaw = 0
                    pcall(function() yaw = math.rad(rep.actor:K2_GetActorRotation().Yaw) end)
                    local fwd, right = { math.cos(yaw), math.sin(yaw), 0 }, { -math.sin(yaw), math.cos(yaw), 0 }
                    local test = Q.rotate(Q.from_axis_angle(right, math.rad(10)), fwd)
                    rep.jaw.sign = test[3] < 0 and 1 or -1
                    rep.jaw.right_local = Q.rotate(Q.conj(pw), right)'''),
    ('''    if rep.jaw_amp > 0.02 then
        -- his left-right axis, from the actor's yaw; turned so the chin drops
        local yaw = 0
        pcall(function() yaw = math.rad(rep.actor:K2_GetActorRotation().Yaw) end)
        local fwd, right = { math.cos(yaw), math.sin(yaw), 0 }, { -math.sin(yaw), math.cos(yaw), 0 }
        if not j.sign then
            local test = Q.rotate(Q.from_axis_angle(right, math.rad(10)), fwd)
            j.sign = test[3] < 0 and 1 or -1
        end
        local open = Q.from_axis_angle(right, j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp))
        q = Q.norm(Q.mul(open, q))
        j.right = right
    end''',
     '''    j.right = Q.rotate(pw, j.right_local)
    if rep.jaw_amp > 0.02 then
        local open = Q.from_axis_angle(j.right, j.sign * math.rad((jaw.max_deg or 14) * rep.jaw_amp))
        q = Q.norm(Q.mul(open, q))
    end'''),
])

# --- sound: half a second of silence after each line -------------------------
edit("ce_sound.lua", [
    ("""'-map 0:v -map 1:a -shortest -c:v libopenh264""",
     """'-map 0:v -map 1:a -af apad=pad_dur=0.6 -shortest -c:v libopenh264"""),
    ('''    return self.cache .. "\\\\" .. tag_name:gsub("[\\\\/ ]", "_") .. ".v2.mp4"''',
     '''    -- v3: padded with silence at the end; the media player drops the last
    -- fraction of a second of a clip, which cut the ends of lines off
    return self.cache .. "\\\\" .. tag_name:gsub("[\\\\/ ]", "_") .. ".v3.mp4"'''),
])
print("patched")
