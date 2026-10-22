"""Apply the same movie-disabling edits to the extracted scenario source.

The payload patch and the source patch must agree: the game compiles the source
text that lives inside the tag, so the source is what has to stay valid.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from patch_a15_disable_movies import REPLACEMENTS  # noqa: E402

SRC = sys.argv[1] if len(sys.argv) > 1 else "work/hsc-all/a15"


def main():
    for name in sorted(os.listdir(SRC)):
        if not name.endswith(".hsc"):
            continue
        path = os.path.join(SRC, name)
        data = open(path, "rb").read()
        before = len(data)
        hits = 0
        for old, new in REPLACEMENTS:
            if old in data:
                assert data.count(old) == 1, old
                padded = new + b" " * (len(old) - len(new))
                data = data.replace(old, padded)
                hits += 1
        if hits:
            assert len(data) == before
            open(path, "wb").write(data)
            print("patched %s (%d calls)" % (name, hits))


if __name__ == "__main__":
    main()
