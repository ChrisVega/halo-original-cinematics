"""Matches a10 camera points to the original engine's recorded camera (probe-out/ce_camera_truth.tsv) and finds how
the point's three angles turn into the camera's forward/up vectors."""
import math, itertools
cams = {}
for l in open("probe-out/a10_cameras.tsv"):
    p = l.split("\t"); cams[p[0]] = [float(x) for x in p[1:]]
truth = [list(map(float, l.split("\t")[2:])) for l in open("probe-out/ce_camera_truth.tsv").readlines()[1:]]
pairs = []
for n, c in cams.items():
    for t in truth:
        if math.dist(c[:3], t[:3]) < 0.002:
            pairs.append((n, c, t)); break
print("matched points", len(pairs))
def rot(a, b, c, order, signs):
    y, p, r = [s * v for s, v in zip(signs, (a, b, c))]
    # forward from yaw/pitch, up rolled about forward
    cy, sy, cp, sp = math.cos(y), math.sin(y), math.cos(p), math.sin(p)
    f = (cp * cy, cp * sy, sp)
    u0 = (-sp * cy, -sp * sy, cp)
    l0 = (-sy, cy, 0)
    u = tuple(math.cos(r) * u0[i] + math.sin(r) * l0[i] for i in range(3))
    return f, u
best = []
for signs in itertools.product((1, -1), repeat=3):
    for perm in itertools.permutations(range(3)):
        err = 0
        for n, c, t in pairs:
            a = [c[3 + i] for i in perm]
            f, u = rot(*a, None, signs)
            err += math.dist(f, t[3:6]) + math.dist(u, t[6:9])
        best.append((err / max(1, len(pairs)), perm, signs))
best.sort()
for b in best[:4]: print("err %.4f perm %s signs %s" % b)
e, perm, signs = best[0]
for n, c, t in pairs[:8]:
    f, u = rot(*[c[3 + i] for i in perm], None, signs)
    print(n, "pitch map %.1f truth %.1f | roll map %.1f" % (math.degrees(c[4]), math.degrees(math.asin(t[5])), math.degrees(c[5])),
          "f err %.3f u err %.3f" % (math.dist(f, t[3:6]), math.dist(u, t[6:9])))
