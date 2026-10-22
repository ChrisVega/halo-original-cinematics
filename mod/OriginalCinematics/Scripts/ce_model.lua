-- Reads a CE gbxmodel (mod2) from the player's map: nodes, and the geometry
-- of one permutation as vertex/triangle lists with their skin nodes.
-- Used for stand-ins the remake doesn't have (Cortana's hologram).

local M = {}

local unpack = string.unpack

local MOD_NODES, MOD_REGIONS, MOD_GEOMS = 184, 196, 208

function M.read(map, tag, lod)
    local base = tag.data
    local model = { path = tag.path, nodes = {}, parts = {} }
    for i, p in map:each(base + MOD_NODES, 156) do
        model.nodes[i] = {
            name = map:str32(p), next = map:i16(p + 32), child = map:i16(p + 34), parent = map:i16(p + 36),
            pos = map:vec3(p + 40), rot = { unpack("<ffff", map.tag_data, map:ofs(p + 52)) },
        }
    end
    -- model data area: vertices, then triangle indices (tag data header fields)
    local model_data_offset = unpack("<I4", map.tag_data, 0x14 + 1)
    local index_offset = unpack("<I4", map.tag_data, 0x1C + 1)

    -- geometry index for each region's first permutation at the requested detail level
    local geoms = {}
    for _, r in map:each(base + MOD_REGIONS, 76) do
        local cnt, first = map:reflexive(r + 64)
        if cnt > 0 then
            local perm = first
            local g = map:i16(perm + 64 + (lod or 4) * 2) -- super low .. super high: 64..72
            geoms[#geoms + 1] = g
        end
    end
    local gcount, gfirst = map:reflexive(base + MOD_GEOMS)
    for _, gi in ipairs(geoms) do
        if gi >= 0 and gi < gcount then
            local g = gfirst + gi * 48
            for _, p in map:each(g + 36, 132) do
                local vcount = map:u32(p + 88)
                local voff = map:u32(p + 100)
                local tcount = map:u32(p + 72)
                local toff = map:u32(p + 76)
                local local_count = map:u8(p + 107)
                local locals = {}
                for k = 0, local_count - 1 do locals[k] = map:u8(p + 108 + k) end
                local vdata = map:read_at(model_data_offset + voff, vcount * 68)
                local verts = {}
                for v = 0, vcount - 1 do
                    local o = v * 68 + 1
                    local px, py, pz, nx, ny, nz = unpack("<ffffff", vdata, o)
                    local u, vv = unpack("<ff", vdata, o + 48)
                    local n0, n1, w0, w1 = unpack("<i2i2ff", vdata, o + 56)
                    if local_count > 0 then
                        n0 = n0 >= 0 and locals[n0] or n0
                        n1 = n1 >= 0 and locals[n1] or n1
                    end
                    verts[v] = { pos = { px, py, pz }, normal = { nx, ny, nz }, uv = { u, vv }, n0 = n0, n1 = n1, w0 = w0 }
                end
                -- triangle strip of 16-bit indices, -1 (0xFFFF) restarts nothing in CE: use degenerate skipping
                local idx = map:read_at(model_data_offset + index_offset + toff, (tcount + 2) * 2)
                local strip = {}
                for k = 1, tcount + 2 do
                    local v = unpack("<I2", idx, (k - 1) * 2 + 1)
                    strip[k] = v
                end
                local tris = {}
                for k = 1, #strip - 2 do
                    local a, b, c = strip[k], strip[k + 1], strip[k + 2]
                    if a ~= b and b ~= c and a ~= c and a ~= 0xFFFF and b ~= 0xFFFF and c ~= 0xFFFF then
                        if k % 2 == 1 then tris[#tris + 1] = { a, b, c } else tris[#tris + 1] = { a, c, b } end
                    end
                end
                model.parts[#model.parts + 1] = { verts = verts, vcount = vcount, tris = tris }
            end
        end
    end
    return model
end

return M
