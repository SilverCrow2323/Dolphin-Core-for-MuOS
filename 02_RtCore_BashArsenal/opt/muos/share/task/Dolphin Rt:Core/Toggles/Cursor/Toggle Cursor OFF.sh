#!/bin/sh
# HELP: Toggle Cursor OFF - set Cursor to OFF
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : Cursor
#    Mouse cursor visibility in-game
#
#  - State  : OFF
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/Cursor/Cursor OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : Cursor"
echo "  State  : OFF"
echo "  Effect : Mouse cursor visibility in-game"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/Cursor.ini"
    echo "  [OK] Cursor.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/Cursor.ini" | sed 's/^/    /'
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
