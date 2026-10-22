"""One-off edit for 0.2.0: Cortana from the player's Halo 2 Anniversary files."""
import json
from pathlib import Path
ROOT = Path(__file__).resolve().parent.parent
S = ROOT / "mod" / "OriginalCinematics" / "Scripts"


def edit(name, pairs):
    p = S / name
    s = p.read_text(encoding="utf-8")
    for a, b in pairs:
        assert s.count(a) == 1, (name, a[:70])
        s = s.replace(a, b)
    p.write_text(s, encoding="utf-8")


# sheet ------------------------------------------------------------------------
p = ROOT / "sheets" / "characters.json"
d = json.loads(p.read_text(encoding="utf-8"))
d["about"] += (" fallback 'h2a': drawn from the player's Halo 2 Anniversary files in their MCC "
               "(halo2\\preload\\paks\\shared.pck) and posed by the original's animations for ce_tag; h2a: tpl = template, "
               "parts = submeshes drawn (1-based; the mouth pieces are left out), material = translucent unlit material "
               "with texture_param/tint_param, tint = RGBA, fallback_material + tint when that material is missing, "
               "scale = size drawn at (1 = life size, as the original shows her).")
cols = d["columns"]
if "h2a" not in cols:
    cols.append("h2a")
    for r in d["rows"]:
        if r[0] == "cortana":
            r[cols.index("fallback")] = "h2a"
            r[cols.index("voice_prefix")] = "cor"
            r[cols.index("jaw")] = {"max_deg": 12, "full_rms": 0.18}
            r.append({"tpl": "cortana__h.tpl", "parts": [3, 4, 5, 6, 8, 9],
                      "material": "/Engine/EngineMaterials/Widget3DPassThrough_Translucent.Widget3DPassThrough_Translucent",
                      "texture_param": "SlateUI", "tint_param": "TintColorAndOpacity", "tint": [0.62, 0.45, 1.0, 0.85],
                      "fallback_material": "/Engine/BasicShapes/BasicShapeMaterial.BasicShapeMaterial",
                      "scale": 1.0})
        else:
            r.append({})
p.write_text(json.dumps(d, indent=2), encoding="utf-8")

# main: MCC + cache into the director; textures made at setup ----------------
edit("main.lua", [
    ('''local director = require("director").new({
    log = log, sheets = sheets, characters = characters, report = report,
    load_scene = load_scene,
})''', '''local director = require("director").new({
    log = log, sheets = sheets, characters = characters, report = report,
    load_scene = load_scene, mcc = MCC, cache = DATA .. "\\\\cache",
})

-- Textures of characters drawn from the player's Halo 2 Anniversary files:
-- each picture becomes a .dds and then, with the bundled ffmpeg, a .png in
-- the mod's cache, which the remake loads at the scene.
local function prepare_h2a()
    local H = require("h2a")
    for _, row in ipairs(sheets.characters) do
        local h2 = row.h2a
        if h2 and h2.tpl then
            local pck = MCC .. "\\\\halo2\\\\preload\\\\paks\\\\shared.pck"
            local h, err = H.open(pck)
            if not h then log("h2a: %s", tostring(err)); return end
            local tpl = h:template(h2.tpl, function(sm, i) return false end)
            local names = {}
            for _, sm in ipairs(tpl and tpl.subs or {}) do
                if sm.mat and sm.mat.texture ~= "" then names[sm.mat.texture] = true end
            end
            for tex in pairs(names) do
                local png = DATA .. "\\\\cache\\\\h2a_" .. tex .. ".png"
                if not exists(png) then
                    local pic = h:picture(tex .. ".pct")
                    local dds = pic and H.dds(pic)
                    if dds then
                        local tmp = DATA .. "\\\\cache\\\\h2a_" .. tex .. ".dds"
                        local f = io.open(tmp, "wb"); f:write(dds); f:close()
                        os.execute('cmd /c ""' .. DIR .. 'tools\\\\ffmpeg\\\\ffmpeg.exe" -hide_banner -loglevel error -y -i "'
                            .. tmp .. '" "' .. png .. '""')
                        os.remove(tmp)
                    end
                end
                log("h2a texture %s: %s", tex, exists(png) and "ready" or "missing")
            end
            h:close()
        end
    end
end'''),
    ('''        if ok then
            ready = true; report("ready", "yes")''', '''        if ok then
            local hok, herr = pcall(prepare_h2a)
            if not hok then log("h2a setup failed: %s", tostring(herr)) end
            ready = true; report("ready", "yes")'''),
])

edit("director.lua", [
    ('''camera = { source_aspect = row.source_aspect, target_aspect = row.target_aspect, framing = row.framing } })''',
     '''camera = { source_aspect = row.source_aspect, target_aspect = row.target_aspect, framing = row.framing },
        mcc = self.ctx.mcc, cache = self.ctx.cache })'''),
])

# stage ------------------------------------------------------------------------
edit("ue_stage.lua", [
    ('''function Stage:create(ev)''', '''-- A holographic material for an H2A texture: the sheet's translucent unlit
-- material with the picture and tint; its fallback tinted when it is missing.
function Stage:_holo_material(h2, tex)
    self.holo_mats = self.holo_mats or {}
    if self.holo_mats[tex] ~= nil then return self.holo_mats[tex] or nil end
    local mlib = StaticFindObject("/Script/Engine.Default__KismetMaterialLibrary")
    local rlib = StaticFindObject("/Script/Engine.Default__KismetRenderingLibrary")
    local tint = h2.tint or { 0.6, 0.45, 1, 0.85 }
    local col = { R = tint[1], G = tint[2], B = tint[3], A = tint[4] or 1 }
    local made, how = nil, "none"
    pcall(function()
        local base = LoadAsset(h2.material)
        if not (base and base:IsValid()) then return end
        local png = (self.ctx.cache or "") .. "\\\\h2a_" .. tex .. ".png"
        local t = rlib:ImportFileAsTexture2D(self.pc, png)
        if not (t and t:IsValid()) then return end
        local dyn = mlib:CreateDynamicMaterialInstance(self.pc, base, FName("None"), 0)
        dyn:SetTextureParameterValue(FName(h2.texture_param), t)
        dyn:SetVectorParameterValue(FName(h2.tint_param), col)
        made, how = dyn, "hologram"
    end)
    if not made then
        pcall(function()
            local base = LoadAsset(h2.fallback_material)
            local dyn = mlib:CreateDynamicMaterialInstance(self.pc, base, FName("None"), 0)
            dyn:SetVectorParameterValue(FName("Color"), col)
            made, how = dyn, "tinted"
        end)
    end
    self.log("h2a material for %s: %s", tex, how)
    self.holo_mats[tex] = made or false
    return made
end

-- Cortana (or anyone with an h2a row) from the player's Halo 2 Anniversary
-- files, posed by the original's animations (cortana_h2a.lua).
function Stage:_h2a(row, name)
    local H = require("h2a")
    local CH = require("cortana_h2a")
    local h2 = row.h2a
    local h = assert(H.open(self.ctx.mcc .. "\\\\halo2\\\\preload\\\\paks\\\\shared.pck"))
    local keep = {}
    for _, i in ipairs(h2.parts or {}) do keep[i] = true end
    local tpl, err = h:template(h2.tpl, function(sm, i) return keep[i] end)
    h:close()
    assert(tpl, err)
    local scene = self.ctx.scene
    local g = scene:graph(row.ce_tag)
    local mt = scene.map.by_path[row.ce_tag .. ".mod2"]
    local model = mt and CM.read(scene.map, mt)
    assert(g and model, "no CE graph/model for " .. row.ce_tag)
    local sk = CH.new(tpl, g.nodes, model.nodes, function(m) self.log("%s", m) end)
    local actor = self:spawn("/Script/Engine.Actor")
    local pm = self:add(actor, "/Script/ProceduralMeshComponent.ProceduralMeshComponent")
    local R, P = sk:solve(nil, 0)
    local vs = sk:skin(R, P, h2.scale)
    for si, part in ipairs(sk.parts) do
        local tris, uvs = {}, {}
        for _, t in ipairs(part.tris) do
            -- mirrored into Unreal's frame: reverse the winding; and both
            -- sides, the hologram is see-through
            tris[#tris + 1] = t[1] - 1; tris[#tris + 1] = t[3] - 1; tris[#tris + 1] = t[2] - 1
            tris[#tris + 1] = t[1] - 1; tris[#tris + 1] = t[2] - 1; tris[#tris + 1] = t[3] - 1
        end
        for i = 1, #part.verts do local uv = part.uvs[i] or { 0, 0 }; uvs[i] = { X = uv[1], Y = uv[2] } end
        pm:CreateMeshSection_LinearColor(si - 1, vs[si], tris, {}, uvs, {}, {}, {}, {}, {}, false, false)
        local mat = self:_holo_material(h2, part.mat.texture)
        if mat then pcall(function() pm:SetMaterial(si - 1, mat) end) end
    end
    self.log("h2a %s for %s: %d parts", h2.tpl, name, #sk.parts)
    return { kind = "h2a", actor = actor, pm = pm, sk = sk, scale = h2.scale }
end

-- Loudness-driven mouth opening (0..1) of whoever is speaking on rep.
local function talk_amp(rep)
    local amp = 0
    local t = rep.talk
    if t then
        local i = math.floor((os.clock() - t.t0) * 30) + 1
        local v = t.env[i]
        if v then amp = math.min(1, math.max(0, (v - 0.01) / t.full)) else rep.talk = nil end
    end
    rep.jaw_amp = (rep.jaw_amp or 0) + (amp - (rep.jaw_amp or 0)) * 0.5
    return rep.jaw_amp
end

-- Pose an h2a character for this tick (at most every other frame).
function Stage:_pose_h2a(rep, o, tl)
    self.frame_no = self.frame_no or 0
    local anim, frame = tl:pose_of(o)
    local amp = talk_amp(rep)
    local key = tostring(anim) .. ":" .. tostring(frame) .. ":" .. math.floor(amp * 8)
    if key == rep.posekey or self.frame_no - (rep.posed_at or -9) < 2 then return end
    rep.posekey, rep.posed_at = key, self.frame_no
    local frames = anim and self.ctx.scene:frames(anim)
    local f = frames and frames[frame]
    local jaw = math.rad(((rep.row and rep.row.jaw) or {}).max_deg or 12) * amp
    local t0 = os.clock()
    local R, P = rep.sk:solve(f, jaw)
    local vs = rep.sk:skin(R, P, rep.scale)
    for si = 1, #vs do
        rep.pm:UpdateMeshSection_LinearColor(si - 1, vs[si], {}, {}, {}, {}, {}, {}, {}, false)
    end
    rep.pose_count = (rep.pose_count or 0) + 1
    if rep.pose_count == 1 or rep.pose_count == 30 then
        self.log("h2a pose %d took %.1f ms (anim %s)", rep.pose_count, (os.clock() - t0) * 1000, anim and anim.name or "-")
    end
end

function Stage:create(ev)'''),
    ('''        if row.fallback == "ce_model" then return self:_ce_model(row, ev.name) end''',
     '''        if row.fallback == "h2a" and row.h2a and row.h2a.tpl then
            local hok, hrep = pcall(self._h2a, self, row, ev.name)
            if hok then return hrep end
            self.log("h2a %s failed, using the original model: %s", ev.name, tostring(hrep))
            return self:_ce_model(row, ev.name)
        end
        if row.fallback == "ce_model" then return self:_ce_model(row, ev.name) end'''),
    ('''            -- Keep his soles on the remake's floor wherever he is along the''',
     '''            if rep.kind == "h2a" then
                local hok, herr = pcall(self._pose_h2a, self, rep, o, tl)
                if not hok and not rep.pose_err then rep.pose_err = true; self.log("h2a pose failed: %s", tostring(herr)) end
            end
            -- Keep his soles on the remake's floor wherever he is along the'''),
    ('''function Stage:update_objects(tl)
''', '''function Stage:update_objects(tl)
    self.frame_no = (self.frame_no or 0) + 1
'''),
])
print("patched")
