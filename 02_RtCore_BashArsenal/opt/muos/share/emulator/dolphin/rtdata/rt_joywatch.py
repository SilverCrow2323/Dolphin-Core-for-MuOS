#!/usr/bin/env python3
"""
Dolphin Rt:Core - Joystick watcher
Watches /dev/input/js* for hotkey combos and launches actions.

Behavior:
  MENU + START  (simultaneous)  -> launch Overlay Menu
  MENU alone    (press+release) -> terminate Dolphin (exit to frontend)

MENU accepts a comma-separated list because some hardware reports the
MENU key as two distinct buttons (e.g. 8 and 13).

Usage:
  rt_joywatch.py --calibrate
  rt_joywatch.py <MENU_BTNS> <START_BTN> [SCRIPT] [--no-kill]
"""

import sys
import os
import glob
import time
import signal
import struct
import select
import subprocess

JS_EVENT_BUTTON = 0x01
JS_EVENT_INIT   = 0x80

DEFAULT_SCRIPT = "/opt/muos/share/task/Dolphin Rt:Core/Overlay Menu.sh"
KILL_GRACE     = 0.35   # seconds between MENU-down and MENU-alone-kill


def find_js():
    devs = sorted(glob.glob("/dev/input/js*"))
    return devs[0] if devs else None


def find_dolphin():
    try:
        out = subprocess.check_output(["pidof", "dolphin"], text=True).strip()
        return int(out.split()[0]) if out else None
    except Exception:
        return None


def calibrate(dev):
    print(f"[calibrate] Watching {dev}")
    print("[calibrate] Press each button once, note the number.")
    print("[calibrate] Ctrl-C to stop.\n")
    fd = os.open(dev, os.O_RDONLY | os.O_NONBLOCK)
    buf = b""
    last = {}
    try:
        while True:
            r, _, _ = select.select([fd], [], [], 1.0)
            if not r:
                continue
            buf += os.read(fd, 8 * 64)
            while len(buf) >= 8:
                _, val, typ, num = struct.unpack("IhBB", buf[:8])
                buf = buf[8:]
                if (typ & ~JS_EVENT_INIT) == JS_EVENT_BUTTON:
                    prev = last.get(num, -1)
                    if val == 1 and prev != 1:
                        print(f"[calibrate] BUTTON {num} pressed")
                    last[num] = val
    except KeyboardInterrupt:
        print("\n[calibrate] stopped")
    finally:
        os.close(fd)


def kill_dolphin():
    pid = find_dolphin()
    if pid is None:
        print("[watch] MENU alone -> Dolphin not running, nothing to kill")
        return
    print(f"[watch] MENU alone -> SIGTERM to Dolphin (pid={pid})")
    sys.stdout.flush()
    try:
        os.kill(pid, signal.SIGTERM)
    except Exception as e:
        print(f"[watch] kill failed: {e}")


def launch_menu(script):
    print(f"[watch] MENU+START -> launching {script}")
    sys.stdout.flush()
    subprocess.Popen(["sh", script])


def watch(dev, menu_btns, start_btn, script, kill_on_menu_alone=True):
    print(f"[watch] {dev}  menu={menu_btns}  start={start_btn}")
    print(f"[watch] script={script}  kill_on_menu_alone={kill_on_menu_alone}")
    sys.stdout.flush()

    fd = os.open(dev, os.O_RDONLY | os.O_NONBLOCK)
    buf = b""

    state = {}                    # button_num -> 0/1
    menu_press_time = 0.0
    menu_alone_armed = False      # MENU pressed, waiting for START or release
    menu_combined_fired = False   # START arrived during MENU press

    def menu_is_down():
        return any(state.get(b, 0) == 1 for b in menu_btns)

    try:
        while True:
            r, _, _ = select.select([fd], [], [], 1.0)
            if not r:
                continue
            buf += os.read(fd, 8 * 64)
            while len(buf) >= 8:
                _, val, typ, num = struct.unpack("IhBB", buf[:8])
                buf = buf[8:]
                if (typ & ~JS_EVENT_INIT) != JS_EVENT_BUTTON:
                    continue

                prev = state.get(num, 0)
                state[num] = val
                if val == prev:
                    continue

                is_menu  = num in menu_btns
                is_start = num == start_btn

                # --- MENU down ---
                if is_menu and val == 1:
                    # only arm once, when the first MENU button goes down
                    if not menu_alone_armed and not menu_combined_fired:
                        menu_alone_armed = True
                        menu_press_time = time.time()
                    continue

                # --- START down (while MENU is down) ---
                if is_start and val == 1 and menu_is_down():
                    if not menu_combined_fired:
                        menu_combined_fired = True
                        menu_alone_armed = False
                        launch_menu(script)
                    continue

                # --- MENU up (all menu buttons released) ---
                if is_menu and val == 0 and not menu_is_down():
                    if menu_alone_armed and not menu_combined_fired:
                        duration = time.time() - menu_press_time
                        if kill_on_menu_alone and duration <= 2.0:
                            kill_dolphin()
                    menu_alone_armed = False
                    menu_combined_fired = False
                    continue

    except KeyboardInterrupt:
        pass
    finally:
        os.close(fd)


def main():
    args = sys.argv[1:]

    if not args or args[0] == "--calibrate":
        dev = find_js()
        if not dev:
            print("ERROR: no /dev/input/js* found")
            sys.exit(1)
        calibrate(dev)
        return

    kill_flag = True
    if "--no-kill" in args:
        kill_flag = False
        args.remove("--no-kill")

    if len(args) < 2:
        print(__doc__)
        sys.exit(1)

    menu_btns = [int(x) for x in args[0].split(",") if x.strip()]
    start_btn = int(args[1])
    script = args[2] if len(args) > 2 else DEFAULT_SCRIPT

    dev = find_js()
    if not dev:
        print("ERROR: no /dev/input/js* found")
        sys.exit(1)

    watch(dev, menu_btns, start_btn, script, kill_flag)


if __name__ == "__main__":
    main()