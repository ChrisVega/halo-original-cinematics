import sys, pefile, capstone
exe = sys.argv[1]
pe = pefile.PE(exe, fast_load=True)
data = open(exe,'rb').read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_64)
def off(rva): return pe.get_offset_from_rva(rva)
for rva_s in sys.argv[2:]:
    rva = int(rva_s,16)
    # find function start via .pdata
    pe.parse_data_directories(directories=[pefile.DIRECTORY_ENTRY['IMAGE_DIRECTORY_ENTRY_EXCEPTION']])
    fs = None
    for e in pe.DIRECTORY_ENTRY_EXCEPTION:
        if e.struct.BeginAddress <= rva < e.struct.EndAddress:
            fs, fe = e.struct.BeginAddress, e.struct.EndAddress; break
    print(f"== {rva:x} func {fs and hex(fs)}-{fs and hex(fe)}")
    s = fs if fs and rva-fs < 0x600 else rva-0x80
    e2 = min(fe if fs else rva+0x40, rva+0x60)
    code = data[off(s):off(s)+(e2-s)]
    for i in md.disasm(code, 0x140000000+s):
        mark = ' <==' if i.address-0x140000000 == rva else ''
        print(f"{i.address-0x140000000:x}: {i.mnemonic} {i.op_str}{mark}")
