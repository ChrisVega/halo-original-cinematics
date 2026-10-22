-- Reads CE animation graphs (model_animations tags) from the player's map:
-- skeleton nodes and per-frame node poses (rotation quaternion, translation, scale).

local A = {}

local unpack = string.unpack

-- model_animations
local MA_NODES, MA_ANIMS = 104, 116
local NODE_SIZE, ANIM_SIZE = 64, 180

function A.read_graph(map, tag)
    local base = tag.data
    local g = { path = tag.path, nodes = {}, animations = {}, by_name = {} }
    for i, p in map:each(base + MA_NODES, NODE_SIZE) do
        g.nodes[i] = {
            name = map:str32(p), next = map:i16(p + 32), child = map:i16(p + 34), parent = map:i16(p + 36),
        }
    end
    for i, p in map:each(base + MA_ANIMS, ANIM_SIZE) do
        local a = {
            index = i, name = map:str32(p), type = map:u16(p + 32), frame_count = map:u16(p + 34),
            frame_size = map:u16(p + 36), frame_info_type = map:u16(p + 38), node_count = map:u16(p + 44),
            flags = map:u16(p + 58),
            trans_flags = { map:u32(p + 92), map:u32(p + 96) },
            rot_flags = { map:u32(p + 108), map:u32(p + 112) },
            scale_flags = { map:u32(p + 124), map:u32(p + 128) },
            compressed_offset = map:u32(p + 136),
            ptr = p,
        }
        a.compressed = (a.flags & 1) ~= 0
        g.animations[i] = a
        g.by_name[a.name] = a
    end
    return g
end

local function bit(flags, n)
    local w = flags[(n // 32) + 1] or 0
    return (w >> (n % 32)) & 1 == 1
end

local function quat16(s, o)
    local x, y, z, w = unpack("<i2i2i2i2", s, o)
    local k = 1 / 32767
    x, y, z, w = x * k, y * k, z * k, w * k
    local n = math.sqrt(x * x + y * y + z * z + w * w)
    if n > 0 then x, y, z, w = x / n, y / n, z / n, w / n end
    return { x, y, z, w }
end

local function normalize(q)
    local n = math.sqrt(q[1] * q[1] + q[2] * q[2] + q[3] * q[3] + q[4] * q[4])
    if n > 0 then return { q[1] / n, q[2] / n, q[3] / n, q[4] / n } end
    return { 0, 0, 0, 1 }
end

-- 48-bit packed quaternion: four 12-bit-ish components spread over three words
local function quat6(s, o)
    local w0, w1, w2 = unpack("<I2I2I2", s, o)
    local function s16(v) v = v & 0xFFFF; if v >= 0x8000 then v = v - 0x10000 end return v end
    local i = s16((w0 >> 12) | (w0 & 0xFFF0))
    local j = s16(((w1 >> 4) & 0x0FF0) | (w0 & 0x000F) | (w0 << 12))
    local k = s16(((((w2 >> 4) & 0x0F00) | (w1 & 0x00F0)) >> 4) | (w1 << 8))
    local w = s16(((w2 >> 8) & 0x000F) | (w2 << 4))
    local sc = 1 / 32767
    return normalize({ i * sc, j * sc, k * sc, w * sc })
end

local function nlerp(a, b, t)
    local d = a[1] * b[1] + a[2] * b[2] + a[3] * b[3] + a[4] * b[4]
    local s = d < 0 and -1 or 1
    return normalize({ a[1] + (b[1] * s - a[1]) * t, a[2] + (b[2] * s - a[2]) * t,
        a[3] + (b[3] * s - a[3]) * t, a[4] + (b[4] * s - a[4]) * t })
end

local function lerp3(a, b, t)
    return { a[1] + (b[1] - a[1]) * t, a[2] + (b[2] - a[2]) * t, a[3] + (b[3] - a[3]) * t }
end

-- One track kind of a compressed animation: value at a frame for a node.
-- read(s, offset_of_index) decodes one stored value; size is its byte size.
local function track(c, hdr_off, idx_off, def_off, key_off, read, size, mix)
    return function(adjusted, node, frame)
        local nh = unpack("<I4", c, hdr_off + adjusted * 4 + 1)
        local first, count = nh >> 12, nh & 0xFFF
        local default = read(c, def_off + node * size + 1)
        if count == 0 then return default end
        local function key(i) return read(c, key_off + (first + i) * size + 1) end
        local function kframe(i) return unpack("<I2", c, idx_off + (first + i) * 2 + 1) end
        local last = kframe(count - 1)
        if frame >= last then return key(count - 1) end
        local f0, v0, f1, v1
        if frame < kframe(0) then
            f0, v0, f1, v1 = 0, default, kframe(0), key(0)
        else
            local i = 0
            while i + 1 < count and kframe(i + 1) <= frame do i = i + 1 end
            f0, v0, f1, v1 = kframe(i), key(i), kframe(i + 1), key(i + 1)
        end
        if frame == f0 then return v0 end
        return mix(v0, v1, (frame - f0) / (f1 - f0))
    end
end

local function decode_compressed(map, a)
    local frames_data = map:data(a.ptr + 160)
    local c = frames_data:sub(a.compressed_offset + 1)
    local h = { unpack("<i4i4i4i4i4i4i4i4i4i4i4", c, 1) }
    -- rotation node headers start at 0x2C
    local rot = track(c, 0x2C, h[1], h[2], h[3], quat6, 6, nlerp)
    local pos = track(c, h[4], h[5], h[6], h[7], function(s, o) return { unpack("<fff", s, o) } end, 12, lerp3)
    local scl = track(c, h[8], h[9], h[10], h[11], function(s, o) return unpack("<f", s, o) end, 4,
        function(x, y, t) return x + (y - x) * t end)
    local frames = {}
    for f = 0, a.frame_count - 1 do
        local frame, ri, ti, si = {}, 0, 0, 0
        for n = 0, a.node_count - 1 do
            local node = {}
            if bit(a.rot_flags, n) then node.rot = rot(ri, n, f); ri = ri + 1
            else node.rot = quat6(c, h[2] + n * 6 + 1) end
            if bit(a.trans_flags, n) then node.pos = pos(ti, n, f); ti = ti + 1
            else node.pos = { unpack("<fff", c, h[6] + n * 12 + 1) } end
            if bit(a.scale_flags, n) then node.scale = scl(si, n, f); si = si + 1
            elseif h[10] + n * 4 + 4 <= #c then node.scale = unpack("<f", c, h[10] + n * 4 + 1)
            else node.scale = 1.0 end -- animations that never scale store no default scales
            frame[n] = node
        end
        frames[f] = frame
    end
    return frames
end

-- Decode an animation into frames[f][node] = {rot={x,y,z,w}, pos={x,y,z}, scale=s}
function A.decode(map, a)
    if a.compressed then return decode_compressed(map, a) end
    local default = map:data(a.ptr + 140)
    local frames_data = map:data(a.ptr + 160)
    local frames = {}
    -- default values for non-animated components, node by node
    local defaults, dp = {}, 1
    for n = 0, a.node_count - 1 do
        local d = {}
        if not bit(a.rot_flags, n) then d.rot = quat16(default, dp); dp = dp + 8 end
        if not bit(a.trans_flags, n) then d.pos = { unpack("<fff", default, dp) }; dp = dp + 12 end
        if not bit(a.scale_flags, n) then d.scale = unpack("<f", default, dp); dp = dp + 4 end
        defaults[n] = d
    end
    local fp = 1
    for f = 0, a.frame_count - 1 do
        local frame = {}
        for n = 0, a.node_count - 1 do
            local d = defaults[n]
            local node = {}
            if bit(a.rot_flags, n) then node.rot = quat16(frames_data, fp); fp = fp + 8 else node.rot = d.rot end
            if bit(a.trans_flags, n) then node.pos = { unpack("<fff", frames_data, fp) }; fp = fp + 12 else node.pos = d.pos end
            if bit(a.scale_flags, n) then node.scale = unpack("<f", frames_data, fp); fp = fp + 4 else node.scale = d.scale end
            frame[n] = node
        end
        frames[f] = frame
    end
    return frames
end

return A
