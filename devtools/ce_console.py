"""Sends script console commands to the open Halo port (telnet_console, 127.0.0.1:2323) and prints replies."""
import socket, sys, time
def send(cmds, wait=1.0):
    s = socket.create_connection(("127.0.0.1", 2323), timeout=5)
    out = b""
    for c in cmds:
        s.sendall((c + "\r\n").encode())
        time.sleep(wait)
        s.settimeout(0.3)
        try:
            while True:
                d = s.recv(65536)
                if not d: break
                out += d
        except Exception: pass
    s.close()
    return out.decode("latin1")
if __name__ == "__main__":
    print(send(sys.argv[1:]))
