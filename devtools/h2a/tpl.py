"""Offline prototype: decode an H2A Saber3D template (.tpl) mesh read straight from
the player's MCC shared.pck. Mirrors Wildenhaus/Index (LibH2A) serializers.
Nothing is written out; returns vertices/faces/uvs in memory."""
import struct
from pck import Chunked, children, SHARED

def u8(d, p): return d[p]
def u16(d, p): return struct.unpack_from("<H", d, p)[0]
def i16(d, p): return struct.unpack_from("<h", d, p)[0]
def u32(d, p): return struct.unpack_from("<I", d, p)[0]
def f32(d, p): return struct.unpack_from("<f", d, p)[0]
def bits(d, p, n):
    nb = (n + 7) // 8
    return [(d[p + i // 8] >> (i % 8)) & 1 for i in range(n)], p + nb
def pstr32(d, p):
    n = u32(d, p); return d[p + 4:p + 4 + n].decode("latin1"), p + 4 + n
def pstr16(d, p):
    n = u16(d, p); return d[p + 2:p + 2 + n].decode("latin1"), p + 2 + n


def read_tpl_bytes(name):
    s = Chunked(SHARED)
    for n, off, size in children(s, 0):
        if n == "<database>:" + name:
            for cn, coff, csize in children(s, off):
                if csize and cn.endswith(name):
                    return s.read(coff, csize)
    raise KeyError(name)


def read_objects(d, p):
    count, _, pc, _ = struct.unpack_from("<HHHH", d, p); p += 8
    objs = [dict(id=i) for i in range(count)]
    def prop(i): return pc > i
    def present():
        nonlocal p
        v = d[p]; p += 1; return v != 0
    if prop(0) and present():
        for o in objs: o["id"] = i16(d, p); p += 2
    if prop(1) and present():
        for o in objs: o["readname"], p = pstr32(d, p)
    if prop(2) and present():
        p += 7 * count
    for i, key in ((3, "parent"), (4, "next"), (5, "prev"), (6, "child"), (7, "anim")):
        if prop(i) and present():
            for o in objs: o[key] = i16(d, p); p += 2
    if prop(8) and present():
        for o in objs: o["readaffixes"], p = pstr32(d, p)
    if prop(9) and present():
        for o in objs: o["lt"] = struct.unpack_from("<16f", d, p); p += 64
    if prop(10) and present():
        for o in objs: o["model"] = struct.unpack_from("<16f", d, p); p += 64
    if prop(11) and present():
        fl, p = bits(d, p, count)
        for i, o in enumerate(objs):
            if fl[i]:
                assert u32(d, p) == 3 and d[p + 4] == 7, "geomdata"
                p += 5 + 8 + 24
    if prop(12) and present():
        for o in objs: o["unkname"], p = pstr32(d, p)
    if prop(13) and present():
        p += 60 * count
    if prop(14) and present():
        for o in objs: o["name"], p = pstr16(d, p)
    if prop(15) and present():
        for o in objs: o["affixes"], p = pstr16(d, p)
    return objs, p


def read_graph(d, p):
    assert d[p:p + 4] == b"OGM1"; p += 4
    gtype = u16(d, p); p += 6
    g = {"type": gtype}
    if d[p]:
        p += 1
        g["objects"], p = read_objects(d, p)
    else:
        p += 1
        g["objects"] = []
    assert gtype == 1, gtype
    while True:
        sent = u16(d, p); p += 2
        if sent == 0x0000:
            end = u32(d, p); p += 4
            g["root"] = i16(d, p); g["nodes"], g["nbuf"], g["nmesh"], g["nsub"] = struct.unpack_from("<4I", d, p + 2)
            p = end
        elif sent == 0x0002:
            send = u32(d, p); p += 4
            bufs = [dict() for _ in range(g["nbuf"])]
            while p < send:
                s2 = u16(d, p); e2 = u32(d, p + 2); p += 6
                if s2 == 0:
                    for b in bufs: b["flags"] = struct.unpack_from("<Q", d, p + 2)[0]; p += 10
                elif s2 == 1:
                    for b in bufs: b["esize"] = u16(d, p); p += 2
                elif s2 == 2:
                    for b in bufs: b["len"] = u32(d, p); p += 4
                elif s2 == 3:
                    for b in bufs: b["start"] = p; p += b["len"]
                assert p == e2, ("buf", s2)
            g["buffers"] = bufs
        elif sent == 0x0003:
            send = u32(d, p); p += 4
            meshes = [dict() for _ in range(g["nmesh"])]
            while p < send:
                s2 = u16(d, p); e2 = u32(d, p + 2); p += 6
                if s2 == 0:
                    for m in meshes: m["flags"] = struct.unpack_from("<Q", d, p + 2)[0]; p += 10
                elif s2 == 2:
                    for m in meshes:
                        n = d[p]; p += 1
                        m["bufs"] = [struct.unpack_from("<II", d, p + 8 * k) for k in range(n)]; p += 8 * n
                p = e2
            g["meshes"] = meshes
        elif sent == 0x0004:
            send = u32(d, p); p += 4
            subs = [dict() for _ in range(g["nsub"])]
            while p < send:
                s2 = u16(d, p); e2 = u32(d, p + 2); p += 6
                if s2 == 0 and subs:
                    esz = (e2 - p) // len(subs)
                    for sm in subs:
                        vo, vc, fo, fc, node, skin = struct.unpack_from("<HHHHHh", d, p); p += 12
                        sm.update(vo=vo, vc=vc, fo=fo, fc=fc, node=node, skin=skin)
                        if esz > 12:
                            fl = u32(d, p); p += 4
                            for _ in range(32):
                                if fl & 1: p += 8
                                fl = ((fl << 1) | (fl >> 31)) & 0xFFFFFFFF
                elif s2 == 1:
                    for sm in subs: sm["mesh"] = u32(d, p); p += 4
                elif s2 == 3:
                    for sm in subs:
                        if g["meshes"][sm["mesh"]]["flags"] & (1 << 9):
                            n = d[p]; p += 1
                            sm["bones"] = struct.unpack_from("<%dh" % n, d, p); p += 2 * n
                elif s2 == 4:
                    for sm in subs:
                        if g["meshes"][sm["mesh"]]["flags"] & (1 << 30):
                            n = d[p]; p += 1
                            sm["uvscale"] = {}
                            for _ in range(n):
                                sm["uvscale"][d[p]] = i16(d, p + 1); p += 3
                elif s2 == 5:
                    for sm in subs:
                        if g["meshes"][sm["mesh"]]["flags"] & (1 << 3):
                            sm["pos"] = struct.unpack_from("<3h", d, p); sm["scale"] = struct.unpack_from("<3h", d, p + 6); p += 12
                elif s2 in (6, 7, 8):
                    # materials: keep the raw bytes, texture names are found by scanning
                    sm_raw = d[p:e2]
                    g["materials_raw"] = sm_raw
                p = e2
            g["subs"] = subs
        elif sent == 0xFFFF:
            break
        else:
            raise ValueError("sentinel %x at %d" % (sent, p))
    return g


def snorm16(v): return v / 32767.0


def decode_vertices(d, b, start, count):
    fl, es = b["flags"], b["esize"]
    out = []
    for i in range(count):
        q = b["start"] + (start + i) * es
        if fl & (1 << 3):
            x, y, z = (snorm16(v) for v in struct.unpack_from("<3h", d, q))
        else:
            x, y, z = struct.unpack_from("<3f", d, q)
        out.append((x, y, z))
    return out


def decode_uvs(d, b, start, count):
    fl, es = b["flags"], b["esize"]
    out = []
    for i in range(count):
        q = b["start"] + (start + i) * es
        for t in range(5):
            if fl & (1 << (0x0C + t)): q += 4
        for k in (0x16, 0x17, 0x18):
            if fl & (1 << k): q += 4
        if fl & (1 << 0x19):
            if fl & (1 << 0x1E):
                u, v = struct.unpack_from("<2h", d, q); out.append((snorm16(u), 1 - snorm16(v)))
            else:
                u, v = struct.unpack_from("<2f", d, q); out.append((u, 1 - v))
        else:
            out.append((0, 0))
    return out


def build(d, g):
    parts = []
    for si, sm in enumerate(g["subs"]):
        mesh = g["meshes"][sm["mesh"]]
        verts, uvs, faces = None, None, []
        for bid, sub_off in mesh["bufs"]:
            b = g["buffers"][bid]
            fl = b["flags"]
            if fl & 1:
                start = sm["vo"] + sub_off // b["esize"]
                verts = decode_vertices(d, b, start, sm["vc"])
                if "scale" in sm:
                    sx, sy, sz = sm["scale"]; px, py, pz = sm["pos"]
                    verts = [(x * sx + px, y * sy + py, z * sz + pz) for x, y, z in verts]
            elif fl == 0:
                start = sm["fo"] + sub_off // b["esize"]
                for k in range(sm["fc"]):
                    q = b["start"] + (start + k) * b["esize"]
                    faces.append(tuple(v - sm["vo"] for v in struct.unpack_from("<3H", d, q)))
            elif fl & ((0x1F << 0x0C) | (0x1F << 0x19)):
                start = sm["vo"] + sub_off // b["esize"]
                uvs = decode_uvs(d, b, start, sm["vc"])
                sc = sm.get("uvscale", {}).get(0)
                if sc: uvs = [(u * sc, v * sc) for u, v in uvs]
        parts.append(dict(node=sm["node"], verts=verts or [], uvs=uvs, faces=faces, skin=sm["skin"]))
    return parts


if __name__ == "__main__":
    import re
    d = read_tpl_bytes("cortana__h.tpl")
    p = d.find(b"OGM1")
    g = read_graph(d, p)
    objs = g["objects"]
    print("objects", len(objs), "buffers", len(g["buffers"]), "meshes", len(g["meshes"]), "subs", len(g["subs"]))
    for b in g["buffers"]: print("  buf flags=%x esize=%d len=%d" % (b["flags"], b["esize"], b["len"]))
    parts = build(d, g)
    for i, pt in enumerate(parts):
        o = objs[pt["node"]] if pt["node"] < len(objs) else {}
        vs = pt["verts"]
        lo = [min(v[k] for v in vs) for k in range(3)] if vs else None
        hi = [max(v[k] for v in vs) for k in range(3)] if vs else None
        print(i, o.get("unkname") or o.get("name"), len(vs), len(pt["faces"]), "uv" if pt["uvs"] else "-", "skin", pt["skin"], lo, hi)
    print(sorted(set(re.findall(rb"[a-z0-9_]{4,}", g.get("materials_raw", b"")))) [:60])
