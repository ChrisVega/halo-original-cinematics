import os, struct
cache = os.path.join(os.environ["LOCALAPPDATA"], "OriginalCinematics", "cache")
def dur(path):
    with open(path, "rb") as f:
        h = f.read(4096)
    if len(h) < 44:
        return 0
    ch = struct.unpack("<H", h[22:24])[0]
    rate = struct.unpack("<I", h[24:28])[0]
    bits = struct.unpack("<H", h[34:36])[0]
    p = 12
    while p + 8 <= len(h):
        cid, size = h[p:p+4], struct.unpack("<I", h[p+4:p+8])[0]
        if cid == b"data":
            return size / (rate * ch * max(1, bits // 8))
        p += 8 + size
    return 0
names = sorted(os.listdir(cache))
for n in names:
    if n.endswith(".wav") and ("cor" in n or "keyes" in n):
        d = dur(os.path.join(cache, n))
        print(f"{n:45s} {d:7.2f}s")
