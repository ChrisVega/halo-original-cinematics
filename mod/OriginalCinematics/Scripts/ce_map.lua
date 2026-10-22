-- Reader for Halo: Combat Evolved cache files (.map) as shipped in the
-- player's Master Chief Collection (halo1\maps). Read-only, nothing is copied.
-- Layouts follow Invader's tag definitions (github.com/SnowyMouse/invader).

local M = {}
M.__index = M

local unpack = string.unpack

function M.open(path)
    local f, err = io.open(path, "rb")
    if not f then return nil, err end
    local self = setmetatable({ f = f, path = path }, M)
    local head = self:read_at(0, 0x800)
    if head:sub(1, 4) ~= "daeh" then return nil, "not a Halo cache file" end
    self.version = unpack("<I4", head, 5)
    self.tag_data_offset = unpack("<I4", head, 0x11)
    self.tag_data_size = unpack("<I4", head, 0x15)
    self.name = head:sub(0x21, 0x40):match("^[^%z]*")
    self.tag_data = self:read_at(self.tag_data_offset, self.tag_data_size)
    local tag_array = unpack("<I4", self.tag_data, 1)
    self.base = tag_array - 0x28
    self.scenario_id = unpack("<I4", self.tag_data, 5)
    self.tag_count = unpack("<I4", self.tag_data, 0x0D)
    self.tags, self.by_path, self.by_id = {}, {}, {}
    for i = 0, self.tag_count - 1 do
        local o = 0x28 + i * 32
        local c0, c1, c2, id, path_ptr, data_ptr, external = unpack("<c4c4c4I4I4I4I4", self.tag_data, o + 1)
        local t = {
            index = i, class = c0:reverse(), id = id, external = external ~= 0,
            data = data_ptr, path = self:cstring(path_ptr),
        }
        self.tags[i] = t
        self.by_id[id] = t
        self.by_path[t.path .. "." .. t.class] = t
    end
    return self
end

function M:read_at(offset, size)
    self.f:seek("set", offset)
    return self.f:read(size)
end

-- tag-data pointer -> 1-based index into self.tag_data
function M:ofs(ptr) return ptr - self.base + 1 end

function M:cstring(ptr)
    local i = self:ofs(ptr)
    local j = self.tag_data:find("\0", i, true)
    return self.tag_data:sub(i, j - 1)
end

function M:u8(ptr) return unpack("<B", self.tag_data, self:ofs(ptr)) end
function M:i8(ptr) return unpack("<b", self.tag_data, self:ofs(ptr)) end
function M:i16(ptr) return unpack("<i2", self.tag_data, self:ofs(ptr)) end
function M:u16(ptr) return unpack("<I2", self.tag_data, self:ofs(ptr)) end
function M:u32(ptr) return unpack("<I4", self.tag_data, self:ofs(ptr)) end
function M:f32(ptr) return unpack("<f", self.tag_data, self:ofs(ptr)) end
function M:str32(ptr) return self.tag_data:sub(self:ofs(ptr), self:ofs(ptr) + 31):match("^[^%z]*") end
function M:vec3(ptr) return { unpack("<fff", self.tag_data, self:ofs(ptr)) } end

function M:reflexive(ptr)
    local count, first = unpack("<I4I4", self.tag_data, self:ofs(ptr))
    return count, first
end

-- Iterate a reflexive block: yields (index, element pointer)
function M:each(ptr, stride)
    local count, first = self:reflexive(ptr)
    local i = -1
    return function()
        i = i + 1
        if i < count then return i, first + i * stride end
    end
end

-- TagDataOffset: raw bytes, internal (in tag data) or at a file offset
function M:data(ptr)
    local size, external, file_offset, data_ptr = unpack("<I4I4I4I4", self.tag_data, self:ofs(ptr))
    if size == 0 then return "" end
    if external ~= 0 then return self:read_at(file_offset, size) end
    local i = self:ofs(data_ptr)
    return self.tag_data:sub(i, i + size - 1)
end

function M:dependency(ptr)
    local class, path_ptr, _, id = unpack("<c4I4I4I4", self.tag_data, self:ofs(ptr))
    if id == 0xFFFFFFFF then return nil end
    return self.by_id[id]
end

function M:scenario()
    return self.by_id[self.scenario_id]
end

-- Scenario contents a cutscene needs ---------------------------------------------
local SCN = {
    object_names = 0x204, scenery = 0x210, scenery_palette = 0x21c,
    bipeds = 0x228, biped_palette = 0x234, vehicles = 0x240, vehicle_palette = 0x24c,
    recorded_animations = 0x36c, source_files = 0x4c0,
    cutscene_flags = 0x4e4, cutscene_camera_points = 0x4f0, structure_bsps = 0x5a4,
}
M.SCN = SCN

function M:read_scenario()
    local s = self:scenario().data
    local out = { object_names = {}, flags = {}, cameras = {}, recordings = {}, bipeds = {}, scenery = {}, vehicles = {},
        biped_palette = {}, scenery_palette = {}, vehicle_palette = {}, source = {} }

    for i, p in self:each(s + SCN.object_names, 36) do
        out.object_names[i] = { name = self:str32(p), type = self:i16(p + 32), index = self:i16(p + 34) }
    end
    for i, p in self:each(s + SCN.cutscene_flags, 92) do
        local name = self:str32(p + 4)
        out.flags[name] = { pos = self:vec3(p + 36), facing = { unpack("<ff", self.tag_data, self:ofs(p + 48)) } }
    end
    for i, p in self:each(s + SCN.cutscene_camera_points, 104) do
        local name = self:str32(p + 4)
        out.cameras[name] = { pos = self:vec3(p + 40), rot = self:vec3(p + 52), fov = self:f32(p + 64) }
    end
    for i, p in self:each(s + SCN.recorded_animations, 64) do
        local name = self:str32(p)
        out.recordings[name] = {
            version = self:i8(p + 32), raw = self:i8(p + 33), control_version = self:i8(p + 34),
            length = self:i16(p + 36), stream = self:data(p + 44),
        }
    end
    local function palette(off, into)
        for i, p in self:each(s + off, 48) do
            local t = self:dependency(p)
            into[i] = t and t.path or nil
        end
    end
    palette(SCN.biped_palette, out.biped_palette)
    palette(SCN.scenery_palette, out.scenery_palette)
    palette(SCN.vehicle_palette, out.vehicle_palette)
    local function placements(off, stride, into)
        for i, p in self:each(s + off, stride) do
            into[i] = {
                type = self:i16(p), name = self:i16(p + 2), not_placed = self:u16(p + 4),
                permutation = self:i16(p + 6), pos = self:vec3(p + 8), rot = self:vec3(p + 20),
            }
        end
    end
    placements(SCN.bipeds, 120, out.bipeds)
    placements(SCN.scenery, 72, out.scenery)
    placements(SCN.vehicles, 120, out.vehicles)
    for i, p in self:each(s + SCN.source_files, 52) do
        out.source[i] = { name = self:str32(p), text = self:data(p + 32) }
    end
    return out
end

function M:close() self.f:close() end

return M
