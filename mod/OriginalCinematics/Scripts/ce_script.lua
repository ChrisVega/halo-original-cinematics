-- Turns a CE scenario's compiled scripts (script syntax nodes) back into
-- expression trees, so the original cutscene scripts can be run by the mod.
-- A call node is { fn = "name", args = {...} }; a primitive is
-- { value = <string|number|boolean>, type = "<value type>" }.

local S = {}

local unpack = string.unpack

local TYPES = {
    [0] = "unparsed", "special_form", "function_name", "passthrough", "void", "boolean", "real", "short",
    "long", "string", "script", "trigger_volume", "cutscene_flag", "cutscene_camera_point", "cutscene_title",
    "cutscene_recording", "device_group", "ai", "ai_command_list", "starting_profile", "conversation",
    "navpoint", "hud_message", "object_list", "sound", "effect", "damage", "looping_sound",
    "animation_graph", "actor_variant", "damage_effect", "object_definition", "game_difficulty", "team",
    "ai_default_state", "actor_type", "hud_corner", "object", "unit", "vehicle", "weapon", "device",
    "scenery", "object_name", "unit_name", "vehicle_name", "weapon_name", "device_name", "scenery_name",
}
local SCRIPT_TYPES = { [0] = "startup", "dormant", "continuous", "static", "stub" }
local DIFFICULTY = { [0] = "easy", "normal", "hard", "impossible" }

local F_PRIMITIVE, F_GLOBAL = 1, 4

-- map: an opened ce_map; returns { scripts = { name -> {type, body} }, globals = { name -> expr } }
function S.read(map)
    local s = map:scenario().data
    local syntax = map:data(s + 0x474)
    local strings = map:data(s + 0x488)
    local element_size = unpack("<I2", syntax, 35)
    local count = unpack("<I2", syntax, 47)
    assert(element_size == 20, "unexpected script node size " .. element_size)
    local NODE0 = 57

    local script_names = {}
    for i, p in map:each(s + 0x49c, 92) do script_names[i] = map:str32(p) end

    local function cstr(off)
        local j = strings:find("\0", off + 1, true)
        return strings:sub(off + 1, (j or #strings + 1) - 1)
    end

    local function node(index)
        local o = NODE0 + index * 20
        local _, _, vtype, flags, next_node, str_off, data = unpack("<I2I2I2I2I4I4I4", syntax, o)
        return vtype, flags, next_node, str_off, data
    end

    local decode
    local function primitive(vtype, flags, str_off, data)
        local tname = TYPES[vtype] or tostring(vtype)
        if flags & F_GLOBAL ~= 0 then return { global = cstr(str_off), type = tname } end
        if tname == "void" then return { type = "void" } end
        if tname == "short" then
            local v = data & 0xFFFF; if v >= 0x8000 then v = v - 0x10000 end
            return { value = v, type = tname }
        end
        if tname == "long" then
            local v = data; if v >= 0x80000000 then v = v - 0x100000000 end
            return { value = v, type = tname }
        end
        if tname == "real" then return { value = unpack("<f", string.pack("<I4", data)), type = tname } end
        if tname == "boolean" then return { value = (data & 0xFF) ~= 0, type = tname } end
        if tname == "script" then return { value = script_names[data & 0xFFFF], type = tname } end
        if tname == "game_difficulty" then return { value = DIFFICULTY[data & 0xFFFF], type = tname } end
        return { value = cstr(str_off), type = tname }
    end

    -- A call: data holds the first child; the first child is the function name.
    function decode(datum)
        local list = {}
        while datum ~= 0xFFFFFFFF do
            local index = datum & 0xFFFF
            if index >= count then break end
            local vtype, flags, next_node, str_off, data = node(index)
            if flags & F_PRIMITIVE ~= 0 then
                list[#list + 1] = primitive(vtype, flags, str_off, data)
            else
                local children = decode(data)
                local head = table.remove(children, 1)
                list[#list + 1] = { fn = head and (head.value or head.global) or "?", args = children, type = TYPES[vtype] }
            end
            datum = next_node
        end
        return list
    end

    local out = { scripts = {}, globals = {} }
    for i, p in map:each(s + 0x49c, 92) do
        local name = map:str32(p)
        local stype = SCRIPT_TYPES[map:u16(p + 32)]
        local root = map:u32(p + 36)
        local body = decode(root)
        -- root is (begin ...) wrapping the script body
        out.scripts[name] = { type = stype, body = body[1] }
    end
    for i, p in map:each(s + 0x4a8, 92) do
        local name = map:str32(p)
        out.globals[name] = decode(map:u32(p + 40))[1]
    end
    return out
end

-- Debug printer (HaloScript-like text)
function S.format(e, depth)
    depth = depth or 0
    if e == nil then return "" end
    if e.fn then
        local parts = { e.fn }
        for _, a in ipairs(e.args) do parts[#parts + 1] = S.format(a, depth + 1) end
        return "(" .. table.concat(parts, " ") .. ")"
    end
    if e.global then return e.global end
    if e.value == nil then return "none" end
    local v = tostring(e.value)
    if v:find(" ") or v == "" then v = '"' .. v .. '"' end
    return v
end

return S
