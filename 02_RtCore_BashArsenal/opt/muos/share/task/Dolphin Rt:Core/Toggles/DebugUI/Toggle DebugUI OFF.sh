#!/bin/sh
# HELP: Toggle DebugUI OFF - set DebugUI to OFF
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : DebugUI
#    Dolphin debugging interface
#
#  - State  : OFF
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/DebugUI/DebugUI OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : DebugUI"
echo "  State  : OFF"
echo "  Effect : Dolphin debugging interface"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/DebugUI.ini"
    echo "  [OK] DebugUI.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/DebugUI.ini" | sed 's/^/    /'
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
