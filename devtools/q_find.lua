local out = {}
for _, cls in ipairs({ "BP_KeyesBipedActor_C", "BP_MaleCrewmanBipedActor_C", "BP_FemaleCrewmanBipedActor_C", "BP_SpartansBipedActor_C" }) do
  for _, a in ipairs(FindAllOf(cls) or {}) do
    local l = a:K2_GetActorLocation()
    out[#out+1] = string.format("%s %.0f %.0f %.0f  (blam %.2f %.2f %.2f)", cls, l.X, l.Y, l.Z, l.X/304.8, -l.Y/304.8, l.Z/304.8)
  end
end
local p = FindFirstOf("PlayerController").Pawn
if p and p:IsValid() then local l = p:K2_GetActorLocation(); out[#out+1] = string.format("player %.0f %.0f %.0f", l.X, l.Y, l.Z) end
return table.concat(out, "\n")
