"""Patch the A15 scenario to prevent the opening intro video from playing."""
import sys

BULK = sys.argv[1] if len(sys.argv) > 1 else 'a15-scenario.ubulk'
OUT = sys.argv[2] if len(sys.argv) > 2 else 'a15-scenario-patched.ubulk'

d = bytearray(open(BULK, 'rb').read())

targets = [
    b'(f_play_cinematic cinematics\\a10\\a10_intro_legendary.cinematic)',
    b'(f_play_cinematic cinematics\\a10\\a10_intro_heroic.cinematic)',
    b'(f_play_cinematic cinematics\\a10\\a10_intro_normal.cinematic)',
]

for t in targets:
    spaces = b' ' * len(t)
    count = d.count(t)
    d = d.replace(t, spaces)
    print(f'{t}: found {count}, replaced')

open(OUT, 'wb').write(bytes(d))
print('wrote', OUT, len(d), 'bytes')
