"""Pull the original's cutscene camera points out of CE's A10 and write the sheet.

CE's in-engine cutscenes are a mission file full of named camera points plus a
script that walks the camera through them by name with blend times. This reads
the 292 points straight out of the original map and writes them to
sheets/camera_path.json, one row per point, with the columns the cutscene needs.

  python build_camera_points.py
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from ce_tags import CeMap  # noqa: E402

ROOT = os.path.abspath(os.path.join(HERE, ".."))
MAP = r"C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map"
CAMERA_POINTS_OFFSET = 0x4f0
CAMERA_POINT_SIZE = 104

# the cutscene scripts we are restoring, and the camera points they name, read off
# CE's own scripts. Only these points are the cutscene; the rest of the 292 are
# other scenes' cameras (tutorial, hangar, xenon, etc.) and stay out.
BRIDGE = [
    ("keyes_x10_deck_1a", 0), ("keyes_x10_deck_1b", 200),
    ("keyes_x10_deck_2a", 0), ("keyes_react_1a", 180),
    ("keyes_peer_walk_1", 0), ("keyes_x10_peer_walk_1", 200),
    ("keyes_x10_peer_walk_2", 120), ("keyes_x10_peer_walk_3", 200),
    ("keyes_x10_peer_1a", 0), ("keyes_peer_2a", 120),
    ("keyes_peer_2b", 0), ("keyes_x10_peer_1b", 90),
    ("keyes_x10_display_walk_1a", 0), ("keyes_x10_display_walk_1b", 200),
    ("display_rev_1a", 0), ("display_rev_1b", 200),
    ("thats_it_then_1a", 0), ("thats_it_then_1b", 120),
    ("keyes_x10_alert_1a", 0), ("keyes_x10_alert_1b", 180),
    ("keyes_to_cortana_1", 0), ("keyes_to_cortana_2", 0),
    ("keyes_to_cortana_3a", 0), ("keyes_to_cortana_3b", 30),
]

HANGAR = [
    ("hangar_1a", 0), ("hangar_1b", 0), ("hangar_1c", 0),
    ("hangar_2a", 0), ("hangar_2b", 0),
    ("hangar_3a", 0), ("hangar_3b", 0),
]


def main():
    m = CeMap(MAP)
    scnr = m.by_class['scnr'][0]
    points = {}
    for _, p in m.each(scnr['data'] + CAMERA_POINTS_OFFSET, CAMERA_POINT_SIZE):
        name = m.str32(p + 4)
        if not name:
            continue
        points[name] = {
            'x': m.vec3(p + 40), 'y': m.vec3(p + 40), 'z': m.vec3(p + 40),
            'rot': m.vec3(p + 52), 'fov_deg': m.f32(p + 64) * 57.2957795,
        }
    print('camera points in the original map:', len(points))

    rows = []
    missing = []
    for scene, seq in (('bridge', BRIDGE), ('hangar_cryo', HANGAR)):
        for name, blend in seq:
            pt = points.get(name)
            if not pt:
                missing.append(name)
                continue
            pos = m.vec3(int(scnr['data']) + 0)  # placeholder, replaced below
            rows.append({
                'scene': scene,
                'name': name,
                'blend_ms': blend,
                'pos_x': round(m.f32(0) if False else 0, 3),
            })
    # redo cleanly: read position/rotation/fov per point (the loop above only
    # proves the names resolve; this fills the row properly)
    rows = []
    for scene, seq in (('bridge', BRIDGE), ('hangar_cryo', HANGAR)):
        for name, blend in seq:
            for _, p in m.each(scnr['data'] + CAMERA_POINTS_OFFSET, CAMERA_POINT_SIZE):
                if m.str32(p + 4) != name:
                    continue
                px, py, pz = m.vec3(p + 40)
                rx, ry, rz = m.vec3(p + 52)
                rows.append({
                    'scene': scene,
                    'name': name,
                    'blend_ms': blend,
                    'pos_x': round(px, 4), 'pos_y': round(py, 4), 'pos_z': round(pz, 4),
                    'rot_x': round(rx, 4), 'rot_y': round(ry, 4), 'rot_z': round(rz, 4),
                    'fov_deg': round(m.f32(p + 64) * 57.2957795, 2),
                    'source': 'CE a10.map cutscene camera point',
                })
                break

    if missing:
        raise SystemExit('points not found in the original map: %s' % ', '.join(missing))

    sheet = {
        'what': 'one row = one camera point of the original A10 cutscene, with the '
                'blend time the script uses to reach it',
        'source': "the original Halo CE a10.map, straight out of the player's Master Chief Collection",
        'columns': ['scene', 'name', 'blend_ms', 'pos_x', 'pos_y', 'pos_z',
                    'rot_x', 'rot_y', 'rot_z', 'fov_deg', 'source'],
        'rows': rows,
    }
    out = os.path.join(ROOT, 'sheets', 'camera_path.json')
    with open(out, 'w', encoding='utf-8') as f:
        json.dump(sheet, f, indent=2)
    print('wrote', out, len(rows), 'rows')


if __name__ == '__main__':
    main()