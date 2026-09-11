#!/bin/sh
# HELP: Toggle OverlayStats OFF - set OverlayStats to OFF
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OverlayStats
#    Full on-screen statistics overlay
#
#  - State  : OFF
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OverlayStats/OverlayStats OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OverlayStats"
echo "  State  : OFF"
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
