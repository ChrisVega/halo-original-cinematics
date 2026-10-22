"""Starts b30 in the open Halo port, keeps the camera on the player (seated in insertion_pelican_1, p-riderlf)
by sending camera_control false, and records the camera ~10/s with game_time to probe-out/ce_b30_ride.tsv."""
import socket, time, sys, os
CAM = r"D:\games\halo ce\camera.txt"
OUT = os.path.join(os.path.dirname(__file__), "..", "probe-out", "ce_b30_ride.tsv")
secs = float(sys.argv[1]) if len(sys.argv) > 1 else 60
s = socket.create_connection(("127.0.0.1", 2323), timeout=5)
s.settimeout(0.05)
def cmd(c): s.sendall((c + "\r\n").encode())
def drain():
    b = b""
    try:
        while True:
            d = s.recv(65536)
            if not d: break
            b += d
    except Exception: pass
    return b.decode("latin1")
cmd("map_name b30"); time.sleep(0.5); drain()
with open(OUT, "w") as f:
    f.write("wall\tgame_time\tx\ty\tz\tfx\tfy\tfz\tux\tuy\tuz\tfov\n")
    t0 = time.time()
    while time.time() - t0 < secs:
        cmd("camera_control false")
        cmd("game_time"); time.sleep(0.03)
        gt = [l for l in drain().split() if l.strip().isdigit()]
        cmd("debug_camera_save"); time.sleep(0.05); drain()
        try: v = open(CAM).read().split()
        except Exception: continue
        if len(v) >= 10 and gt:
            f.write("%.2f\t%s\t%s\n" % (time.time() - t0, gt[-1], "\t".join(v[:10]))); f.flush()
print("done")
