-- Ride watcher: while the Silent Cartographer (B30) is loaded, samples once a
-- second what the remake's own Pelican ride does, so the flight can be built
-- from facts. Read-only: it changes nothing in the game.
--
-- One line per second: the level's age, the player's pawn (and what it is
-- attached to), the camera, and every Pelican actor's position, rotation and
-- speed, plus the marines near the Pelican.
--
-- Only runs when <mod>\dev\enabled exists, so it never ships to players.

local W = {}

local log_file

local function log(fmt, ...)
    local line = select("#", ...) == 0 and fmt or string.format(fmt, ...)
    if log_file then log_file:write(os.date("%H:%M:%S "), line, "\n"); log_file:flush() end
end

local function ok_call(fn, ...)
    local ok, a, b, c, d, e, f = pcall(fn, ...)
    if ok then return a, b, c, d, e, f end
    return nil
end

local function name_of(o)
    return ok_call(function() return o:GetClass():GetFName():ToString() end) or "?"
end

-- FindAllOf hands back a single object on some builds; ipairs on that errors.
local function each_of(name)
    local ok, list = pcall(FindAllOf, name)
    if not ok or not list then return {} end
    if type(list) == "table" then return list end
    return { list }
end

local function valid(o)
    local ok, v = pcall(function() return o:IsValid() end)
    return ok and v == true
end

-- mod_dir of this script's parent
local function dev_dir()
    local src = debug.getinfo(1, "S").source:gsub("^@", "")
    return (src:gsub("[/\\]Scripts[/\\]ride_watch%.lua$", "") .. "\\dev\\")
end

local state = { frames = 0, t0 = nil, world = nil }

function W.sample(world_name)
    state.frames = state.frames + 1
    if state.frames % 30 ~= 0 then return end
    if state.world ~= world_name then state.world, state.t0, state.frames = world_name, os.time(), 0 end
    local age = os.time() - (state.t0 or os.time())

    local parts = { string.format("t=%ds", age) }

    local pc = FindFirstOf("PlayerController")
    local pawn = pc and pc.Pawn
    if valid(pawn) then
        local l = ok_call(function() return pawn:K2_GetActorLocation() end)
        local att = ok_call(function() return pawn:GetAttachParentActor() end)
        local a = valid(att) and (name_of(att) .. " " .. (ok_call(function() return att:GetFName():ToString() end) or "?")) or "nothing"
        parts[#parts + 1] = string.format("pawn %.0f %.0f %.0f attached=%s", l.X, l.Y, l.Z, a)
    else
        parts[#parts + 1] = "pawn none"
    end

    local cam = pc and pc.PlayerCameraManager
    local cl = cam and ok_call(function() return cam:GetCameraLocation() end)
    if cl then parts[#parts + 1] = string.format("camera %.0f %.0f %.0f", cl.X, cl.Y, cl.Z) end

    -- the remake's Pelicans: where they are, which way they face, how fast
    for _, a in ipairs(each_of("Actor")) do
        if valid(a) then
            local cn = name_of(a)
            -- only the Pelican vehicle actors (not the light fixtures or scenery
            -- that also carry "B30_Pelican" in their names)
            if cn:find("Pelican") and (cn:find("Vehicle") or cn:find("Dropship")) then
                local l = ok_call(function() return a:K2_GetActorLocation() end)
                local r = ok_call(function() return a:K2_GetActorRotation() end)
                local v = ok_call(function() return a:GetVelocity() end)
                local sp = v and math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z) or -1
                parts[#parts + 1] = string.format("P %s (%.0f,%.0f,%.0f) rot %.0f %.0f %.0f spd %.0f",
                    a:GetFName():ToString(), l.X, l.Y, l.Z, r.Pitch, r.Yaw, r.Roll, sp)
            end
        end
    end

    -- marines riding: within 6 m of the first Pelican found
    local pel = nil
    for _, a in ipairs(each_of("Actor")) do
        if valid(a) and name_of(a):find("PelicanVehicle") then pel = a break end
    end
    if pel then
        local pl = ok_call(function() return pel:K2_GetActorLocation() end)
        local near = {}
        for _, a in ipairs(each_of("Actor")) do
            if valid(a) then
                local cn = name_of(a)
                if cn:find("Marine") then
                    local l = ok_call(function() return a:K2_GetActorLocation() end)
                    local d = math.sqrt((l.X - pl.X) ^ 2 + (l.Y - pl.Y) ^ 2 + (l.Z - pl.Z) ^ 2)
                    if d < 600 then
                        local att = ok_call(function() return a:GetAttachParentActor() end)
                        local a2 = valid(att) and name_of(att) or "-"
                        near[#near + 1] = string.format("%s d%.0f att=%s", a:GetFName():ToString():sub(1, 30), d, a2)
                    end
                end
            end
        end
        parts[#parts + 1] = "marines near=" .. #near
        for i = 1, math.min(#near, 4) do parts[#parts + 1] = "  " .. near[i] end
    end

    log(table.concat(parts, " "))
end

local last_world

function W.maybe(world_name)
    local dev = dev_dir()
    if world_name and world_name ~= last_world then
        last_world = world_name
        if not log_file then
            log_file = io.open(dev .. "watch.txt", "w")
        end
        log("world %s", tostring(world_name))
        if log_file then log_file:close(); log_file = nil end
    end
    if not (world_name and (world_name:lower():find("b30") or world_name:lower():find("sc"))) then return end
    if not log_file then
        if not ok_call(function() local f = io.open(dev .. "enabled", "rb"); if f then f:close() return true end return nil end) then
            return
        end
        os.execute('mkdir "' .. dev .. '" 2>nul')
        log_file = io.open(dev .. "watch.txt", "w")
        if log_file then log_file:write("ride watch start\n") end
    end
    local ok, err = pcall(W.sample, world_name)
    if not ok and log_file then log("watch error: %s", tostring(err)) end
end

return W
