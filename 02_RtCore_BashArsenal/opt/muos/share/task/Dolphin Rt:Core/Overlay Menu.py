#!/usr/bin/env python3
"""
Dolphin Rt:Core v11.0.0 'Bash Arsenal'
Overlay Menu - in-game TUI for Dolphin on muOS
SPDW Factory Lab / sirpips

Features:
  - Save / Load state slots 1-3
  - Reset game
  - Exit to frontend (SIGTERM)
  - Close emulator (SIGKILL)
  - Pauses Dolphin while menu is open
  - Uses gptokeyb2 for gamepad -> keyboard mapping
  - Uses rt_keyinject.py for hotkey injection via uinput
  - Logs every action to rtdata/logs/live_menu.log
"""

import os
import sys
import time
import signal
import subprocess
import curses

# ============================================================
#  Paths
# ============================================================
EMUDIR     = "/opt/muos/share/emulator/dolphin"
RTDIR      = os.path.join(EMUDIR, "rtdata")
LOGDIR     = os.path.join(RTDIR, "logs")
LOG        = os.path.join(LOGDIR, "live_menu.log")
INJECT     = os.path.join(RTDIR, "rt_keyinject.py")

GPTKDIR    = "/opt/muos/share/emulator/gptokeyb"
MENU_GPTK  = os.path.join(GPTKDIR, "live_menu.gptk")
DOLPHIN_GPTK = os.path.join(GPTKDIR, "ext-dolphin.gptk")

GPTBIN     = "/mnt/mmc/MUOS/PortMaster/gptokeyb2"
GPTLIB     = "/mnt/mmc/MUOS/PortMaster/libinterpose.aarch64.so"
GPTLIB_DST = "/usr/lib/libinterpose.aarch64.so"

os.makedirs(LOGDIR, exist_ok=True)


# ============================================================
#  State
# ============================================================
class State:
    dolphin_pid = None
    menu_proc   = None
    paused      = False
    cleaned     = False


# ============================================================
#  Logging
# ============================================================
def log(msg):
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    try:
        with open(LOG, "a") as f:
            f.write(f"[{ts}] {msg}\n")
    except Exception:
        pass


# ============================================================
#  Helpers
# ============================================================
def find_dolphin():
    try:
        out = subprocess.check_output(["pidof", "dolphin"], text=True).strip()
        return int(out.split()[0]) if out else None
    except Exception:
        return None


def kill_gptk(name):
    subprocess.call(["pkill", "-9", "-f", f"gptokeyb2 {name}"])


def ensure_gptk_lib():
    """Symlink libinterpose.aarch64.so into /usr/lib if missing."""
    try:
        if os.path.exists(GPTLIB) and not os.path.exists(GPTLIB_DST):
            os.symlink(GPTLIB, GPTLIB_DST)
            log(f"symlinked {GPTLIB} -> {GPTLIB_DST}")
    except Exception as e:
        log(f"libinterpose symlink failed: {e}")


def start_gptk(name, cfg):
    """Start gptokeyb2 in background. Returns Popen or None."""
    ensure_gptk_lib()
    try:
        proc = subprocess.Popen(
            [GPTBIN, name, "-c", cfg],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return proc
    except Exception as e:
        log(f"start_gptk({name}) failed: {e}")
        return None


def send_signal(pid, sig):
    if pid is None:
        return
    try:
        os.kill(pid, sig)
    except Exception:
        pass


def inject(*keys):
    """Call rt_keyinject.py with the given key names."""
    try:
        subprocess.call(["python3", INJECT, *keys])
        log(f"inject: {' '.join(keys)}")
    except Exception as e:
        log(f"inject failed: {e}")


def resume_short():
    """Resume Dolphin just long enough for an injected hotkey to register."""
    if State.paused and State.dolphin_pid:
        send_signal(State.dolphin_pid, signal.SIGCONT)
        State.paused = False
        time.sleep(0.3)


def pause_again():
    """Pause Dolphin again after the hotkey was sent."""
    if not State.paused and State.dolphin_pid:
        send_signal(State.dolphin_pid, signal.SIGSTOP)
        State.paused = True
        time.sleep(0.1)


# ============================================================
#  Cleanup
# ============================================================
def cleanup():
    """Idempotent: kills menu gptokeyb, resumes Dolphin, restarts Dolphin gptokeyb."""
    if State.cleaned:
        return
    State.cleaned = True
    log("cleanup starting")

    if State.menu_proc is not None:
        try:
            State.menu_proc.kill()
            log("menu gptokeyb killed")
        except Exception:
            pass

    if State.paused and State.dolphin_pid:
        if os.path.exists(f"/proc/{State.dolphin_pid}"):
            send_signal(State.dolphin_pid, signal.SIGCONT)
            log("dolphin resumed")

    if State.dolphin_pid and os.path.exists(f"/proc/{State.dolphin_pid}"):
        if os.path.exists(GPTBIN) and os.path.exists(DOLPHIN_GPTK):
            start_gptk("dolphin", DOLPHIN_GPTK)
            log("dolphin gptokeyb restarted")

    log("cleanup done")


# ============================================================
#  Curses UI
# ============================================================
TITLE = "Dolphin Rt:Core v11.0.0 'Bash Arsenal'"
SUB   = "SPDW Factory Lab / sirpips"

# (label, keys for rt_keyinject, action_id)
MENU = [
    ("Save State   ->  Slot 1",       ("SHIFT", "F1"),  "inject"),
    ("Save State   ->  Slot 2",       ("SHIFT", "F2"),  "inject"),
    ("Save State   ->  Slot 3",       ("SHIFT", "F3"),  "inject"),
    ("Load State   <-  Slot 1",       ("F1",),          "inject"),
    ("Load State   <-  Slot 2",       ("F2",),          "inject"),
    ("Load State   <-  Slot 3",       ("F3",),          "inject"),
    ("Reset Game",                    ("SHIFT", "F5"),  "inject"),
    ("Exit to Frontend",              None,             "exit"),
    ("Close Emulator (force)",        None,             "kill"),
]


def draw(stdscr, selected):
    stdscr.erase()
    h, w = stdscr.getmaxyx()

    # Header
    try:
        stdscr.attron(curses.color_pair(1) | curses.A_BOLD)
        stdscr.addstr(1, max(0, (w - len(TITLE)) // 2), TITLE)
        stdscr.attroff(curses.color_pair(1) | curses.A_BOLD)

        stdscr.attron(curses.color_pair(2))
        stdscr.addstr(2, max(0, (w - len(SUB)) // 2), SUB)
        stdscr.attroff(curses.color_pair(2))
    except curses.error:
        pass

    # Divider
    try:
        stdscr.addstr(3, 2, "-" * (w - 4))
    except curses.error:
        pass

    # Menu items
    start_y = 5
    for i, (label, _, _) in enumerate(MENU):
        y = start_y + i
        if y >= h - 3:
            break
        try:
            if i == selected:
                stdscr.attron(curses.color_pair(3) | curses.A_BOLD)
                stdscr.addstr(y, 4, f" > {label}")
                stdscr.attroff(curses.color_pair(3) | curses.A_BOLD)
            else:
                stdscr.addstr(y, 4, f"   {label}")
        except curses.error:
            pass

    # Footer
    try:
        stdscr.addstr(h - 2, 2, "[D-Pad] Navigate   [A] Select   [B] Resume")
    except curses.error:
        pass

    stdscr.refresh()


def run_menu(stdscr):
    curses.curs_set(0)
    curses.start_color()
    curses.use_default_colors()

    try:
        curses.init_pair(1, curses.COLOR_CYAN,   -1)
        curses.init_pair(2, curses.COLOR_YELLOW, -1)
        curses.init_pair(3, curses.COLOR_BLACK,  curses.COLOR_CYAN)
    except Exception:
        pass

    stdscr.nodelay(False)
    stdscr.keypad(True)

    selected = 0
    while True:
        draw(stdscr, selected)

        try:
            key = stdscr.getch()
        except KeyboardInterrupt:
            return None

        if key in (curses.KEY_UP, ord('w'), ord('W')):
            selected = (selected - 1) % len(MENU)
        elif key in (curses.KEY_DOWN, ord('s'), ord('S')):
            selected = (selected + 1) % len(MENU)
        elif key in (curses.KEY_ENTER, 10, 13, ord(' ')):
            return selected
        elif key in (27, ord('q'), ord('Q')):  # ESC or q
            return None


# ============================================================
#  Main
# ============================================================
def main():
    log("=" * 50)
    log("Overlay Menu starting")

    # Preflight checks
    if not os.path.exists(INJECT):
        log(f"ERROR: missing {INJECT}")
        print(f"ERROR: missing {INJECT}")
        return 1
    if not os.path.exists(MENU_GPTK):
        log(f"ERROR: missing {MENU_GPTK}")
        print(f"ERROR: missing {MENU_GPTK}")
        return 1
    if not os.path.exists(GPTBIN):
        log(f"ERROR: missing {GPTBIN}")
        print(f"ERROR: missing {GPTBIN}")
        return 1

    # Find Dolphin
    pid = find_dolphin()
    if pid is None:
        log("Dolphin is not running - abort")
        print("Dolphin is not running.")
        time.sleep(2)
        return 0

    State.dolphin_pid = pid
    log(f"Dolphin pid={pid}")

    # Register cleanup on signals
    signal.signal(signal.SIGINT,  lambda *a: (cleanup(), sys.exit(0)))
    signal.signal(signal.SIGTERM, lambda *a: (cleanup(), sys.exit(0)))

    # Kill Dolphin's gptokeyb, start menu gptokeyb
    kill_gptk("dolphin")
    time.sleep(0.3)

    State.menu_proc = start_gptk("live_menu", MENU_GPTK)
    time.sleep(0.5)

    if State.menu_proc is None or State.menu_proc.poll() is not None:
        log("ERROR: menu gptokeyb failed to start")
        print("ERROR: menu gptokeyb failed to start.")
        cleanup()
        return 1

    log("menu gptokeyb started")

    # Pause Dolphin
    send_signal(State.dolphin_pid, signal.SIGSTOP)
    State.paused = True
    log("Dolphin paused (SIGSTOP)")

    # Show menu
    try:
        choice = curses.wrapper(run_menu)
    except Exception as e:
        log(f"curses error: {e}")
        choice = None

    # Handle cancel
    if choice is None:
        log("menu cancelled - resuming")
        cleanup()
        return 0

    label, keys, action = MENU[choice]
    log(f"choice: {label}")

    # Handle actions
    if action == "exit":
        log("action: exit to frontend (SIGTERM)")
        if State.paused:
            send_signal(State.dolphin_pid, signal.SIGCONT)
            State.paused = False
        send_signal(State.dolphin_pid, signal.SIGTERM)
        State.dolphin_pid = None
        cleanup()
        return 0

    if action == "kill":
        log("action: close emulator (SIGKILL)")
        if State.paused:
            send_signal(State.dolphin_pid, signal.SIGCONT)
            State.paused = False
        send_signal(State.dolphin_pid, signal.SIGKILL)
        State.dolphin_pid = None
        cleanup()
        return 0

    if action == "inject" and keys:
        resume_short()
        inject(*keys)
        time.sleep(0.4)
        pause_again()

    # Normal loop exit - resume game
    cleanup()
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        log(f"FATAL: {e}")
        try:
            cleanup()
        except Exception:
            pass
        sys.exit(1)