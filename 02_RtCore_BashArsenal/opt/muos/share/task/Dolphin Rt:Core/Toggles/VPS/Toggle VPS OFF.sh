#!/bin/sh
# HELP: Toggle VPS OFF - set VPS to OFF
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : VPS
#    Vertical sync rate overlay
#
#  - State  : OFF
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/VPS/VPS OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : VPS"
echo "  State  : OFF"
echo "  Effect : Vertical sync rate display"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/VPS.ini"
    echo "  [OK] VPS.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/VPS.ini" | sed 's/^/    /'
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
