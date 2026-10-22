"""Read the original Halo CE map so we can see how its in-engine cutscenes are
actually built (not just the script verbs).

Halo 1 cache layout (.map), as the previous work's reader established it:
  head:      'daeh' (head reversed), version, tag_data_offset, tag_data_size, name
  tag_data:  first u32 = the tag array's absolute offset; base = that - 0x28
  tag array: 32-byte records: class (4), then 12 zero bytes, id, path pointer,
             data pointer, external flag
  pointers inside a tag are absolute offsets; ofs() turns one into an index into
  tag_data.

  usage: python ce_tags.py <map> [class ...]
"""
import struct
import sys


class CeMap:
    def __init__(self, path):
        self.f = open(path, 'rb')
        head = self.read_at(0, 0x800)
        assert head[:4] == b'daeh', 'not a Halo cache file'
        # the previous reader used 1-based offsets; these are the same bytes
        self.version = struct.unpack_from('<i', head, 4)[0]
        self.tag_data_offset = struct.unpack_from('<I', head, 16)[0]
        self.tag_data_size = struct.unpack_from('<I', head, 20)[0]
        self.name = head[32:64].split(b'\0')[0].decode('latin1')
        self.tag_data = self.read_at(self.tag_data_offset, self.tag_data_size)
        tag_array = struct.unpack_from('<I', self.tag_data, 0)[0]
        self.base = tag_array - 0x28
        self.scenario_id = struct.unpack_from('<I', self.tag_data, 4)[0]
        self.tag_count = struct.unpack_from('<I', self.tag_data, 0x0C)[0]
        self.tags = []
        self.by_class = {}
        for i in range(self.tag_count):
            o = 0x28 + i * 32
            klass = self.tag_data[o:o + 4][::-1].decode('latin1')
            ident, path_ptr, data_ptr, external = struct.unpack_from('<IIII', self.tag_data, o + 12)
            tag = {
                'index': i, 'class': klass, 'id': ident,
                'path': self.cstring(path_ptr), 'data': data_ptr,
                'external': external != 0,
            }
            self.tags.append(tag)
            self.by_class.setdefault(klass, []).append(tag)

    def read_at(self, offset, size):
        self.f.seek(offset)
        return self.f.read(size)

    def ofs(self, ptr):
        return ptr - self.base

    def cstring(self, ptr):
        i = self.ofs(ptr)
        j = self.tag_data.index(b'\0', i)
        return self.tag_data[i:j].decode('latin1')

    def u8(self, ptr):  return struct.unpack_from('<B', self.tag_data, self.ofs(ptr))[0]
    def i8(self, ptr):  return struct.unpack_from('<b', self.tag_data, self.ofs(ptr))[0]
    def i16(self, ptr): return struct.unpack_from('<h', self.tag_data, self.ofs(ptr))[0]
    def u16(self, ptr): return struct.unpack_from('<H', self.tag_data, self.ofs(ptr))[0]
    def i32(self, ptr): return struct.unpack_from('<i', self.tag_data, self.ofs(ptr))[0]
    def u32(self, ptr): return struct.unpack_from('<I', self.tag_data, self.ofs(ptr))[0]
    def f32(self, ptr): return struct.unpack_from('<f', self.tag_data, self.ofs(ptr))[0]
    def str32(self, ptr):
        i = self.ofs(ptr)
        return self.tag_data[i:i + 32].split(b'\0')[0].decode('latin1')

    def vec3(self, ptr):
        return struct.unpack_from('<fff', self.tag_data, self.ofs(ptr))

    def reflex(self, ptr):
        count, first = struct.unpack_from('<iI', self.tag_data, self.ofs(ptr))
        return count, first

    def each(self, ptr, stride):
        count, first = self.reflex(ptr)
        return [(i, first + i * stride) for i in range(count)]

    def tag_bytes(self, tag):
        """A tag's own bytes: header (0x30) then its data."""
        # data_ptr points at the tag header in the tag_data block
        i = self.ofs(tag['data'])
        return self.tag_data[i:]

    def data_of(self, tag):
        i = self.ofs(tag['data'])
        return self.tag_data[i + 0x30:]

    def dep(self, ptr):
        klass = self.tag_data[self.ofs(ptr):self.ofs(ptr) + 4][::-1].decode('latin1')
        ident = struct.unpack_from('<I', self.tag_data, self.ofs(ptr) + 12)[0]
        if ident == 0xFFFFFFFF:
            return None
        for t in self.tags:
            if t['id'] == ident:
                return t
        return None

    def scenario(self):
        for t in self.tags:
            if t['id'] == self.scenario_id:
                return t
        return None


def main():
    path = sys.argv[1]
    want = sys.argv[2:]
    m = CeMap(path)
    print('%s: version %d, %d tags, scenario id 0x%x' % (m.name, m.version, m.tag_count, m.scenario_id))
    counts = {}
    for t in m.tags:
        counts[t['class']] = counts.get(t['class'], 0) + 1
    print('classes: ' + ', '.join('%s=%d' % kv for kv in sorted(counts.items())))
    for klass in want:
        print('--- %s tags ---' % klass)
        for t in m.by_class.get(klass, []):
            print('  [%d] id 0x%08x %s (external=%s)' % (t['index'], t['id'], t['path'], t['external']))


if __name__ == '__main__':
    main()