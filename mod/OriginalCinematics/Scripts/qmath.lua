-- Small quaternion/vector helpers. Quaternions are {x, y, z, w}.

local Q = {}

-- UE4SS sometimes hands back a struct or a function where a plain quaternion
-- table is expected; report it once instead of taking the whole scene down.
local bad = 0
local function valid(q, where)
    local what
    if type(q) ~= "table" then
        what = type(q)
    else
        for i = 1, 4 do
            if type(q[i]) ~= "number" then what = string.format("q[%d]=%s", i, type(q[i])); break end
        end
    end
    if not what then return true end
    if bad < 8 then
        bad = bad + 1
        print(string.format("[OC] bad quaternion in %s: %s", where, what))
        if debug and debug.traceback then print(debug.traceback()) end
    end
    return false
end

function Q.mul(a, b)
    if not (valid(a, "mul a") and valid(b, "mul b")) then return { 0, 0, 0, 1 } end
    return {
        a[4] * b[1] + a[1] * b[4] + a[2] * b[3] - a[3] * b[2],
        a[4] * b[2] - a[1] * b[3] + a[2] * b[4] + a[3] * b[1],
        a[4] * b[3] + a[1] * b[2] - a[2] * b[1] + a[3] * b[4],
        a[4] * b[4] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3],
    }
end

function Q.conj(q)
    if not valid(q, "conj") then return { 0, 0, 0, 1 } end
    return { -q[1], -q[2], -q[3], q[4] }
end

function Q.norm(q)
    if not valid(q, "norm") then return { 0, 0, 0, 1 } end
    local n = math.sqrt(q[1] * q[1] + q[2] * q[2] + q[3] * q[3] + q[4] * q[4])
    if n == 0 then return { 0, 0, 0, 1 } end
    return { q[1] / n, q[2] / n, q[3] / n, q[4] / n }
end

function Q.rotate(q, v)
    local p = Q.mul(Q.mul(q, { v[1], v[2], v[3], 0 }), Q.conj(q))
    return { p[1], p[2], p[3] }
end

function Q.from_axis_angle(axis, angle)
    local s = math.sin(angle / 2)
    return { axis[1] * s, axis[2] * s, axis[3] * s, math.cos(angle / 2) }
end

-- Mirror a rotation across the XZ plane (Y -> -Y): what a right-handed
-- Halo rotation becomes in Unreal's left-handed frame.
-- normalised lerp along the short way (fine for blending part of a turn)
function Q.nlerp(a, b, t)
    local d = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
    local s = d < 0 and -1 or 1
    return Q.norm({ a[1] + (s * b[1] - a[1]) * t, a[2] + (s * b[2] - a[2]) * t,
        a[3] + (s * b[3] - a[3]) * t, a[4] + (s * b[4] - a[4]) * t })
end

function Q.mirror_y(q)
    if not valid(q, "mirror") then return { 0, 0, 0, 1 } end
    return { -q[1], q[2], -q[3], q[4] }
end

-- Unreal FRotator (degrees) from a quaternion in Unreal's frame
-- (same conversion as FQuat::Rotator).
function Q.to_rotator(q)
    if not valid(q, "to_rotator") then return { Pitch = 0, Yaw = 0, Roll = 0 } end
    local x, y, z, w = q[1], q[2], q[3], q[4]
    local sing = z * x - w * y
    local yawY = 2 * (w * z + x * y)
    local yawX = 1 - 2 * (y * y + z * z)
    local R2D = 180 / math.pi
    local pitch, yaw, roll
    local th = 0.4999995
    if sing < -th then
        pitch = -90
        yaw = math.atan(yawY, yawX) * R2D
        roll = -yaw - 2 * math.atan(x, w) * R2D
    elseif sing > th then
        pitch = 90
        yaw = math.atan(yawY, yawX) * R2D
        roll = yaw - 2 * math.atan(x, w) * R2D
    else
        pitch = math.asin(2 * sing) * R2D
        yaw = math.atan(yawY, yawX) * R2D
        roll = math.atan(-2 * (w * x + y * z), 1 - 2 * (x * x + y * y)) * R2D
    end
    return { Pitch = pitch, Yaw = yaw, Roll = roll }
end

-- Quaternion from an Unreal FRotator (degrees), as FRotator::Quaternion.
function Q.from_rotator(r)
    local D2R = math.pi / 360
    local sp, cp = math.sin(r.Pitch * D2R), math.cos(r.Pitch * D2R)
    local sy, cy = math.sin(r.Yaw * D2R), math.cos(r.Yaw * D2R)
    local sr, cr = math.sin(r.Roll * D2R), math.cos(r.Roll * D2R)
    return {
        cr * sp * sy - sr * cp * cy,
        -cr * sp * cy - sr * cp * sy,
        cr * cp * sy - sr * sp * cy,
        cr * cp * cy + sr * sp * sy,
    }
end

return Q
