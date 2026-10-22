import struct
from pck import Chunked, children, SHARED
s = Chunked(SHARED)
for name, off, size in children(s, 0):
    if name == "<database>:cortana__h.tpl":
        for c in children(s, off):
            print(c)
            if c[2]:
                data = s.read(c[1], c[2])
                pass
