"""Fits the remake bridge against the original using the chairs as fixed points.
CE chairs (probe-out/survey_ce.tsv) -> naive UE (x*304.8, -y*304.8, z*304.8);
remake chair meshes (survey_remake.tsv, mesh name matching argv[1] regex).
ICP: nearest-neighbour pairs, then a 2D similarity (scale, yaw, shift) + z shift."""
import sys, re, math, os
pat = re.compile(sys.argv[1] if len(sys.argv) > 1 else r"chair|seat|pod", re.I)
WU = 304.8
ce = []
for l in open("probe-out/survey_ce.tsv", encoding="utf-8"):
    p = l.rstrip("\n").split("\t")
    if p[0] == "CE" and "chairs" in p[3] and not p[2].startswith(("x10_chair", "pilot_chair")):
        ce.append((p[2], float(p[4]) * WU, -float(p[5]) * WU, float(p[6]) * WU))
ue = []
for l in open(os.path.expandvars(r"%LOCALAPPDATA%\OriginalCinematics\survey_remake.tsv"), encoding="utf-8", errors="replace"):
    p = l.rstrip("\n").split("\t")
    if p[0] == "UE" and pat.search(p[2] + " " + p[3]):
        ue.append((p[2], float(p[4]), float(p[5]), float(p[6])))
# one point per object: merge parts within 60 cm
merged = []
for u in ue:
    for m in merged:
        if math.dist(u[1:3], m[1:3]) < 60: break
    else: merged.append(u)
print(f"CE chairs {len(ce)}, remake candidates {len(ue)} -> {len(merged)} objects")
s, th, tx, ty, tz = 1.0, 0.0, 0.0, 0.0, 0.0
def T(x, y, z):
    c, n = math.cos(th), math.sin(th)
    return s * (c * x - n * y) + tx, s * (n * x + c * y) + ty, z + tz
for it in range(30):
    pairs = []
    for c in ce:
        q = T(*c[1:])
        m = min(merged, key=lambda u: math.dist(q[:2], u[1:3]))
        pairs.append((c, m))
    # similarity fit (Umeyama 2D)
    n = len(pairs)
    ax = sum(c[1] for c, m in pairs) / n; ay = sum(c[2] for c, m in pairs) / n
    bx = sum(m[1] for c, m in pairs) / n; by = sum(m[2] for c, m in pairs) / n
    sxx = sum((c[1]-ax)*(m[1]-bx) + (c[2]-ay)*(m[2]-by) for c, m in pairs)
    sxy = sum((c[1]-ax)*(m[2]-by) - (c[2]-ay)*(m[1]-bx) for c, m in pairs)
    va = sum((c[1]-ax)**2 + (c[2]-ay)**2 for c, m in pairs)
    th = math.atan2(sxy, sxx); s = math.hypot(sxx, sxy) / va
    c_, n_ = math.cos(th), math.sin(th)
    tx = bx - s * (c_ * ax - n_ * ay); ty = by - s * (n_ * ax + c_ * ay)
    tz = sum(m[3] - c[3] for c, m in pairs) / n
print(f"fit: scale {s:.4f}  yaw {math.degrees(th):.2f} deg  shift ({tx:.1f}, {ty:.1f}) cm  z {tz:.1f} cm")
for c, m in pairs:
    q = T(*c[1:])
    print(f"  {c[0]:14s} CE->UE naive ({c[1]:7.0f},{c[2]:7.0f},{c[3]:5.0f})  remake {m[0][:40]:40s} ({m[1]:7.0f},{m[2]:7.0f},{m[3]:5.0f})  residual {math.dist(q[:2], m[1:3]):5.1f} cm, dz {m[3]-c[3]:6.1f}")
