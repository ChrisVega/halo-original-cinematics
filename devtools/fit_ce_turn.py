"""Rotation progress (0..1, by angle from the start facing toward the end facing) of the original's camera during moves."""
import math, sys
cams={l.split("\t")[0]:[float(x) for x in l.split("\t")[1:]] for l in open("probe-out/a10_cameras.tsv")}
T=[list(map(float,l.split("\t")[1:])) for l in open("probe-out/ce_camera_truth.tsv").readlines()[1:]]
def fwd(r):
    a,b,c=r; x,y,z=math.cos(a),math.sin(a),0
    x,z=x*math.cos(b),x*math.sin(b)
    return (x, y*math.cos(c)-z*math.sin(c), y*math.sin(c)+z*math.cos(c))
ang=lambda p,q: math.acos(max(-1,min(1,sum(p[i]*q[i] for i in range(3)))))
for A,B,t0,n in [("keyes_x10_deck_2a","keyes_react_1a",1509,179),("keyes_x10_peer_1a","keyes_peer_2a",2054,121),("keyes_x10_deck_1a","keyes_x10_deck_1b",1309,179)]:
    fa,fb=fwd(cams[A][3:6]),fwd(cams[B][3:6]); W=ang(fa,fb)
    print(A,B,"turn %.1f deg"%math.degrees(W))
    for t in T:
        if t0<=t[0]<=t0+n+10:
            f=t[4:7]; print("  u=%.2f r=%.3f"%((t[0]-t0)/n, ang(fa,f)/W if W>1e-4 else 0))
