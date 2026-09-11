#!/bin/sh
# HELP: Toggle FrameTimes ON - set FrameTimes to ON
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : FrameTimes
#    Frame render time logging and overlay statistics
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/FrameTimes/FrameTimes ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : FrameTimes"
echo "  State  : ON"
echo "  Effect : Log render times and show overlay stats"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/FrameTimes.ini"
    echo "  [OK] FrameTimes.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/FrameTimes.ini" | sed 's/^/    /'
else
    echo "  [ERR] Source file missing in $SRC"
fi

echo ""
echo "  Sync Filesystem"
sync

echo "All Done!"
sleep 5

FRONTEND start task
exit 0
