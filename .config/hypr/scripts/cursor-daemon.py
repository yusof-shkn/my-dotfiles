#!/usr/bin/env python3
import socket
import os
import threading
import time
from evdev import UInput, ecodes as e

SOCKET_PATH = "/tmp/cursor-daemon.sock"

# Movement tuning
MIN_STEP   = 3     # px/tick at first press
MAX_STEP   = 45    # px/tick at full speed
FAST_STEP  = 130   # px/tick for Alt+Shift fast mode
ACCEL_TIME = 0.7   # seconds to reach MAX_STEP
INTERVAL   = 0.012 # move loop tick (~83 Hz)
WATCHDOG   = 0.5   # seconds before auto-releasing a stuck key

ui = UInput({
    e.EV_REL: [e.REL_X, e.REL_Y],
    e.EV_KEY: [e.BTN_LEFT, e.BTN_RIGHT],
}, name="cursor-daemon")

lock       = threading.Lock()
DIRS       = ("up", "down", "left", "right")
keys       = {d: False for d in DIRS}   # normal held state
fast_keys  = {d: False for d in DIRS}   # Alt+Shift held state
held_since = {}                          # when key was first pressed
last_seen  = {}                          # last press event time (for watchdog)


def step_for(d):
    """Return pixels to move this tick for direction d."""
    if fast_keys[d]:
        return FAST_STEP
    if not keys[d]:
        return 0
    held = time.time() - held_since.get(d, time.time())
    t = min(held / ACCEL_TIME, 1.0)
    t = t * t  # ease-in: slow start, fast finish
    return int(MIN_STEP + (MAX_STEP - MIN_STEP) * t)


def move_loop():
    while True:
        time.sleep(INTERVAL)
        with lock:
            now = time.time()
            # Watchdog: drop keys whose press stream went silent
            for d in DIRS:
                if keys[d] and now - last_seen.get(d, 0) > WATCHDOG:
                    keys[d] = False
                    held_since.pop(d, None)
                if fast_keys[d] and now - last_seen.get(f"f{d}", 0) > WATCHDOG:
                    fast_keys[d] = False

            dx = step_for("right") - step_for("left")
            dy = step_for("down")  - step_for("up")

            if dx:
                ui.write(e.EV_REL, e.REL_X, dx)
            if dy:
                ui.write(e.EV_REL, e.REL_Y, dy)
            if dx or dy:
                ui.syn()


threading.Thread(target=move_loop, daemon=True).start()

# ── Socket server ────────────────────────────────────────────────────────────

if os.path.exists(SOCKET_PATH):
    os.remove(SOCKET_PATH)

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(SOCKET_PATH)
server.listen(8)


def handle(cmd):
    now = time.time()

    # Fast mode (Alt+Shift)
    if cmd.startswith("press:fast:"):
        d = cmd[len("press:fast:"):]
        if d in DIRS:
            fast_keys[d] = True
            last_seen[f"f{d}"] = now
        return
    if cmd.startswith("release:fast:"):
        d = cmd[len("release:fast:"):]
        if d in DIRS:
            fast_keys[d] = False
        return

    # Normal movement
    if cmd.startswith("press:"):
        d = cmd[len("press:"):]
        if d in DIRS:
            if not keys[d]:
                held_since[d] = now   # only set on first press, not repeats
            keys[d] = True
            last_seen[d] = now
        return
    if cmd.startswith("release:"):
        d = cmd[len("release:"):]
        if d in DIRS:
            keys[d] = False
            held_since.pop(d, None)
        return

    # Clicks
    if cmd == "press:lclick":
        ui.write(e.EV_KEY, e.BTN_LEFT, 1);  ui.syn()
    elif cmd == "release:lclick":
        ui.write(e.EV_KEY, e.BTN_LEFT, 0);  ui.syn()
    elif cmd == "press:rclick":
        ui.write(e.EV_KEY, e.BTN_RIGHT, 1); ui.syn()
    elif cmd == "release:rclick":
        ui.write(e.EV_KEY, e.BTN_RIGHT, 0); ui.syn()


while True:
    conn, _ = server.accept()
    cmd = conn.recv(64).decode().strip()
    conn.close()
    with lock:
        handle(cmd)
