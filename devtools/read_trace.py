"""Read MJOLNIR's data-walk trace and list the block ('tgbl') records.

The trace prints, for every block, where its element storage is in the data
section and how big it is. This turns that into a table so we can see the block
storage table's shape and where a new record for an empty block has to go.
"""
import re
import sys


def main():
    rows = []
    # PowerShell writes redirected output as UTF-16, so sniff the first bytes
    # rather than assuming an encoding.
    raw = open(sys.argv[1], 'rb').read(4)
    encoding = 'utf-16' if raw[:2] in (b'\xff\xfe', b'\xfe\xff') else 'utf-8'
    text = open(sys.argv[1], encoding=encoding, errors='replace', newline='').read()
    for line in text.splitlines():
        if 'tgbl at' not in line:
            continue
        m = re.search(r'^(.*?) block -> tgbl at \+(\d+) size (\d+)', line)
        if m:
            rows.append((int(m.group(2)), int(m.group(3)), m.group(1).strip()))
    print('tgbl records:', len(rows))
    rows.sort()
    for off, size, name in rows[:12]:
        print('  +%-9d size %-8d %s' % (off, size, name))
    print('  ...')
    for off, size, name in rows[-8:]:
        print('  +%-9d size %-8d %s' % (off, size, name))

    # where the cutscene flags' elements live (data-relative), so we can find the
    # record that points at them
    flags_elements = 1971454
    near = [r for r in rows if abs(r[0] - flags_elements) < 4000]
    print('records within 4000 of the flags elements (%d):' % flags_elements)
    for off, size, name in near:
        print('  +%-9d size %-8d %s' % (off, size, name))

    # are empty blocks given an 8-byte record of their own?
    eight = [r for r in rows if r[1] == 8]
    print('records of exactly 8 bytes (empty blocks):', len(eight))
    for off, size, name in eight[:10]:
        print('  +%-9d size %-8d %s' % (off, size, name))


if __name__ == '__main__':
    main()