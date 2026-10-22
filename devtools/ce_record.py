"""Record the original Halo CE camera during the A10 bridge cutscene.

The CE build on this PC (the halobeta port of the original Xbox game) opens a script
console on 127.0.0.1:2323. It answers the game's own console commands:
  map_name a10     - load the mission
  game_time        - the mission's clock, in ticks
  debug_camera_save- writes the camera's position, facing, up vector and field of view
                      to camera.txt beside the game

Samples are written as a TSV: wall clock, game time, position, facing, up, field of view.
That recording is the 1:1 camera path of the original cutscene.

usage: python ce_record.py [seconds] [map]
"""
import os
import socket
import sys
import time

GAME_DIR = r"D:\games\halo ce"
CAM_FILE = os.path.join(GAME_DIR, "camera.txt")
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "research", "ce_camera_a10.tsv")
LOG = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "research", "ce_console.log")

HOST, PORT = "127.0.0.1", 2323


def connect(timeout=120):
    end = time.time() + timeout
    while time.time() < end:
        try:
            s = socket.create_connection((HOST, PORT), timeout=5)
            s.settimeout(0.05)
            return s
        except OSError:
            time.sleep(1.0)
    raise SystemExit("the game's script console never came up")


def drain(s):
    out = b""
    try:
        while True:
            d = s.recv(65536)
            if not d:
                break
            out += d
    except OSError:
        pass
    return out.decode("latin1", "replace")


def cmd(s, text):
    s.sendall((text + "\r\n").encode("latin1"))


def main():
    seconds = float(sys.argv[1]) if len(sys.argv) > 1 else 300.0
    map_name = sys.argv[2] if len(sys.argv) > 2 else "a10"
    s = connect()
    console = open(LOG, "w", encoding="utf-8", errors="replace")
    cmd(s, "map_name " + map_name)
    time.sleep(2)
    console.write(drain(s))
    console.flush()
    with open(OUT, "w", encoding="utf-8") as f:
        f.write("wall\ttick\tgame_time\tx\ty\tz\tfx\tfy\tfz\tux\tuy\tuz\tfov_rad\n")
        t0 = time.time()
        last_tick = None
        while time.time() - t0 < seconds:
            cmd(s, "game_time")
            time.sleep(0.02)
            reply = drain(s)
            console.write(reply)
            tick = None
            for token in reply.split():
                if token.isdigit():
                    tick = int(token)
            cmd(s, "debug_camera_save")
            time.sleep(0.03)
            drain(s)
            try:
                with open(CAM_FILE) as cam:
                    values = cam.read().split()
            except OSError:
                continue
            if len(values) < 10 or tick is None:
                continue
            f.write("%.2f\t%d\t%s\n" % (time.time() - t0, tick, "\t".join(values[:10])))
            f.flush()
            if tick != last_tick:
                last_tick = tick
    console.write(drain(s))
    console.close()
    s.close()
    print("recorded to", OUT)


if __name__ == "__main__":
    main()
