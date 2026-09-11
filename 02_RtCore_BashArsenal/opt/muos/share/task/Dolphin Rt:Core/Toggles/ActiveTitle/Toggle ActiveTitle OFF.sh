#!/bin/sh
# HELP: Toggle ActiveTitle OFF - set ActiveTitle to OFF
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : ActiveTitle
#    Running game title shown in the window header
#
#  - State  : OFF
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/ActiveTitle/ActiveTitle OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : ActiveTitle"
echo "  State  : OFF"
echo "  Effect : Running game title shown in window"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/ActiveTitle.ini"
    echo "  [OK] ActiveTitle.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/ActiveTitle.ini" | sed 's/^/    /'
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
