"""One-off edit for 0.1.6: test-mode console + state log, solid two-sided Cortana."""
from pathlib import Path
S = Path(__file__).resolve().parent.parent / "mod" / "OriginalCinematics" / "Scripts"


def edit(name, pairs):
    p = S / name
    s = p.read_text(encoding="utf-8")
    for a, b in pairs:
        assert s.count(a) == 1, (name, a[:60])
        s = s.replace(a, b)
    p.write_text(s, encoding="utf-8")


edit("repl.lua", [
    ("function R.start(mod_dir)\n    local dev = mod_dir .. \"dev\\\\\"\n    local flag = io.open(dev .. \"enabled\", \"rb\")\n    if not flag then return end\n    flag:close()",
     "-- force: also on during Melty's own test runs (dev folder made on demand),\n-- so an unattended test can be looked into while it runs.\nfunction R.start(mod_dir, force)\n    local dev = mod_dir .. \"dev\\\\\"\n    local flag = io.open(dev .. \"enabled\", \"rb\")\n    if not flag and not force then return end\n    if flag then flag:close() end\n    if force then os.execute('mkdir \"' .. dev .. '\" 2>nul') end"),
])

edit("main.lua", [
    ('require("repl").start(DIR)', 'require("repl").start(DIR, TEST ~= nil)'),
    ("""            local w = FindFirstOf("World")
            local front = w and w:IsValid() and w:GetFullName():find("Frontend")""",
     """            local w = FindFirstOf("World")
            local wn = "none"
            pcall(function() wn = w:GetFullName() end)
            if wn ~= last_world or os.time() - (last_state or 0) >= 15 then
                last_world, last_state = wn, os.time()
                log("test mode: world %s", wn)
            end
            local front = w and w:IsValid() and w:GetFullName():find("Frontend")"""),
    ("    local handle, front_since, last_try, tries = nil, nil, 0, 0",
     "    local handle, front_since, last_try, tries = nil, nil, 0, 0\n    local last_world, last_state"),
])

edit("ue_stage.lua", [
    ("""    local mat = row.material ~= "-" and LoadAsset(row.material) or nil""",
     """    local mat = row.material ~= "-" and LoadAsset(row.material) or nil
    -- A tinted instance when the sheet gives a colour (BasicShapeMaterial's
    -- "Color"): the glyph hologram only drew its pattern, so she looked see-through.
    if mat and mat:IsValid() and row.tint and #row.tint == 3 then
        pcall(function()
            local mlib = StaticFindObject("/Script/Engine.Default__KismetMaterialLibrary")
            local dyn = mlib:CreateDynamicMaterialInstance(self.pc, mat, FName("None"), 0)
            if dyn and dyn:IsValid() then
                dyn:SetVectorParameterValue(FName("Color"), { R = row.tint[1], G = row.tint[2], B = row.tint[3], A = 1 })
                mat = dyn
            end
        end)
    end"""),
    ("""        for _, t in ipairs(part.tris) do
            -- mirrored geometry: reverse the winding
            tris[#tris + 1] = t[1]; tris[#tris + 1] = t[3]; tris[#tris + 1] = t[2]
        end""",
     """        for _, t in ipairs(part.tris) do
            -- mirrored geometry: reverse the winding; and draw the back faces
            -- too (the strips' winding is not consistent, which left holes)
            tris[#tris + 1] = t[1]; tris[#tris + 1] = t[3]; tris[#tris + 1] = t[2]
            tris[#tris + 1] = t[1]; tris[#tris + 1] = t[2]; tris[#tris + 1] = t[3]
        end"""),
])
print("patched")
