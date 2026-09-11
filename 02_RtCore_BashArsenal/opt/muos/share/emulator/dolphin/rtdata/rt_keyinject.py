#!/usr/bin/env python3
"""
Dolphin Rt:Core - Key Injector
Sends key combinations via /dev/uinput to the focused window.
No external dependencies.
"""

import os
import sys
import time
import struct
import fcntl

UINPUT = "/dev/uinput"

# ---- Linux input event codes ----
EV_SYN = 0x00
EV_KEY = 0x01
SYN_REPORT = 0

KEY_ESC        = 1
KEY_LEFTSHIFT  = 42
KEY_F1         = 59
KEY_F2         = 60
KEY_F3         = 61
KEY_F4         = 62
KEY_F5         = 63
KEY_F6         = 64
KEY_F7         = 65
KEY_F8         = 66
KEY_F9         = 67
KEY_F10        = 68

# ---- ioctl constants ----
UI_SET_EVBIT   = 0x40045564
UI_SET_KEYBIT  = 0x40045565
UI_DEV_CREATE  = 0x5501
UI_DEV_DESTROY = 0x5502

KEYMAP = {
    "ESC":   KEY_ESC,
    "SHIFT": KEY_LEFTSHIFT,
    "F1":    KEY_F1,
    "F2":    KEY_F2,
    "F3":    KEY_F3,
    "F4":    KEY_F4,
    "F5":    KEY_F5,
    "F6":    KEY_F6,
    "F7":    KEY_F7,
    "F8":    KEY_F8,
    "F9":    KEY_F9,
    "F10":   KEY_F10,
}


def emit(fd, ev_type, code, value):
    os.write(fd, struct.pack("llHHi", 0, 0, ev_type, code, value))


def send_combo(keys):
    fd = os.open(UINPUT, os.O_WRONLY | os.O_NONBLOCK)
    try:
        fcntl.ioctl(fd, UI_SET_EVBIT, EV_KEY)
        for code in keys:
            fcntl.ioctl(fd, UI_SET_KEYBIT, code)

        # struct uinput_user_dev: name[80] + input_id(4x u16) + ff_effects_max(u32)
        #                        + absmax[64] + absmin[64] + absfuzz[64] + absflat[64] (int32 each)
        name = b"rt_keyinject"
        dev = struct.pack("80sHHHHI", name, 0x03, 0x1234, 0x5678, 1, 0)
        dev += b"\x00" * (4 * 64 * 4)
        os.write(fd, dev)
        fcntl.ioctl(fd, UI_DEV_CREATE)
        time.sleep(0.15)

        for code in keys:
            emit(fd, EV_KEY, code, 1)
        emit(fd, EV_SYN, SYN_REPORT, 0)
        time.sleep(0.08)

        for code in reversed(keys):
            emit(fd, EV_KEY, code, 0)
        emit(fd, EV_SYN, SYN_REPORT, 0)
        time.sleep(0.05)
    finally:
        try:
            fcntl.ioctl(fd, UI_DEV_DESTROY)
        except Exception:
            pass
        os.close(fd)


def main():
    if len(sys.argv) < 2:
        print("Usage: rt_keyinject.py KEY [KEY2 ...]")
        print("Keys : " + ", ".join(KEYMAP.keys()))
        sys.exit(1)

    codes = []
    for arg in sys.argv[1:]:
        k = arg.upper()
        if k not in KEYMAP:
            print(f"Unknown key: {k}")
            sys.exit(2)
        codes.append(KEYMAP[k])

    send_combo(codes)


if __name__ == "__main__":
    main()