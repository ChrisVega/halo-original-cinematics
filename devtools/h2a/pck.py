"""Offline prototype: read H2A Saber3D pck containers (uncompressed chunked stream)."""
import struct, sys
SHARED = r"C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo2\preload\paks\shared.pck"

class Chunked:
    def __init__(self, path):
        self.f = open(path, "rb")
        n, ctype = struct.unpack("<ii", self.f.read(8))
        assert ctype == 4, ctype
        self.offs = struct.unpack("<%dq" % n, self.f.read(8 * n))
        self.contig = all(self.offs[i] == self.offs[0] + i * 0x8000 for i in range(n))
    def read(self, pos, size):
        if self.contig:
            self.f.seek(self.offs[0] + pos); return self.f.read(size)
        out = b""
        while size > 0:
            ci, co = divmod(pos, 0x8000)
            take = min(size, 0x8000 - co)
            self.f.seek(self.offs[ci] + co); out += self.f.read(take)
            pos += take; size -= take
        return out

def children(s, start):
    p = start + 0x45
    n, _ = struct.unpack("<ii", s.read(p, 8)); p += 9
    hdr = s.read(p, 4 * n + 400 * n)
    names, q = [], 0
    for _ in range(n):
        ln = struct.unpack_from("<i", hdr, q)[0]; q += 4
        names.append(hdr[q:q + ln].decode("latin1")); q += ln
    p += q + 1
    offs = struct.unpack("<%dq" % n, s.read(p, 8 * n)); p += 8 * n + 1
    sizes = struct.unpack("<%di" % n, s.read(p, 4 * n))
    return [(names[i], start + offs[i], sizes[i]) for i in range(n)]

if __name__ == "__main__":
    s = Chunked(SHARED)
    print("contiguous", s.contig, "sig", s.read(0, 8))
    top = children(s, 0)
    print(len(top), "entries")
    for name, off, size in top:
        if "cortana" in name.lower():
            print(name, off, size, s.read(off, 8))
            if size and s.read(off, 8)[1:8] == b"1SERpak":
                for c in children(s, off): print("   ", c, s.read(c[1], 8))
