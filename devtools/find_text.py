import mmap, os
p = r"C:\Program Files (x86)\Steam\steamapps\common\Halo The Master Chief Collection\halo1\maps\a10.map"
sz = os.path.getsize(p)
print("map size", sz)
f = open(p, "rb")
mm = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)
for needle in [b"90 second", b"all over us", b"that's it", b"that\x27s it", b"work to do", b"get to work", b"seconds", b"over us"]:
    idx = mm.find(needle)
    print(needle, idx)
    if idx >= 0:
        print("   ctx:", mm[max(0, idx - 100):idx + 100])
