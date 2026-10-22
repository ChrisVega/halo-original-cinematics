"""Where each block's element data lives in the tag, in data-section order.

The trace prints, for every block with storage, where its elements are. Empty
blocks point at a shared zero slot, so they have no region of their own. This
lists the blocks that do have elements, in the order they appear, so we can see
where a new region for the camera points has to go: between the region of the
block before it in schema order and the region of the block after it.
"""
import re
import sys


def main():
    path = sys.argv[1]
    raw = open(path, 'rb').read(4)
    enc = 'utf-16' if raw[:2] in (b'\xff\xfe', b'\xfe\xff') else 'utf-8'
    text = open(path, encoding=enc, errors='replace', newline='').read()

    blocks = []
    for line in text.splitlines():
        s = line.strip()
        if not s.endswith(']') and 'block -> tgbl at' not in s:
            continue
        m = re.match(r'^(.*?) block -> tgbl at \+(\d+) size (\d+)$', s)
        if m:
            blocks.append((m.group(1).strip(), int(m.group(2)), int(m.group(3))))
    print('blocks with storage:', len(blocks))

    # the blocks around the cutscene ones, in schema order
    print('\n-- blocks near the cutscene blocks (schema order) --')
    want = ('scripts', 'globals', 'source files', 'cutscene flags',
            'cutscene camera points', 'cutscene spline points', 'cutscene titles',
            'object names', 'scenery', 'bipeds')
    for name, off, size in blocks:
        leaf = name.split('.')[-1]
        if leaf in want:
            print('  +%-9d size %-8d %s' % (off, size, name))

    print('\n-- every block with a real region, sorted by offset (first 40) --')
    real = [(o, s, n) for n, o, s in blocks if s > 8]
    real.sort()
    for o, s, n in real[:40]:
        print('  +%-9d size %-8d %s' % (o, s, n.split('.')[-1] if n.count('.') < 3 else n))
    print('  ... %d regions total' % len(real))


if __name__ == '__main__':
    main()