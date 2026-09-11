#!/bin/sh
# HELP: Toggle OverlayProjStats ON - set OverlayProjStats to ON
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OverlayProjStats
#    Projection statistics overlay
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OverlayProjStats/OverlayProjStats ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OverlayProjStats"
echo "  State  : ON"
echo "  Effect : Projection statistics overlay"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OverlayProjStats.ini"
    echo "  [OK] OverlayProjStats.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/OverlayProjStats.ini" | sed 's/^/    /'
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
