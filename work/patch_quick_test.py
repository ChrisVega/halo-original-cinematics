"""The quick test: the remake's A15 intro movie is switched off, and the engine is
asked (in its own script) whether it still has a Blam-driven camera.

Because the movie never starts, the mission's own level prep (the doors, the
incident, the bridge) now runs straight away instead of after it, which is the
order CE uses anyway: CE's startup script runs the intro inline and x10 does the
bsp switch and the object predictions before its cutscenes.

Every replacement keeps its byte length, so no offset in the tag moves.

  python patch_quick_test.py <pristine.ubulk> <out.ubulk>
"""
import sys

SRC = sys.argv[1]
OUT = sys.argv[2]

PROBE = b'(camera_set_field_of_view 90 0)'


def replace_keep_length(data, old, new, what):
    if len(old) != len(new):
        raise SystemExit('replacement for %s is not the same length (%d vs %d)'
                         % (what, len(old), len(new)))
    if data.count(old) != 1:
        raise SystemExit('%s: found %d times, expected 1' % (what, data.count(old)))
    return data.replace(old, new, 1)


def main():
    data = bytearray(open(SRC, 'rb').read())
    before = len(data)

    # the movie never starts, on any difficulty. The legendary branch carries the
    # camera probe instead: 90 degrees is unmistakably wider than the 70 the
    # remake draws with, so a wider picture means the engine really did it.
    data = replace_keep_length(
        data, b'(f_play_cinematic cinematics\\a10\\a10_intro_legendary.cinematic)',
        PROBE.ljust(len(b'(f_play_cinematic cinematics\\a10\\a10_intro_legendary.cinematic)'), b' '),
        'legendary movie call')
    data = replace_keep_length(
        data, b'(f_play_cinematic cinematics\\a10\\a10_intro_heroic.cinematic)',
        b';'.ljust(len(b'(f_play_cinematic cinematics\\a10\\a10_intro_heroic.cinematic)'), b' '),
        'heroic movie call')
    data = replace_keep_length(
        data, b'(f_play_cinematic cinematics\\a10\\a10_intro_normal.cinematic)',
        b' '.ljust(len(b'(f_play_cinematic cinematics\\a10\\a10_intro_normal.cinematic)'), b' '),
        'normal movie call')

    if len(data) != before:
        raise SystemExit('length changed: %d -> %d' % (before, len(data)))
    open(OUT, 'wb').write(bytes(data))
    print('wrote', OUT, len(data), 'bytes (same length)')


if __name__ == '__main__':
    main()