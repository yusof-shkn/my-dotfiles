#!/usr/bin/env python3
import socket
import os
import threading
import time
from evdev import UInput, ecodes as e

SOCKET_PATH = "/tmp/cursor-daemon.sock"
STEP = 10
INTERVAL = 0.016  # ~60 FPS

ui = UInput({
    e.EV_REL: [e.REL_X, e.REL_Y],
    e.EV_KEY: [e.BTN_LEFT, e.BTN_RIGHT],
}, name="cursor-daemon")

keys = {"up": False, "down": False, "left": False, "right": False}
lock = threading.Lock()
last_press_time = {}


def move_loop():
    while True:
        time.sleep(INTERVAL)
        with lock:
            now = time.time()
            for key in keys:
                if keys[key] and (now - last_press_time.get(key, 0)) > 0.5:
                    keys[key] = False
            dx = (keys["right"] - keys["left"]) * STEP
            dy = (keys["down"] - keys["up"]) * STEP
            if dx or dy:
                if dx:
                    ui.write(e.EV_REL, e.REL_X, dx)
                if dy:
                    ui.write(e.EV_REL, e.REL_Y, dy)
                ui.syn()


threading.Thread(target=move_loop, daemon=True).start()

if os.path.exists(SOCKET_PATH):
    os.remove(SOCKET_PATH)

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(SOCKET_PATH)
server.listen(5)

HANDLERS = {
    "press:up":       lambda: keys.update(up=True)    or last_press_time.update(up=time.time()),
    "release:up":     lambda: keys.update(up=False),
    "press:down":     lambda: keys.update(down=True)  or last_press_time.update(down=time.time()),
    "release:down":   lambda: keys.update(down=False),
    "press:left":     lambda: keys.update(left=True)  or last_press_time.update(left=time.time()),
    "release:left":   lambda: keys.update(left=False),
    "press:right":    lambda: keys.update(right=True) or last_press_time.update(right=time.time()),
    "release:right":  lambda: keys.update(right=False),
    "press:lclick":   lambda: (ui.write(e.EV_KEY, e.BTN_LEFT, 1),  ui.syn()),
    "release:lclick": lambda: (ui.write(e.EV_KEY, e.BTN_LEFT, 0),  ui.syn()),
    "press:rclick":   lambda: (ui.write(e.EV_KEY, e.BTN_RIGHT, 1), ui.syn()),
    "release:rclick": lambda: (ui.write(e.EV_KEY, e.BTN_RIGHT, 0), ui.syn()),
}

while True:
    conn, _ = server.accept()
    cmd = conn.recv(64).decode().strip()
    conn.close()
    handler = HANDLERS.get(cmd)
    if handler:
        with lock:
            handler()
