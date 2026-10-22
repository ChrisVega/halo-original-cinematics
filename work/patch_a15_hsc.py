"""The same line move as patch_a15_prep.py, but on the extracted .hsc source
(so it can be syntax-checked with mjolnir compile)."""
import sys
sys.path.insert(0, __file__.rsplit('\\', 1)[0])
from patch_a15_prep import reorder

HSC = sys.argv[1] if len(sys.argv) > 1 else 'a15.hsc'
d = bytearray(open(HSC, 'rb').read())
d = reorder(d)
open(HSC, 'wb').write(bytes(d))
print('patched', HSC, len(d), 'bytes')
