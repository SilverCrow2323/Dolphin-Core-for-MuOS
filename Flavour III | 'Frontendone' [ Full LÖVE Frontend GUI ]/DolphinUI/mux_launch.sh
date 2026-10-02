#!/bin/sh
# HELP: DolphinUI
# ICON: logo_dolphinui
# GRID: DolphinUI
#
# CWD strategy: the script cds into frontend/ (the LÖVE game directory)
# and launches the binary with "." as the game argument. This way every
# path in the Lua code is relative to frontend/, and LÖVE's sandbox
# resolves assets/, data/, workshop/, dolphin-emu/, hb/, scripts/ all
# in the same place. No symlinks needed.
#
# muOS volume OSD:
#   When the volume OSD daemon fires, it takes over the framebuffer and
#   LÖVE's render loop freezes (visible symptom: the screen shows the
#   last theme color and no input is accepted). We suspend the OSD
#   daemon for the entire LÖVE session with SIGSTOP, then resume it with
#   SIGCONT in the cleanup. This is fully reversible, needs no daemon
#   kill, and works even when the daemon has been renamed between muOS
#   releases (pkill falls through silently).

. /opt/muos/script/var/func.sh

# ── 1. Base paths ───────────────────────────────────────────
DIR="$(cd "$(dirname "$0")" && pwd)"

APP_NAME="DolphinUI"
APP_SUBPATH="application/$APP_NAME"
APP_DIRECTORY="$MUOS_SHARE_DIR/$APP_SUBPATH"
[ -d "$APP_DIRECTORY" ] || APP_DIRECTORY="$MUOS_STORE_DIR/$APP_SUBPATH"
[ -d "$APP_DIRECTORY" ] || APP_DIRECTORY="$DIR"

GAME_DIR="$APP_DIRECTORY/frontend"
APP_BINARY_DIRECTORY="$APP_DIRECTORY/lib"
LOVE_BINARY="$APP_BINARY_DIRECTORY/love"

LOG_DIR="$GAME_DIR/data/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/dolphinui.log"

ROM_MOUNT="$(GET_VAR "device" "storage/rom/mount" 2>/dev/null || echo "/mnt/mmc")"
SCREEN_WIDTH="$(GET_VAR device mux/width 2>/dev/null || echo "640")"
SCREEN_HEIGHT="$(GET_VAR device mux/height 2>/dev/null || echo "480")"
SCREEN_RESOLUTION="${SCREEN_WIDTH}x${SCREEN_HEIGHT}"
CAFFEINE="$(command -v CAFFEINE 2>/dev/null || true)"

chmod +x "$LOVE_BINARY" 2>/dev/null
# Copying to FAT32 / extracting the archive can drop the exec bit, and a
# non-executable launch_game.sh means "press A and nothing happens".
find "$GAME_DIR/scripts" -name '*.sh' -exec chmod +x {} \; 2>/dev/null

STOP_MUSIC() {
    killall -q "playbgm.sh" "mpg123" 2>/dev/null || true
}

# ── muOS OSD handling ───────────────────────────────────────
# The volume OSD is drawn by one of several muOS daemons. The exact
# name has changed between muOS releases, so we try a list. All
# invocations are harmless when nothing matches.
OSD_DAEMONS="muos_osd mux_osd muos_hotkey muos_hotkeys muos_volume muos-vol muos_osd.py"

PAUSE_MUOS_OSD() {
    for P in $OSD_DAEMONS; do
        pkill -STOP -x "$P" 2>/dev/null || true
    done
}

RESUME_MUOS_OSD() {
    for P in $OSD_DAEMONS; do
        pkill -CONT -x "$P" 2>/dev/null || true
    done
}

# Trap ensures the OSD is resumed even if the shell is killed mid-run.
trap 'RESUME_MUOS_OSD' EXIT INT TERM

SET_LOVE_ENVIRONMENT() {
    # Native muOS gamepad database mapping for SDL2 (Replaces gptokeyb2)
    export SDL_GAMECONTROLLERCONFIG_FILE="/usr/lib/gamecontrollerdb.txt"
    export XDG_DATA_HOME="$GAME_DIR/data"
    export HOME="$GAME_DIR/data"
    export LD_LIBRARY_PATH="$APP_BINARY_DIRECTORY${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
}

SET_RK3576_WORKAROUND() {
    grep -q "rk3576" /proc/device-tree/compatible 2>/dev/null || return 0

    for MALI_LIBRARY in /usr/lib/libmali.so /usr/lib/aarch64-linux-gnu/libmali.so; do
        if [ -e "$MALI_LIBRARY" ]; then
            export SDL_VIDEO_EGL_DRIVER="$MALI_LIBRARY"
            break
        fi
    done

    export SDL_OPENGL_ES_DRIVER=1
}

START_LOVE() {
    [ -n "$CAFFEINE" ] && "$CAFFEINE" on
    SET_VAR "system" "foreground_process" "love" 2>/dev/null

    # Suspend the muOS volume OSD for the whole LÖVE session.
    # See the top-of-file note for why this is necessary.
    PAUSE_MUOS_OSD

    # CWD = frontend/ (game dir). LÖVE sandbox rooted here.
    cd "$GAME_DIR" || exit 1
    "$LOVE_BINARY" . "$SCREEN_RESOLUTION" > "$LOG_FILE" 2>&1

    # Resume the OSD daemon immediately after LÖVE exits. The EXIT trap
    # is a safety net in case this line is skipped.
    RESUME_MUOS_OSD

    [ -n "$CAFFEINE" ] && "$CAFFEINE" off
}

# ── 2. Launch ───────────────────────────────────────────────
# Check for SETUP_APP (muOS Jacaranda or newer)
if command -v SETUP_APP >/dev/null 2>&1; then
    # --- Jacaranda logic ---
    SETUP_STAGE_OVERLAY 2>/dev/null || true
    APP_BIN="lib/love"
    SETUP_APP "love" "$APP_BIN"

    SET_LOVE_ENVIRONMENT
    SET_RK3576_WORKAROUND
    START_LOVE

else
    # --- Legacy logic (Loose Goose / older muOS) ---
    STOP_MUSIC

    echo app >/tmp/act_go

    type SETUP_SDL_ENVIRONMENT &>/dev/null && SETUP_SDL_ENVIRONMENT
    SET_LOVE_ENVIRONMENT

    # Mirror glyphs (legacy requirement)
    PRIMARY_APP_DIRECTORY="$ROM_MOUNT/MUOS/application"
    CURRENT_APP_DIRECTORY="$APP_DIRECTORY"
    SOURCE_GLYPH_DIRECTORY="$CURRENT_APP_DIRECTORY/glyph"
    DESTINATION_APP_DIRECTORY="$PRIMARY_APP_DIRECTORY/$APP_NAME"
    DESTINATION_GLYPH_DIRECTORY="$DESTINATION_APP_DIRECTORY/glyph"

    case "$CURRENT_APP_DIRECTORY/" in
    "$PRIMARY_APP_DIRECTORY"/*) : ;;
    *)
        if [ -d "$SOURCE_GLYPH_DIRECTORY" ]; then
            mkdir -p "$DESTINATION_GLYPH_DIRECTORY" 2>/dev/null || true
            cp -rf "$SOURCE_GLYPH_DIRECTORY"/. "$DESTINATION_GLYPH_DIRECTORY"/ 2>/dev/null || true
        fi
        ;;
    esac

    SET_RK3576_WORKAROUND
    START_LOVE
fi

# Cleanup: always tell muOS we're done
type CONTENT_UNSET >/dev/null 2>&1 && CONTENT_UNSET

exit 0