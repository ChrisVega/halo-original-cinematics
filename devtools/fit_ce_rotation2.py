"""Finds which composition of world-axis rotations turns an a10 camera point's three angles into the forward vector the
original engine uses (truth: probe-out/ce_camera_truth.tsv, stationary shots)."""
import math, itertools
cams = {l.split("\t")[0]: [float(x) for x in l.split("\t")[1:]] for l in open("probe-out/a10_cameras.tsv")}
truth = [list(map(float, l.split("\t")[2:])) for l in open("probe-out/ce_camera_truth.tsv").readlines()[1:]]
runs = []; i = 0
while i < len(truth):
    j = i
    while j + 1 < len(truth) and truth[j + 1][:9] == truth[i][:9]: j += 1
    if j - i >= 2: runs.append(truth[i])
    i = j + 1
pairs = []
for t in runs:
    n, c = min(cams.items(), key=lambda kv: math.dist(kv[1][:3], t[:3]))
    if math.dist(c[:3], t[:3]) < 0.002: pairs.append((n, c, t))
def R(axis, a):
    c, s = math.cos(a), math.sin(a)
    return {"x": [[1,0,0],[0,c,-s],[0,s,c]], "y": [[c,0,s],[0,1,0],[-s,0,c]], "z": [[c,-s,0],[s,c,0],[0,0,1]]}[axis]
def mul(A, B): return [[sum(A[i][k]*B[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
def mv(A, v): return [sum(A[i][k]*v[k] for k in range(3)) for i in range(3)]
res = []
axes_for = [("z","y","x"), ("z","x","y")]
for ax in axes_for:
  for order in itertools.permutations(range(3)):
    for sg in itertools.product((1,-1), repeat=3):
        err = 0
        for n, c, t in pairs:
            Ms = [R(ax[k], sg[k]*c[3+k]) for k in range(3)]
            M = mul(mul(Ms[order[0]], Ms[order[1]]), Ms[order[2]])
            err += math.dist(mv(M, [1,0,0]), t[3:6])
        res.append((err/len(pairs), ax, order, sg))
res.sort()
for r in res[:5]: print("mean forward err %.5f axes %s order %s signs %s" % r)
