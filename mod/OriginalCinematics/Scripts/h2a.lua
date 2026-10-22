-- Reads Halo 2 Anniversary (Saber3D) assets straight from the player's MCC
-- (halo2\preload\paks\shared.pck): a template's (.tpl) mesh, skeleton and skin
-- weights, and a picture's (.pct) texture data. Layout per Wildenhaus/Index
-- (LibH2A). Nothing is copied out of the game except what the caller writes
-- to the mod's own cache.

local H = {}
H.__index = H

local unpack = string.unpack
local CHUNK = 0x8000

-- shared.pck is a chunked stream: chunk count, compression (4 = stored), and
-- the file offset of every 32 KiB chunk.
function H.open(path)
    local f = io.open(path, "rb")
    if not f then return nil, "cannot open " .. path end
    local n, kind = unpack("<i4i4", f:read(8))
    if kind ~= 4 then f:close(); return nil, "compressed pck not supported" end
    local offs = {}
    local raw = f:read(8 * n)
    for i = 1, n do offs[i] = unpack("<i8", raw, (i - 1) * 8 + 1) end
    local contiguous = true
    for i = 2, n, 97 do if offs[i] ~= offs[1] + (i - 1) * CHUNK then contiguous = false; break end end
    local self = setmetatable({ f = f, offs = offs, contiguous = contiguous }, H)
    self.top = self:children(0)
    return self
end

function H:close() if self.f then self.f:close(); self.f = nil end end

function H:read(pos, size)
    if self.contiguous then
        self.f:seek("set", self.offs[1] + pos)
        return self.f:read(size)
    end
    local out = {}
    while size > 0 do
        local ci, co = pos // CHUNK, pos % CHUNK
        local take = math.min(size, CHUNK - co)
        self.f:seek("set", self.offs[ci + 1] + co)
        out[#out + 1] = self.f:read(take)
        pos, size = pos + take, size - take
    end
    return table.concat(out)
end

-- Entries of a pck container that starts at stream position start.
function H:children(start)
    local p = start + 0x45
    local n = unpack("<i4", self:read(p, 4)); p = p + 9
    local hdr = self:read(p, n * 160 + 64)
    local names, q = {}, 1
    for i = 1, n do
        local ln = unpack("<i4", hdr, q)
        if q + 4 + ln > #hdr then hdr = hdr .. self:read(p + #hdr, n * 160) end
        names[i] = hdr:sub(q + 4, q + 3 + ln); q = q + 4 + ln
    end
    p = p + (q - 1) + 1
    local offs = self:read(p, 8 * n); p = p + 8 * n + 1
    local sizes = self:read(p, 4 * n)
    local list = {}
    for i = 1, n do
        list[i] = { name = names[i], pos = start + unpack("<i8", offs, (i - 1) * 8 + 1), size = unpack("<i4", sizes, (i - 1) * 4 + 1) }
    end
    return list
end

function H:entry(name)
    for _, e in ipairs(self.top) do if e.name == name then return e end end
end

-- Bytes of a file in shared.pck: "<database>:x.tpl" holds a pck around the
-- tpl itself; textures are stored directly.
function H:file(kind, name)
    local e = self:entry("<" .. kind .. ">:" .. name)
    if not e or e.size == 0 then return nil end
    local head = self:read(e.pos, 8)
    if head:sub(1, 7) == "1SERpak" then
        for _, c in ipairs(self:children(e.pos)) do
            if c.size > 0 and c.name:sub(-#name) == name then return self:read(c.pos, c.size) end
        end
        return nil
    end
    return self:read(e.pos, e.size)
end

-- Template --------------------------------------------------------------------
local function pstr32(d, p) local n = unpack("<I4", d, p); return d:sub(p + 4, p + 3 + n), p + 4 + n end
local function pstr16(d, p) local n = unpack("<I2", d, p); return d:sub(p + 2, p + 1 + n), p + 2 + n end
local function bits(d, p, n)
    local t = {}
    for i = 0, n - 1 do t[i + 1] = (d:byte(p + i // 8) >> (i % 8)) & 1 == 1 end
    return t, p + (n + 7) // 8
end

local function read_objects(d, p)
    local count, _, pc = unpack("<I2I2I2", d, p); p = p + 8
    local objs = {}
    for i = 1, count do objs[i] = { id = i - 1 } end
    local function present() local v = d:byte(p); p = p + 1; return v ~= 0 end
    if pc > 0 and present() then for _, o in ipairs(objs) do o.id = unpack("<i2", d, p); p = p + 2 end end
    if pc > 1 and present() then for _, o in ipairs(objs) do o.readname, p = pstr32(d, p) end end
    if pc > 2 and present() then p = p + 7 * count end
    for i, key in ipairs({ "parent", "next", "prev", "child", "anim" }) do
        if pc > i + 2 and present() then for _, o in ipairs(objs) do o[key] = unpack("<i2", d, p); p = p + 2 end end
    end
    if pc > 8 and present() then for _, o in ipairs(objs) do o.readaffixes, p = pstr32(d, p) end end
    -- model-space bind matrix, then the local one (row-major 4x4, translation in row 4)
    if pc > 9 and present() then for _, o in ipairs(objs) do o.bind = { unpack("<" .. string.rep("f", 16), d, p) }; p = p + 64 end end
    if pc > 10 and present() then for _, o in ipairs(objs) do o.loc = { unpack("<" .. string.rep("f", 16), d, p) }; p = p + 64 end end
    if pc > 11 and present() then
        local fl; fl, p = bits(d, p, count)
        for i = 1, count do if fl[i] then p = p + 5 + 8 + 24 end end
    end
    if pc > 12 and present() then for _, o in ipairs(objs) do o.path, p = pstr32(d, p) end end
    if pc > 13 and present() then p = p + 60 * count end
    if pc > 14 and present() then for _, o in ipairs(objs) do o.name, p = pstr16(d, p) end end
    if pc > 15 and present() then for _, o in ipairs(objs) do o.affixes, p = pstr16(d, p) end end
    for _, o in ipairs(objs) do
        if o.path then o.bone = o.path:match("([^|]+)$") end
    end
    return objs, p
end

local function read_graph(d, p)
    assert(d:sub(p, p + 3) == "OGM1", "no geometry graph")
    local gtype = unpack("<I2", d, p + 4); p = p + 10
    assert(gtype == 1, "graph type " .. gtype)
    local g = { objects = {} }
    if d:byte(p) ~= 0 then p = p + 1; g.objects, p = read_objects(d, p) else p = p + 1 end
    while true do
        local sent = unpack("<I2", d, p); p = p + 2
        if sent == 0x0000 then
            local e = unpack("<I4", d, p)
            g.nbuf, g.nmesh, g.nsub = unpack("<I4I4I4", d, p + 4 + 2 + 4)
            p = e + 1
        elseif sent == 0x0002 then
            local send = unpack("<I4", d, p) + 1; p = p + 4
            local bufs = {}
            for i = 1, g.nbuf do bufs[i] = {} end
            while p < send do
                local s2, e2 = unpack("<I2I4", d, p); p = p + 6
                if s2 == 0 then for _, b in ipairs(bufs) do b.flags = unpack("<I8", d, p + 2); p = p + 10 end
                elseif s2 == 1 then for _, b in ipairs(bufs) do b.esize = unpack("<I2", d, p); p = p + 2 end
                elseif s2 == 2 then for _, b in ipairs(bufs) do b.len = unpack("<I4", d, p); p = p + 4 end
                elseif s2 == 3 then for _, b in ipairs(bufs) do b.start = p; p = p + b.len end end
                p = e2 + 1
            end
            g.buffers = bufs
        elseif sent == 0x0003 then
            local send = unpack("<I4", d, p) + 1; p = p + 4
            local meshes = {}
            for i = 1, g.nmesh do meshes[i] = {} end
            while p < send do
                local s2, e2 = unpack("<I2I4", d, p); p = p + 6
                if s2 == 0 then for _, m in ipairs(meshes) do m.flags = unpack("<I8", d, p + 2); p = p + 10 end
                elseif s2 == 2 then
                    for _, m in ipairs(meshes) do
                        local n = d:byte(p); p = p + 1
                        m.bufs = {}
                        for k = 1, n do m.bufs[k] = { unpack("<I4I4", d, p) }; p = p + 8 end
                    end
                end
                p = e2 + 1
            end
            g.meshes = meshes
        elseif sent == 0x0004 then
            local send = unpack("<I4", d, p) + 1; p = p + 4
            local subs = {}
            for i = 1, g.nsub do subs[i] = {} end
            local mats = {}
            while p < send do
                local s2, e2 = unpack("<I2I4", d, p); p = p + 6
                local stop = e2 + 1
                if s2 == 0 and #subs > 0 then
                    local esz = (stop - p) // #subs
                    for _, sm in ipairs(subs) do
                        sm.vo, sm.vc, sm.fo, sm.fc, sm.node, sm.skin = unpack("<I2I2I2I2I2i2", d, p); p = p + 12
                        if esz > 12 then
                            local fl = unpack("<I4", d, p); p = p + 4
                            for _ = 1, 32 do
                                if fl & 1 ~= 0 then p = p + 8 end
                                fl = ((fl << 1) | (fl >> 31)) & 0xFFFFFFFF
                            end
                        end
                    end
                elseif s2 == 1 then for _, sm in ipairs(subs) do sm.mesh = unpack("<I4", d, p) + 1; p = p + 4 end
                elseif s2 == 3 then
                    for _, sm in ipairs(subs) do
                        if g.meshes[sm.mesh].flags & (1 << 9) ~= 0 then
                            local n = d:byte(p); p = p + 1
                            sm.bones = {}
                            for k = 1, n do sm.bones[k] = unpack("<i2", d, p); p = p + 2 end
                        end
                    end
                elseif s2 == 4 then
                    for _, sm in ipairs(subs) do
                        if g.meshes[sm.mesh].flags & (1 << 30) ~= 0 then
                            local n = d:byte(p); p = p + 1
                            sm.uvscale = {}
                            for _ = 1, n do sm.uvscale[d:byte(p)] = unpack("<i2", d, p + 1); p = p + 3 end
                        end
                    end
                elseif s2 == 5 then
                    for _, sm in ipairs(subs) do
                        if g.meshes[sm.mesh].flags & (1 << 3) ~= 0 then
                            sm.pos = { unpack("<i2i2i2", d, p) }; sm.scale = { unpack("<i2i2i2", d, p + 6) }; p = p + 12
                        end
                    end
                elseif s2 >= 6 and s2 <= 8 then
                    -- materials: per submesh in order; the texture and material
                    -- names are the readable strings after shadingMtl_Tex / _Mtl
                    local raw = d:sub(p, stop - 1)
                    local at = 1
                    for i = 1, #subs do
                        local a = raw:find("shadingMtl_Tex", at, true)
                        if not a then break end
                        local tex = raw:match("shadingMtl_Tex....(....)", a)
                        local tn = tex and unpack("<I4", tex) or 0
                        local tstart = a + #"shadingMtl_Tex" + 8
                        local texname = raw:sub(tstart, tstart + tn - 1)
                        local b = raw:find("shadingMtl_Mtl", tstart, true)
                        local mn = b and unpack("<I4", raw, b + #"shadingMtl_Mtl" + 4) or 0
                        local mstart = b and (b + #"shadingMtl_Mtl" + 8) or tstart
                        mats[i] = { texture = texname, material = b and raw:sub(mstart, mstart + mn - 1) or "" }
                        at = mstart + mn
                    end
                end
                p = stop
            end
            for i, sm in ipairs(subs) do sm.mat = mats[i] or { texture = "", material = "" } end
            g.subs = subs
        elseif sent == 0xFFFF then
            break
        else
            error(string.format("geometry sentinel %x", sent))
        end
    end
    return g
end

local function snorm16(v) return v / 32767 end

-- Vertices of one submesh: positions (template units: metres, Y up), uvs,
-- triangles (1-based, local to the submesh) and up to four (bone, weight).
local function build_sub(d, g, sm)
    local mesh = g.meshes[sm.mesh]
    local out = { verts = {}, uvs = {}, tris = {}, skin = {}, mat = sm.mat }
    for _, mb in ipairs(mesh.bufs) do
        local b = g.buffers[mb[1] + 1]
        local fl, es = b.flags, b.esize
        if fl & 1 ~= 0 then
            local start = sm.vo + mb[2] // es
            local sc, ps = sm.scale or { 1, 1, 1 }, sm.pos or { 0, 0, 0 }
            local weighted = fl & 0x1F0 ~= 0
            for i = 0, sm.vc - 1 do
                local q = b.start + (start + i) * es
                local x, y, z
                if fl & 8 ~= 0 then
                    x, y, z = unpack("<i2i2i2", d, q); x, y, z = snorm16(x), snorm16(y), snorm16(z); q = q + 6
                else
                    x, y, z = unpack("<fff", d, q); q = q + 12
                end
                out.verts[i + 1] = { x * sc[1] + ps[1], y * sc[2] + ps[2], z * sc[3] + ps[3] }
                if weighted then
                    if fl & (1 << 11) ~= 0 then q = q + ((fl & 8 ~= 0) and 2 or 4) end
                    local w = {}
                    for k = 0, 3 do if fl & (1 << (4 + k)) ~= 0 then w[#w + 1] = d:byte(q) / 255; q = q + 1 end end
                    local idx = { 0, 0, 0, 0 }
                    if fl & (1 << 8) ~= 0 then idx = { d:byte(q, q + 3) } end
                    local s = {}
                    for k = 1, #w do
                        if w[k] > 0 and sm.bones then s[#s + 1] = { sm.bones[idx[k] + 1], w[k] } end
                    end
                    out.skin[i + 1] = s
                end
            end
        elseif fl == 0 then
            local start = sm.fo + mb[2] // es
            for k = 0, sm.fc - 1 do
                local a, bb, c = unpack("<I2I2I2", d, b.start + (start + k) * es)
                out.tris[#out.tris + 1] = { a - sm.vo + 1, bb - sm.vo + 1, c - sm.vo + 1 }
            end
        elseif fl & ((0x1F << 12) | (0x1F << 25)) ~= 0 then
            local start = sm.vo + mb[2] // es
            local uvs = sm.uvscale and sm.uvscale[0] or 1
            for i = 0, sm.vc - 1 do
                local q = b.start + (start + i) * es
                for t = 0, 4 do if fl & (1 << (12 + t)) ~= 0 then q = q + 4 end end
                for k = 22, 24 do if fl & (1 << k) ~= 0 then q = q + 4 end end
                local u, v = 0, 0
                if fl & (1 << 25) ~= 0 then
                    if fl & (1 << 30) ~= 0 then u, v = unpack("<i2i2", d, q); u, v = snorm16(u), 1 - snorm16(v)
                    else u, v = unpack("<ff", d, q); v = 1 - v end
                end
                out.uvs[i + 1] = { u * uvs, v * uvs }
            end
        end
    end
    return out
end

-- name: "cortana__h.tpl". keep(sub, index) picks the submeshes wanted.
function H:template(name, keep)
    local d = self:file("database", name)
    if not d then return nil, "no template " .. name end
    local at = d:find("OGM1", 1, true)
    if not at then return nil, "no geometry in " .. name end
    local g = read_graph(d, at)
    local parts = {}
    for i, sm in ipairs(g.subs) do
        if not keep or keep(sm, i) then
            local part = build_sub(d, g, sm)
            part.index = i
            parts[#parts + 1] = part
        end
    end
    return { objects = g.objects, subs = g.subs, parts = parts }
end

-- Texture data of a picture: width, height, mip count, format id, raw bytes.
function H:picture(name)
    local d = self:file("textures", name)
    if not d then return nil end
    local pic, p = {}, 1
    while p < #d do
        local sent, e = unpack("<I2I4", d, p); p = p + 6
        if sent == 0x0102 then pic.w, pic.h = unpack("<i4i4", d, p)
        elseif sent == 0xF2 then pic.format = unpack("<i4", d, p)
        elseif sent == 0xF9 then pic.mips = unpack("<i4", d, p)
        elseif sent == 0xFF then pic.data = d:sub(p, e) end
        if sent == 0x01 then break end
        p = e + 1
    end
    return pic
end

-- A .dds file for a DXT5/DXT1 picture, so the bundled ffmpeg can turn it into
-- an image the remake loads.
function H.dds(pic)
    local fourcc = ({ [0x11] = "DXT5", [0x0F] = "DXT3", [0x0C] = "DXT1", [0x0D] = "DXT1" })[pic.format]
    if not fourcc then return nil end
    local hdr = string.pack("<c4I4I4I4I4I4I4I4", "DDS ", 124, 0x1 | 0x2 | 0x4 | 0x1000 | 0x20000 | 0x80000,
        pic.h, pic.w, #pic.data, 0, pic.mips or 1)
        .. string.rep("\0", 44)
        .. string.pack("<I4I4c4I4I4I4I4I4", 32, 0x4, fourcc, 0, 0, 0, 0, 0)
        .. string.pack("<I4I4I4I4I4", 0x1000 | 0x400008, 0, 0, 0, 0)
    return hdr .. pic.data
end

return H
