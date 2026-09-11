#!/bin/sh
# HELP: Toggle InputDisplay OFF - set InputDisplay to OFF
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : InputDisplay
#    Controller input overlay
#
#  - State  : OFF
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/InputDisplay/InputDisplay OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : InputDisplay"
echo "  State  : OFF"
echo "  Effect : Controller input overlay"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/InputDisplay.ini"
    echo "  [OK] InputDisplay.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/InputDisplay.ini" | sed 's/^/    /'
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
