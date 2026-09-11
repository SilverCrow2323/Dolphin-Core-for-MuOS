#!/bin/sh
# HELP: Toggle RTC ON - set RTC to ON
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : RTC
#    Real-time clock in movie playback
#
#  - State  : ON
#    Enables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/RTC/RTC ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : RTC"
echo "  State  : ON"
echo "  Effect : Real-time clock in movie playback"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/RTC.ini"
    echo "  [OK] RTC.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/RTC.ini" | sed 's/^/    /'
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
