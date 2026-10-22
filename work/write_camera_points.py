"""Write the original's camera path into the remake's A15 mission file.

How the remake's tag stores this, worked out from `mjolnir data --trace`:

- The tag's data section begins at a fixed offset in the payload (DATA_BASE).
- Every block has a 12-byte header there: count (u32), the number of elements its
  storage holds (u32), spare (u32). The elements live in a "tgbl" section that
  the block's own record points at; blocks that are empty have count 0 and no
  storage at all.
- The cutscene camera points block in the shipped A15 is empty: count 0, storage 0.
- A camera point is 104 bytes: name (a 32-byte string at +4), position (+40),
  rotation angles (+52), field of view (+64).

So this tool:
  1. finds the camera points block header in the payload,
  2. copies the points out of the sheet into records of the same layout,
  3. places the records in the block's storage, growing the payload as needed,
  4. points the block header at the new storage and sets the count,
  5. leaves everything else byte-identical, and
  6. hands the result to MJOLNIR, which re-packs and re-walks the tag: if the
     offsets are wrong, the walk fails there and the file is not installed.

  python write_camera_points.py <pristine.ubulk> <sheet.json> <out.ubulk>
"""
import json
import struct
import sys

# from mjolnir data --group scenario --tag a15-scenario --trace
DATA_BASE = 74653
CAMERA_BLOCK_OFFSET = 1040          # field offset of the camera points block
CAMERA_ELEMENT = 104
NAME_OFFSET = 4
POS_OFFSET = 40
ROT_OFFSET = 52
FOV_OFFSET = 64


def fail(msg):
    raise SystemExit("write_camera_points: " + msg)


def find_header(data):
    """The camera points block header is the one that reads count 0 in a run of
    block headers; the shipped file has it right after the cutscene flags block
    (count 102). We locate it by that neighbour, not by guessing an offset."""
    # the cutscene flags block: count 0x66 = 102
    flags = bytes([0x66, 0, 0, 0]) + b'\0' * 8
    at = data.find(flags)
    if at < 0:
        fail("could not find the cutscene flags block header")
    header = at + 12              # the next block header
    count, stored, spare = struct.unpack_from('<III', data, header)
    if count != 0 or stored != 0:
        fail("the camera points block is not empty (count %d, storage %d); "
             "nothing to do" % (count, stored))
    return header


def main():
    src, sheet_path, out = sys.argv[1], sys.argv[2], sys.argv[3]
    data = bytearray(open(src, 'rb').read())
    header = find_header(data)

    sheet = json.load(open(sheet_path, encoding='utf-8'))
    rows = sheet['rows']
    if not rows:
        fail("the camera path sheet has no rows")

    # Where the block's storage goes. The shipped tag has none, so we append a
    # tgbl section for it at the end of the data section and point the header at
    # it. The data section's own size lives at the start of the payload; MJOLNIR
    # rebuilds the container around whatever payload it is given, and re-walks it,
    # so the only thing this tool has to get right is the internal layout.
    print("camera points block header at payload %d" % header)
    print("points to write: %d" % len(rows))

    for r in rows:
        print("  %-26s blend %4d ms  pos (%8.3f %8.3f %8.3f) fov %4.1f"
              % (r['name'], r['blend_ms'], r['pos_x'], r['pos_y'], r['pos_z'], r['fov_deg']))

    fail("storage allocation not finished yet; this tool stops before writing "
         "so nothing half-written can reach the game")


if __name__ == '__main__':
    main()