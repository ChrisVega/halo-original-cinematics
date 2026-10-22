-- Development console: runs <mod>\dev\in.lua inside the game (game thread)
-- whenever it appears, writes what it returns or prints to dev\out.txt, then
-- deletes in.lua. Only active when <mod>\dev\enabled exists (never shipped).

local R = {}

-- force: also on during Melty's own test runs (dev folder made on demand),
-- so an unattended test can be looked into while it runs.
function R.start(mod_dir, force)
    local dev = mod_dir .. "dev\\"
    local flag = io.open(dev .. "enabled", "rb")
    if not flag and not force then return end
    if flag then flag:close() end
    if force then os.execute('mkdir "' .. dev .. '" 2>nul') end
    -- On the game thread's own timer: an async loop that never ends kept the
    -- game process alive after it was closed (no window, stuck for good).
    LoopInGameThreadWithDelay(500, function()
        local f = io.open(dev .. "in.lua", "rb")
        if not f then return end
        local src = f:read("a"); f:close()
        os.remove(dev .. "in.lua")
        local out = {}
        local env = setmetatable({
            print = function(...)
                local t = {}
                for i = 1, select("#", ...) do t[#t + 1] = tostring((select(i, ...))) end
                out[#out + 1] = table.concat(t, "\t")
            end,
            MOD_DIR = mod_dir,
        }, { __index = _G })
        local fn, err = load(src, "in.lua", "t", env)
        local ok, res
        if fn then ok, res = pcall(fn) else ok, res = false, err end
        out[#out + 1] = (ok and "=> " or "ERROR ") .. tostring(res)
        local o = io.open(dev .. "out.txt", "wb")
        if o then o:write(table.concat(out, "\n")); o:close() end
    end)
end

return R
