#!/bin/sh
# HELP: Toggle FrameCount ON - set FrameCount to ON
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : FrameCount
#    Frame counter
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/FrameCount/FrameCount ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : FrameCount"
echo "  State  : ON"
echo "  Effect : Frame counter"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/FrameCount.ini"
    echo "  [OK] FrameCount.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/FrameCount.ini" | sed 's/^/    /'
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
