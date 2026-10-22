"""Switch the remake's own cutscene videos off in the A15 scenario.

The remake plays its A15 opening as pre-rendered movies: the space intro and the
bridge scene. The original cutscene is played by the game itself, in-engine, so
those two calls are replaced by a no-op that keeps the script's shape and its
byte length (the tag stores offsets into itself, so the text may not grow).

Nothing the game ships is changed: the patched payload is baked into an override
container that the game loads in front of the shipped one, and deleting the three
files in the game's Paks folder reverts everything.
"""
import sys

SRC = sys.argv[1] if len(sys.argv) > 1 else "work/extracted/Levels/Halo1/Solo/A15/_Generated_/a15.scenario"
DST = sys.argv[2] if len(sys.argv) > 2 else "work/a15-scenario-patched.scenario"

# the calls that start the remake's movies, and what they become
REPLACEMENTS = [
    (b"(f_play_cinematic cinematics\\a10\\a10_intro_legendary.cinematic)",
     b'(print "Original Cinematics: intro movie off")'),
    (b"(f_play_cinematic cinematics\\a10\\a10_intro_heroic.cinematic)",
     b'(print "Original Cinematics: intro movie off")'),
    (b"(f_play_cinematic cinematics\\a10\\a10_intro_normal.cinematic)",
     b'(print "Original Cinematics: intro movie off")'),
    (b"(f_play_cinematic cinematics\\a10\\a10_bridge.cinematic ps_post_bridge_cine)",
     b'(print "Original Cinematics: bridge movie off")'),
]


def balanced(text):
    return text.count(b"(") == text.count(b")")


def main():
    data = bytearray(open(SRC, "rb").read())
    for old, new in REPLACEMENTS:
        count = data.count(old)
        if count != 1:
            raise SystemExit("expected one %r, found %d" % (old, count))
        if len(new) > len(old):
            raise SystemExit("replacement too long: %r" % new)
        if not balanced(old) or not balanced(new):
            raise SystemExit("unbalanced parentheses")
        padded = new + b" " * (len(old) - len(new))
        data[data.index(old):data.index(old) + len(old)] = padded
        print("replaced %r" % old.decode())
    if len(data) != len(open(SRC, "rb").read()):
        raise SystemExit("length changed")
    open(DST, "wb").write(bytes(data))
    print("wrote", DST, len(data), "bytes")


if __name__ == "__main__":
    main()
