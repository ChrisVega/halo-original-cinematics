"""Patch the A15 scenario: the level prep for the bridge happens BEFORE the
intro cinematic, so the bridge is there while the original cutscene plays.

The original CE does the same: its startup script runs the intro (x10) inline,
and x10 does the bsp switch and the object predictions before the cutscenes.
In the remake the mission's scripts are woken after the cinematic, and that
call blocks while the cutscene plays, so the mission cannot start during it.

Only lines are moved, so the text keeps its byte length and no offset in the
tag moves.
"""
import sys

BULK = sys.argv[1] if len(sys.argv) > 1 else 'a15-scenario.ubulk'
OUT = sys.argv[2] if len(sys.argv) > 2 else 'a15-scenario-patched.ubulk'

# the lines to move, and where to move them: in front of the cinematic call
MOVE = [
    b'\t\t\t;load necessary doors, etc.\r\n',
    b'\t\t\t(submit_incident_with_custom_string_id "game_activity_begin" "a10")\r\n',
    b'\t\t\t(pre_bridge_load)\r\n',
]
# the anchor: the cinematic call's line
ANCHOR = b'\t\t\t(cond\r\n'


def reorder(d):
    """Moves the level prep in front of the cinematic call. Returns the new bytes."""
    start = d.find(b'(if (f_insertion_point_area_pending ins_start)')
    if start < 0:
        raise SystemExit('ins_start branch not found')
    cond = d.find(ANCHOR, start)
    if cond < 0:
        raise SystemExit('cond not found')
    end = d.find(b'(true (f_play_cinematic cinematics', cond)
    if end < 0:
        raise SystemExit('cinematic call not found')
    tail = d.find(b'\t\t\t)\r\n', end)
    if tail < 0:
        raise SystemExit('cond end not found')
    tail += len(b'\t\t\t)\r\n')
    # the lines being moved come after the cond, so the block reaches past them
    for m in MOVE:
        k = d.find(m, tail)
        if k < 0:
            raise SystemExit('move line not found after the cond: %r' % m)
        tail = k + len(m)
    block = d[cond:tail]
    moved = b''
    for m in MOVE:
        if m not in block:
            raise SystemExit('move line not inside the block: %r' % m)
        moved += m
        block = block.replace(m, b'', 1)
    new = moved + block
    if len(new) != len(d[cond:tail]):
        raise SystemExit('length changed: %d -> %d' % (len(d[cond:tail]), len(new)))
    return d[:cond] + new + d[tail:]


if __name__ == '__main__':
    d = bytearray(open(BULK, 'rb').read())
    d = reorder(d)
    open(OUT, 'wb').write(bytes(d))
    print('wrote', OUT, len(d), 'bytes')
