"""Grab the game's window while the test runs.

Melty's media review needs a real picture of the game, and so do we: this saves
the game window to shots/ so we can see what it is doing.
"""
import ctypes
import os
import sys
import time

user32 = ctypes.windll.user32
try:
    ctypes.windll.shcore.SetProcessDpiAwareness(2)
except Exception:
    pass

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "shots")
os.makedirs(OUT, exist_ok=True)


def window_rect(hwnd):
    class RECT(ctypes.Structure):
        _fields_ = [("left", ctypes.c_long), ("top", ctypes.c_long),
                    ("right", ctypes.c_long), ("bottom", ctypes.c_long)]
    r = RECT()
    user32.GetWindowRect(hwnd, ctypes.byref(r))
    return r


def find_game():
    best = None
    import subprocess
    out = subprocess.run(["tasklist", "/FI", "IMAGENAME eq HaloCampaignEvolved.exe", "/FO", "CSV"],
                         capture_output=True, text=True).stdout
    for line in out.splitlines()[1:]:
        parts = [p.strip('"') for p in line.split('","')]
        pid = None
        for p in parts:
            if p.isdigit():
                pid = int(p)
                break
        if pid is None:
            continue
        found = []

        @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)
        def cb(h, _):
            pid_w = ctypes.c_ulong()
            user32.GetWindowThreadProcessId(h, ctypes.byref(pid_w))
            if pid_w.value == pid:
                if user32.IsWindowVisible(h):
                    length = user32.GetWindowTextLengthW(h)
                    buf = ctypes.create_unicode_buffer(length + 1)
                    user32.GetWindowTextW(h, buf, length + 1)
                    r = window_rect(h)
                    if (r.right - r.left) > 400 and (r.bottom - r.top) > 300:
                        found.append((h, buf.value, r.right - r.left, r.bottom - r.top))
            return True

        user32.EnumWindows(cb, 0)
        if found:
            found.sort(key=lambda x: x[2] * x[3], reverse=True)
            return found[0]
    return None


def shot(hwnd, path):
    from PIL import Image  # noqa
    return False


def main():
    seconds = float(sys.argv[1]) if len(sys.argv) > 1 else 5.0
    tag = sys.argv[2] if len(sys.argv) > 2 else "shot"
    g = find_game()
    if not g:
        print("no game window yet")
        return 1
    hwnd, title, w, h = g
    print("window:", title, w, "x", h)
    ctypes.windll.user32.SetForegroundWindow(hwnd)
    time.sleep(seconds)
    # capture with GDI into a bitmap
    from ctypes import wintypes
    user32.SetProcessDPIAware()
    hdesk = user32.GetDesktopWindow()
    width, height = w, h
    gdi32 = ctypes.windll.gdi32
    hdc = user32.GetWindowDC(hwnd)
    mdc = gdi32.CreateCompatibleDC(hdc)
    bmp = gdi32.CreateCompatibleBitmap(hdc, width, height)
    gdi32.SelectObject(mdc, bmp)
    user32.PrintWindow(hwnd, mdc, 2)

    class BITMAPINFOHEADER(ctypes.Structure):
        _fields_ = [("biSize", wintypes.DWORD), ("biWidth", wintypes.LONG),
                    ("biHeight", wintypes.LONG), ("biPlanes", wintypes.WORD),
                    ("biBitCount", wintypes.WORD), ("biCompression", wintypes.DWORD),
                    ("biSizeImage", wintypes.DWORD), ("biXPelsPerMeter", wintypes.LONG),
                    ("biYPelsPerMeter", wintypes.LONG), ("biClrUsed", wintypes.DWORD),
                    ("biClrImportant", wintypes.DWORD)]

    bi = BITMAPINFOHEADER()
    bi.biSize = ctypes.sizeof(BITMAPINFOHEADER)
    bi.biWidth = width
    bi.biHeight = -height
    bi.biPlanes = 1
    bi.biBitCount = 32
    bi.biCompression = 0
    buf = ctypes.create_string_buffer(width * height * 4)
    gdi32.GetDIBits(mdc, bmp, 0, height, buf, ctypes.byref(bi), 0)
    gdi32.DeleteObject(bmp)
    gdi32.DeleteDC(mdc)
    user32.ReleaseDC(hwnd, hdc)

    try:
        from PIL import Image
        img = Image.frombuffer("RGBA", (width, height), buf, "raw", "BGRA", 0, 1)
        img.convert("RGB").save(os.path.join(OUT, tag + ".png"))
        print("saved", os.path.join(OUT, tag + ".png"))
    except ImportError:
        path = os.path.join(OUT, tag + ".raw")
        open(path, "wb").write(buf.raw)
        print("no PIL: wrote", path)
    return 0


if __name__ == "__main__":
    sys.exit(main())