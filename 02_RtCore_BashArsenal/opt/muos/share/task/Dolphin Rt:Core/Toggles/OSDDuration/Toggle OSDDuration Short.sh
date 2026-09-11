#!/bin/sh
# HELP: Toggle OSDDuration Short - set OSDDuration to Short
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OSDDuration
#    Duration of on-screen messages (Short / Normal / Long)
#
#  - State  : Short
#    Disables the option
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OSDDuration/OSDDuration Short.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - OSD Duration"
echo "==============================================="
echo "  State : Short"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OSDDuration.ini"
    echo "  [OK] OSDDuration.ini updated"
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
