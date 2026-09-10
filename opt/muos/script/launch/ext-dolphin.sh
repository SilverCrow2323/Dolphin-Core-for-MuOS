#!/bin/bash
# ============================================================
#  Dolphin Rt:Core v11.0.0 'Light Arsenal'
#  SPDW Factory Lab / sirpips
#  muOS launch script - /opt/muos/script/launch/ext-dolphin.sh
# ============================================================

. /opt/muos/script/var/func.sh

NAME=$1
CORE=$2
ROM=$3

LOG_INFO "$0" 0 "Content Launch" "DETAIL"
LOG_INFO "$0" 0 "NAME" "$NAME"
LOG_INFO "$0" 0 "CORE" "$CORE"
LOG_INFO "$0" 0 "ROM" "$ROM"

NUMSTICKS=$(cat /opt/muos/device/config/board/stick)

HOME="$(GET_VAR "device" "board/home")"
export HOME

EMUDIR="/opt/muos/share/emulator/dolphin"
RTDIR="$EMUDIR/rtdata"
LOGDIR="$RTDIR/logs"
TASKDIR="/opt/muos/share/task/Dolphin Rt:Core"
WATCHER="$RTDIR/rt_joywatch.py"

# ------------------------------------------------------------
#  Calibration values (from rt_joywatch.py --calibrate)
# ------------------------------------------------------------
MENU_BTN="8,13"
START_BTN="7"

# ---------- SDL environment (official muOS helper) ----------
SETUP_SDL_ENVIRONMENT

SET_VAR "system" "foreground_process" "dolphin"

# ---------- Extract game metadata ----------
GAMEID="UNKNOWN"
GAMENAME="UNKNOWN"

if [ -f "$ROM" ]; then
    GAMEID=$(dd if="$ROM" bs=1 skip=0 count=6 2>/dev/null | tr -d '\0' | tr -cd '[:alnum:]')
    [ -z "$GAMEID" ] && GAMEID="UNKNOWN"

    GAMENAME=$(dd if="$ROM" bs=1 skip=32 count=64 2>/dev/null | tr -d '\0' | tr -cd '[:print:]' | sed 's/[[:space:]]*$//')
    [ -z "$GAMENAME" ] && GAMENAME="$(basename "$ROM" | sed 's/\.[^.]*$//')"
fi

# ---------- Log setup ----------
mkdir -p "$LOGDIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOGFILE="$LOGDIR/dolphinrtcore_${CORE}_${GAMEID}_${TIMESTAMP}.log"
REPORT="$LOGDIR/launcher_report.log"

# ---------- Session log ----------
{
    echo "Dolphin Rt:Core v11.0.0 'Light Arsenal'"
    echo "SPDW Factory Lab"
    echo "my name"
    echo "sirpips"
    echo "========================================"
    echo "Dolphin Launch Log"
    echo "Date: $(date)"
    echo "NAME: $NAME"
    echo "CORE: $CORE"
    echo "ROM: $ROM"
    echo "GAMEID: $GAMEID"
    echo "GAMENAME: $GAMENAME"
    echo "NUMSTICKS: $NUMSTICKS"
    echo "EMUDIR: $EMUDIR"
    echo "========================================"
} >> "$LOGFILE"

# ---------- Launcher report (overwritten each session) ----------
{
    echo "Dolphin Rt:Core v11.0.0 'Light Arsenal'"
    echo "SPDW Factory Lab / sirpips"
    echo "========================================"
    echo "Launcher Report - Last Session"
    echo "========================================"
    echo "Date        : $(date)"
    echo "Session log : $(basename "$LOGFILE")"
    echo "NAME        : $NAME"
    echo "CORE        : $CORE"
    echo "ROM         : $ROM"
    echo "GAMEID      : $GAMEID"
    echo "GAMENAME    : $GAMENAME"
    echo "NUMSTICKS   : $NUMSTICKS"
    echo "EMUDIR      : $EMUDIR"
    echo "========================================"
} > "$REPORT"

# ---------- Copy config profiles ----------
cd "$EMUDIR/Config" || exit 1

case ${CORE} in
	*compatibility*)
		cp Dolphin.ini.compatibility Dolphin.ini
		echo "Copied Dolphin.ini.compatibility -> Dolphin.ini" >> "$LOGFILE"
		;;
	*performance*)
		cp Dolphin.ini.performance Dolphin.ini
		echo "Copied Dolphin.ini.performance -> Dolphin.ini" >> "$LOGFILE"
		;;
	*rintromping*)
		cp Dolphin.ini.maxrintromping Dolphin.ini
		echo "Copied Dolphin.ini.maxrintromping -> Dolphin.ini" >> "$LOGFILE"
		;;
esac

case ${CORE} in
	*rintromping*)
		cp GFX.ini.maxrintromping GFX.ini
		echo "Copied GFX.ini.maxrintromping -> GFX.ini" >> "$LOGFILE"
		;;
	*performance*)
		cp GFX.ini.performance GFX.ini
		echo "Copied GFX.ini.performance -> GFX.ini" >> "$LOGFILE"
		;;
	*compatibility*)
		cp GFX.ini.compatibility GFX.ini
		echo "Copied GFX.ini.compatibility -> GFX.ini" >> "$LOGFILE"
		;;
esac

cp GCPadNew.ini.default GCPadNew.ini
cp WiimoteNew.ini.default WiimoteNew.ini
cp Logger.ini.default Logger.ini
cp Debug.ini.default Debug.ini
cp Hotkeys.ini.default Hotkeys.ini

echo "Pads and auxiliary configs copied" >> "$LOGFILE"

cd "$EMUDIR" || exit 1

# ---------- Launch gptokeyb (official muOS helper) ----------
GPTOKEYB "dolphin" "ext-dolphin"

# ============================================================
#  [LIVE MENU] Watcher - MENU + START -> Overlay Menu
#                       MENU alone    -> kill Dolphin
# ============================================================
LIVEMENU_WATCHER=""

if [ -f "$WATCHER" ]; then
    echo "[LiveMenu] Starting watcher (MENU=$MENU_BTN START=$START_BTN)" >> "$LOGFILE"
    python3 "$WATCHER" "$MENU_BTN" "$START_BTN" "$TASKDIR/Overlay Menu.py" \
        >> "$LOGFILE" 2>&1 &
    LIVEMENU_WATCHER=$!
else
    echo "[LiveMenu] Watcher not found: $WATCHER" >> "$LOGFILE"
fi
# ============================================================

# ---------- Run Dolphin ----------
echo "Starting Dolphin: $(date)" >> "$LOGFILE"
"./dolphin" -e "$ROM" -u "$EMUDIR" >> "$LOGFILE" 2>&1
EXIT_CODE=$?
echo "Dolphin exited with code $EXIT_CODE: $(date)" >> "$LOGFILE"

# ============================================================
#  [LIVE MENU] Stop watcher
# ============================================================
if [ -n "$LIVEMENU_WATCHER" ]; then
    kill -9 "$LIVEMENU_WATCHER" 2>/dev/null
    pkill -P "$LIVEMENU_WATCHER" 2>/dev/null
    echo "[LiveMenu] Watcher stopped" >> "$LOGFILE"
fi
# ============================================================

# launch.sh will kill gptokeyb/gptokeyb2, restore governor, framebuffer, etc.
CONTENT_UNSET
