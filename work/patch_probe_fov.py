"""Movie off AND the camera probe running, from the game's true source.

The probe rides on the normal-difficulty movie call, which is the branch that
actually runs on a normal playthrough, so the call executes for real. The other
two difficulty branches (legendary, heroic) keep the movie switched off as well,
so the video is off whichever difficulty the game is set to.

`(camera_set_field_of_view 90 0)`: 90 degrees is unmistakably wider than the 70
the remake draws with, so a wider view when the mission opens means the engine
really ran the call (the classic camera machinery is alive); an unchanged
70-degree view means it did not.

Every replacement keeps its byte length, so no offset in the tag moves.

  python patch_probe_fov.py <pristine.ubulk> <out.ubulk>
"""
import sys

SRC, OUT = sys.argv[1], sys.argv[2]

PROBE = b'(camera_set_field_of_view 90 0)'

CALLS = {
    'legendary': b'(f_play_cinematic cinematics\\a10\\a10_intro_legendary.cinematic)',
    'heroic': b'(f_play_cinematic cinematics\\a10\\a10_intro_heroic.cinematic)',
    'normal': b'(f_play_cinematic cinematics\\a10\\a10_intro_normal.cinematic)',
}


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

    # legendary and heroic: switch the movie off (comment the call, pad to length)
    data = replace_keep_length(data, CALLS['legendary'],
                               b';'.ljust(len(CALLS['legendary']), b' '), 'legendary movie call')
    data = replace_keep_length(data, CALLS['heroic'],
                               b';'.ljust(len(CALLS['heroic']), b' '), 'heroic movie call')

    # normal: this is the branch that runs, so the probe goes here
    data = replace_keep_length(data, CALLS['normal'],
                               PROBE.ljust(len(CALLS['normal']), b' '), 'normal movie call')

    if len(data) != before:
        raise SystemExit('length changed: %d -> %d' % (before, len(data)))
    open(OUT, 'wb').write(bytes(data))
    print('wrote', OUT, len(data), 'bytes (same length)')
    print('movie off on all difficulties; FOV probe runs on the normal branch')


if __name__ == '__main__':
    main()