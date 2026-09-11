#!/bin/sh
# HELP: Toggle NetPlayPing ON - set NetPlayPing to ON
# ICON: network
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : NetPlayPing
#    NetPlay ping display
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/NetPlayPing/NetPlayPing ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : NetPlayPing"
echo "  State  : ON"
echo "  Effect : NetPlay ping display"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/NetPlayPing.ini"
    echo "  [OK] NetPlayPing.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/NetPlayPing.ini" | sed 's/^/    /'
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
