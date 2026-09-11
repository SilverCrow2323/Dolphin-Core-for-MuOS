#!/bin/sh
# HELP: Toggle ExtendedFPS ON - set ExtendedFPS to ON
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : ExtendedFPS
#    Extended FPS/VPS/Speed info in the interface
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/ExtendedFPS/ExtendedFPS ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : ExtendedFPS"
echo "  State  : ON"
echo "  Effect : Detailed FPS / VPS / Speed in the interface"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/ExtendedFPS.ini"
    echo "  [OK] ExtendedFPS.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/ExtendedFPS.ini" | sed 's/^/    /'
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
