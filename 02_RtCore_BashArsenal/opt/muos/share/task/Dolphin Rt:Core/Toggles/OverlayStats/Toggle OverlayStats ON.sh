#!/bin/sh
# HELP: Toggle OverlayStats ON - set OverlayStats to ON
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OverlayStats
#    Full on-screen statistics overlay
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OverlayStats/OverlayStats ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OverlayStats"
echo "  State  : ON"
echo "  Effect : Full on-screen statistics overlay"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OverlayStats.ini"
    echo "  [OK] OverlayStats.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/OverlayStats.ini" | sed 's/^/    /'
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
