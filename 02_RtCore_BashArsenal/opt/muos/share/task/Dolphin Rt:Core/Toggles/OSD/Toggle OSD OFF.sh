#!/bin/sh
# HELP: Toggle OSD OFF - set OSD to OFF
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OSD
#    In-game on-screen messages
#
#  - State  : OFF
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OSD/OSD OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OSD"
echo "  State  : OFF"
echo "  Effect : In-game on-screen messages"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OSD.ini"
    echo "  [OK] OSD.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/OSD.ini" | sed 's/^/    /'
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
