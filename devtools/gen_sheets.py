"""Generates mod/OriginalCinematics/Scripts/sheets_gen.lua from the JSON sheets.
The sheets are the source of truth; never edit the generated file by hand."""
import json, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SHEETS = os.path.join(ROOT, "sheets")
OUT = os.path.join(ROOT, "mod", "OriginalCinematics", "Scripts", "sheets_gen.lua")


def lua(v):
    if isinstance(v, str):
        return '"' + v.replace("\\", "\\\\").replace('"', '\\"') + '"'
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(v)
    if isinstance(v, list):
        return "{ " + ", ".join(lua(x) for x in v) + " }"
    if isinstance(v, dict):
        return "{ " + ", ".join("[%s] = %s" % (lua(k), lua(x)) for k, x in v.items()) + " }"
    if v is None:
        return "nil"
    raise TypeError(v)


def rows(name):
    d = json.load(open(os.path.join(SHEETS, name), encoding="utf-8"))
    cols = d["columns"]
    out = []
    for r in d["rows"]:
        if len(r) != len(cols):
            sys.exit("%s: row %r has %d cells, expected %d" % (name, r[:2], len(r), len(cols)))
        out.append(dict(zip(cols, r)))
    return out


def main():
    problems = []
    bones = rows("bone_map.json")
    chars = rows("characters.json")
    scenes = rows("scenes.json")
    fixups = rows("fixups.json")
    video_skips = rows("video_skips.json")
    flights = rows("flights.json")
    for v in flights:
        for k, x in v.items():
            if x in ("", None):
                problems.append("flights: %s.%s unfilled" % (v["id"], k))
        if not os.path.exists(os.path.join(ROOT, "mod", "OriginalCinematics", "Scripts", v["path"] + ".lua")):
            problems.append("flights: %s path %s.lua missing" % (v["id"], v["path"]))
    for v in video_skips:
        for k, x in v.items():
            if x in ("", None):
                problems.append("video_skips: %s.%s unfilled" % (v["id"], k))
    rigs = {c["rig"] for c in chars}
    for b in bones:
        if b["rig"] not in rigs:
            problems.append("bone_map: rig %s has no character" % b["rig"])
        if b["mode"] != "skip" and not b["remake_bone"]:
            problems.append("bone_map: %s has no remake bone" % b["ce_node"])
    for f in fixups:
        if f["rig"] not in rigs:
            problems.append("fixups: rig %s has no character" % f["rig"])
        for k in ("bone", "from", "to", "share"):
            if f[k] in ("", None):
                problems.append("fixups: %s.%s unfilled" % (f["bone"], k))
    char_ids = {c["id"] for c in chars}
    for s in scenes:
        for c in s["characters"]:
            if c not in char_ids:
                problems.append("scenes: %s uses unknown character %s" % (s["id"], c))
    for c in chars:
        for k, v in c.items():
            if v in ("", None) or (isinstance(v, str) and v.startswith("TBD")):
                problems.append("characters: %s.%s unfilled" % (c["id"], k))
    lines = ["-- GENERATED from sheets/*.json by devtools/gen_sheets.py. Do not edit.", "return {"]
    lines.append("  bone_map = " + lua(bones) + ",")
    lines.append("  characters = " + lua(chars) + ",")
    lines.append("  scenes = " + lua(scenes) + ",")
    lines.append("  fixups = " + lua(fixups) + ",")
    lines.append("  video_skips = " + lua(video_skips) + ",")
    lines.append("  flights = " + lua(flights) + ",")
    lines.append("}")
    open(OUT, "w", encoding="utf-8").write("\n".join(lines) + "\n")
    print("wrote", OUT)
    print("preflight:", "clean" if not problems else "")
    for p in problems:
        print("  -", p)


main()
