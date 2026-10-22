"""One-off edit for 0.2.3: the bridge crew (remake Navy crew bodies + faces, posed
by the original crewman animations), part_leader/variants columns, hide list."""
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


p = ROOT / "sheets" / "characters.json"
d = json.loads(p.read_text(encoding="utf-8"))
cols = d["columns"]
if "part_leader" not in cols:
    d["about"] += (" part_leader: 1-based mesh whose pose each part follows (0 = posed itself / none): parts on the body's"
                   " skeleton follow the body, hair and brows follow the face. variants: [[face, hair], ...] swapped in for"
                   " meshes 2 and 3, picked per object by its name, so a crowd has different faces.")
    cols += ["part_leader", "variants"]
    for r in d["rows"]:
        if r[0] == "keyes":
            r += [[0, 0, 2, 2], []]
        else:
            r += [[], []]
    mh = "/Game/MetaHumans/"
    crew = {c: None for c in cols}
    crew.update({
        "id": "crewman", "ce_tag": "characters\\crewman\\crewman", "rig": "captain",
        "remake_meshes": [
            "/Game/characters/NavyCrew/Default/Mesh/SK_NavyCrew_Body_Default.SK_NavyCrew_Body_Default",
            mh + "Marine_Male_Game_Mesh_Head_01/Face/SK_Marine_Male_01_Head_Gameplay.SK_Marine_Male_01_Head_Gameplay",
            mh + "Marine_Male_Game_Mesh_Head_01/MaleHair/Mesh/SK_Marine_Male_01_HairStyle_01_Gameplay.SK_Marine_Male_01_HairStyle_01_Gameplay",
            "/Game/characters/NavyCrew/Default/Mesh/SK_NavyCrew_Anatomy_Default.SK_NavyCrew_Anatomy_Default",
            "/Game/characters/NavyCrew/Default/Mesh/SK_NavyCrew_SleevesDown_Default.SK_NavyCrew_SleevesDown_Default"],
        "attach_bone": "leader", "fallback": "remake", "material": "remake",
        "part_parent": [0, 1, 2, 1, 1], "part_yaw": [0, -90, 0, 0, 0],
        "follow_bones": [["Root_M", "pelvis"], ["Spine1_M", "spine_03"], ["Chest_M", "spine_05"], ["Neck_M", "neck_01"], ["Head_M", "head"]],
        "align_bones": ["head", "Head_M"], "voice_prefix": "-", "jaw": {}, "tint": [], "h2a": {},
        "part_leader": [0, 0, 2, 1, 1],
        "variants": [
            [mh + "Marine_Male_Game_Mesh_Head_01/Face/SK_Marine_Male_01_Head_Gameplay.SK_Marine_Male_01_Head_Gameplay",
             mh + "Marine_Male_Game_Mesh_Head_01/MaleHair/Mesh/SK_Marine_Male_01_HairStyle_01_Gameplay.SK_Marine_Male_01_HairStyle_01_Gameplay"],
            [mh + "Marine_Male_Game_Mesh_Head_02/Face/SK_Marine_Male_02_Head_Gameplay.SK_Marine_Male_02_Head_Gameplay",
             mh + "Marine_Male_Game_Mesh_Head_02/Hair/Mesh/SK_Marine_Male_02_HairStyle_01_Gameplay.SK_Marine_Male_02_HairStyle_01_Gameplay"],
            [mh + "Marine_Male_Game_Mesh_Head_03/Face/SK_Marine_Male_03_Head_Gameplay.SK_Marine_Male_03_Head_Gameplay",
             mh + "Marine_Male_Game_Mesh_Head_03/Hair/Mesh/SK_Marine_Male_03_HairStyle_02_Gameplay.SK_Marine_Male_03_HairStyle_02_Gameplay"],
            [mh + "Marine_Male_Game_Mesh_Head_02/Face/SK_Marine_Male_02_Head_Gameplay.SK_Marine_Male_02_Head_Gameplay",
             mh + "Marine_Male_Game_Mesh_Head_02/Hair/Mesh/SK_Marine_Male_02_HairStyle_03_Gameplay.SK_Marine_Male_02_HairStyle_03_Gameplay"],
            [mh + "Marine_Male_Game_Mesh_Head_01/Face/SK_Marine_Male_01_Head_Gameplay.SK_Marine_Male_01_Head_Gameplay",
             mh + "Marine_Male_Game_Mesh_Head_01/MaleHair/Mesh/SK_Marine_Male_01_HairStyle_03_Gameplay.SK_Marine_Male_01_HairStyle_03_Gameplay"],
        ],
    })
    d["rows"].append([crew[c] for c in cols])
p.write_text(json.dumps(d, indent=2), encoding="utf-8")

p = ROOT / "sheets" / "scenes.json"
d = json.loads(p.read_text(encoding="utf-8"))
if "hide" not in d["columns"]:
    d["about"] += " hide: remake actor classes hidden while the original plays (ours stand in for them)."
    d["columns"].append("hide")
    d["rows"][0][d["columns"].index("characters")].append("crewman")
    d["rows"][0].append(["BP_KeyesBipedActor_C", "BP_MaleCrewmanBipedActor_C", "BP_FemaleCrewmanBipedActor_C"])
p.write_text(json.dumps(d, indent=2), encoding="utf-8")

edit("director.lua", [
    ("        mcc = self.ctx.mcc, cache = self.ctx.cache })",
     "        mcc = self.ctx.mcc, cache = self.ctx.cache, hide = row.hide })"),
])

edit("ue_stage.lua", [
    ('''    local actor = self:spawn("/Script/Engine.Actor")
    local comps = {}
    for i, path in ipairs(row.remake_meshes) do''',
     '''    local actor = self:spawn("/Script/Engine.Actor")
    local comps = {}
    local meshes = {}
    for i, path in ipairs(row.remake_meshes) do meshes[i] = path end
    -- a crowd: a different face and hair per object, picked by its name
    if row.variants and #row.variants > 0 then
        local h = 0
        for k = 1, #name do h = (h * 31 + name:byte(k)) % 1000003 end
        local v = row.variants[h % #row.variants + 1]
        meshes[2], meshes[3] = v[1], v[2]
    end
    for i, path in ipairs(meshes) do'''),
    ('''    -- Hair and brows use the face's skeleton: follow its pose.
    for i = 2, #comps do
        local p = parents[i] or 1
        if comps[i] and p > 1 and comps[p] then
            pcall(function() comps[i]:SetLeaderPoseComponent(comps[p], true, false) end)
        end
    end''',
     '''    -- Parts on another part's skeleton follow its pose (hair and brows the
    -- face's; hands and sleeves the body's).
    local leaders = row.part_leader
    for i = 2, #comps do
        local p = (leaders and #leaders > 0) and (leaders[i] or 0) or ((parents[i] or 1) > 1 and parents[i] or 0)
        if comps[i] and p > 0 and comps[p] then
            pcall(function() comps[i]:SetLeaderPoseComponent(comps[p], true, false) end)
        end
    end'''),
    ('''    local ok, list = pcall(FindAllOf, "BP_KeyesBipedActor_C")
    if not ok or not list then return end
    if type(list) ~= "table" then list = { list } end
    for _, a in ipairs(list) do''',
     '''    local list = {}
    for _, cn in ipairs(self.ctx.hide or { "BP_KeyesBipedActor_C" }) do
        local ok, found = pcall(FindAllOf, cn)
        if ok and found then
            if type(found) ~= "table" then found = { found } end
            for _, a in ipairs(found) do list[#list + 1] = a end
        end
    end
    for _, a in ipairs(list) do'''),
])
print("patched")
