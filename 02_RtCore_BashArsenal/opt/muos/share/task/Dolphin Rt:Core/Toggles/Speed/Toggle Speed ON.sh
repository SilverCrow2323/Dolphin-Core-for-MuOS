#!/bin/sh
# HELP: Toggle Speed ON - set Speed to ON
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : Speed
#    Emulation speed percentage overlay
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/Speed/Speed ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : Speed"
echo "  State  : ON"
echo "  Effect : Emulation speed percentage display"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/Speed.ini"
    echo "  [OK] Speed.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/Speed.ini" | sed 's/^/    /'
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
