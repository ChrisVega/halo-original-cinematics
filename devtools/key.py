"""Send keys and clicks to the game window, and take a picture of it.

Used to drive the test: press Escape out of a lobby, pick the campaign, start the
mission, and look at what the game shows.

  python devtools/key.py shot <tag>
  python devtools/key.py keys ESC ESC
  python devtools/key.py type "hello"
  python devtools/key.py click 0.5 0.5
  python devtools/key.py hold w 2
"""
import ctypes
import os
import subprocess
import sys
import time

user32 = ctypes.windll.user32
gdi32 = ctypes.windll.gdi32
try:
    ctypes.windll.shcore.SetProcessDpiAwareness(2)
except Exception:
    pass

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "shots")
os.makedirs(OUT, exist_ok=True)

KEYS = {
    "ESC": 0x1B, "ENTER": 0x0D, "RETURN": 0x0D, "SPACE": 0x20, "TAB": 0x09,
    "LEFT": 0x25, "UP": 0x26, "RIGHT": 0x27, "DOWN": 0x28,
    "W": 0x57, "A": 0x41, "S": 0x53, "D": 0x44, "E": 0x45, "F": 0x46, "Q": 0x51,
    "R": 0x52, "M": 0x4D, "N": 0x4E, "B": 0x42, "C": 0x43, "X": 0x58, "Y": 0x59,
    "1": 0x31, "2": 0x32, "3": 0x33, "4": 0x34, "5": 0x35, "6": 0x36, "7": 0x37,
    "SHIFT": 0x10, "CTRL": 0x11, "ALT": 0x12, "BACK": 0x08,
}

MOUSEEVENTF_MOVE = 0x0001
MOUSEEVENTF_ABSOLUTE = 0x8000
MOUSEEVENTF_LEFTDOWN = 0x0002
MOUSEEVENTF_LEFTUP = 0x0004


class MOUSEINPUT(ctypes.Structure):
    _fields_ = [("dx", ctypes.c_long), ("dy", ctypes.c_long),
                ("mouseData", ctypes.c_ulong), ("dwFlags", ctypes.c_ulong),
                ("time", ctypes.c_ulong), ("dwExtraInfo", ctypes.POINTER(ctypes.c_ulong))]


class KEYBDINPUT(ctypes.Structure):
    _fields_ = [("wVk", ctypes.c_ushort), ("wScan", ctypes.c_ushort),
                ("dwFlags", ctypes.c_ulong), ("time", ctypes.c_ulong),
                ("dwExtraInfo", ctypes.POINTER(ctypes.c_ulong))]


class INPUT(ctypes.Structure):
    class _U(ctypes.Union):
        _fields_ = [("mi", MOUSEINPUT), ("ki", KEYBDINPUT)]
    _anonymous_ = ("u",)
    _fields_ = [("type", ctypes.c_ulong), ("u", _U)]


def game_window():
    out = subprocess.run(["tasklist", "/FI", "IMAGENAME eq HaloCampaignEvolved.exe", "/FO", "CSV"],
                         capture_output=True, text=True).stdout
    pid = None
    for line in out.splitlines()[1:]:
        for p in [x.strip('"') for x in line.split('","')]:
            if p.isdigit():
                pid = int(p)
                break
        if pid:
            break
    if pid is None:
        return None
    found = []

    class RECT(ctypes.Structure):
        _fields_ = [("left", ctypes.c_long), ("top", ctypes.c_long),
                    ("right", ctypes.c_long), ("bottom", ctypes.c_long)]

    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
    def cb(h, _):
        p = ctypes.c_ulong()
        user32.GetWindowThreadProcessId(h, ctypes.byref(p))
        if p.value == pid and user32.IsWindowVisible(h):
            r = RECT()
            user32.GetWindowRect(h, ctypes.byref(r))
            if (r.right - r.left) > 400 and (r.bottom - r.top) > 300:
                found.append((h, r))
        return True

    user32.EnumWindows(cb, 0)
    if not found:
        return None
    found.sort(key=lambda x: (x[1].right - x[1].left) * (x[1].bottom - x[1].top), reverse=True)
    return found[0]


def focus():
    g = game_window()
    if not g:
        raise SystemExit("no game window")
    hwnd, _ = g
    user32.ShowWindow(hwnd, 9)  # SW_RESTORE
    user32.SetForegroundWindow(hwnd)
    time.sleep(0.4)
    return g


def key(name, hold=0.05):
    vk = KEYS.get(name.upper())
    if vk is None:
        raise SystemExit("unknown key %s" % name)
    for flags, code in ((0, vk), (2, vk)):
        i = INPUT(type=1)
        i.ki = KEYBDINPUT(wVk=code, wScan=0, dwFlags=flags, time=0, dwExtraInfo=None)
        user32.SendInput(1, ctypes.byref(i), ctypes.sizeof(INPUT))
        time.sleep(hold if flags == 0 else 0.02)


def type_text(text):
    for ch in text:
        vk = user32.VkKeyScanW(ord(ch))
        code = vk & 0xFF
        shift = (vk >> 8) & 1
        if shift:
            key("SHIFT", 0.02)
        key(chr(code) if chr(code).isalpha() else ch, 0.04)
        if shift:
            key("SHIFT", 0.02)


def click(fx, fy):
    g = focus()
    hwnd, r = g
    x = r.left + int((r.right - r.left) * fx)
    y = r.top + int((r.bottom - r.top) * fy)
    user32.SetCursorPos(x, y)
    time.sleep(0.1)
    i = INPUT(type=0)
    i.mi = MOUSEINPUT(x=0, y=0, mouseData=0, dwFlags=MOUSEEVENTF_LEFTDOWN, time=0, dwExtraInfo=None)
    user32.SendInput(1, ctypes.byref(i), ctypes.sizeof(INPUT))
    time.sleep(0.05)
    i.mi = MOUSEINPUT(x=0, y=0, mouseData=0, dwFlags=MOUSEEVENTF_LEFTUP, time=0, dwExtraInfo=None)
    user32.SendInput(1, ctypes.byref(i), ctypes.sizeof(INPUT))


def shot(tag):
    g = game_window()
    if not g:
        raise SystemExit("no game window")
    hwnd, r = g
    width, height = r.right - r.left, r.bottom - r.top
    hdc = user32.GetWindowDC(hwnd)
    mdc = gdi32.CreateCompatibleDC(hdc)
    bmp = gdi32.CreateCompatibleBitmap(hdc, width, height)
    gdi32.SelectObject(mdc, bmp)
    user32.PrintWindow(hwnd, mdc, 2)

    class BITMAPINFOHEADER(ctypes.Structure):
        _fields_ = [("biSize", ctypes.c_ulong), ("biWidth", ctypes.c_long),
                    ("biHeight", ctypes.c_long), ("biPlanes", ctypes.c_ushort),
                    ("biBitCount", ctypes.c_ushort), ("biCompression", ctypes.c_ulong),
                    ("biSizeImage", ctypes.c_ulong), ("biXPelsPerMeter", ctypes.c_long),
                    ("biYPelsPerMeter", ctypes.c_long), ("biClrUsed", ctypes.c_ulong),
                    ("biClrImportant", ctypes.c_ulong)]

    bi = BITMAPINFOHEADER()
    bi.biSize = ctypes.sizeof(bi)
    bi.biWidth = width
    bi.biHeight = -height
    bi.biPlanes = 1
    bi.biBitCount = 32
    buf = ctypes.create_string_buffer(width * height * 4)
    gdi32.GetDIBits(mdc, bmp, 0, height, buf, ctypes.byref(bi), 0)
    gdi32.DeleteObject(bmp)
    gdi32.DeleteDC(mdc)
    user32.ReleaseDC(hwnd, hdc)
    from PIL import Image
    img = Image.frombuffer("RGBA", (width, height), buf, "raw", "BGRA", 0, 1)
    path = os.path.join(OUT, tag + ".png")
    img.convert("RGB").save(path)
    print(path)


def main():
    cmd = sys.argv[1]
    if cmd == "shot":
        shot(sys.argv[2])
    elif cmd == "keys":
        focus()
        for name in sys.argv[2:]:
            key(name)
            time.sleep(0.5)
        print("sent", " ".join(sys.argv[2:]))
    elif cmd == "type":
        focus()
        type_text(sys.argv[2])
        print("typed")
    elif cmd == "click":
        click(float(sys.argv[2]), float(sys.argv[3]))
        print("clicked")
    elif cmd == "hold":
        focus()
        key(sys.argv[2], hold=float(sys.argv[3]))
        print("held")
    else:
        raise SystemExit(__doc__)


if __name__ == "__main__":
    main()