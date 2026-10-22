-- Pelican rides disabled (B30 work abandoned; focus is A15 video blocking).
local R = {}
R.__index = R
function R.new(ctx) return setmetatable({ ctx = ctx, active = nil }, R) end
function R:update(world_name) end
return R