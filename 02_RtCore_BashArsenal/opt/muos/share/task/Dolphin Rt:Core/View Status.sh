#!/bin/sh
# HELP: Show current state of profiles, toggles and Graphic Mods
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  Displays a full snapshot of the current Dolphin Rt:Core state:
#
#    - Active profile   (Compatibility / Performance / MaxRintromping)
#    - Applied level    (MIN, -2, -1, standard, +1, +2, MAX)
#    - Scouter value    (-3 .. +3)
#    - Every runtime toggle (17 options, ON / OFF)
#    - Installed Graphic Mods
#    - Last session log filename
#
#  Reads from:
#    rtdata/logs/profiles/current.ini
#    rtdata/logs/overview.log
#
#  Duration on screen: 15 seconds


. /opt/muos/script/var/func.sh

FRONTEND stop

OVERVIEW="/opt/muos/share/emulator/dolphin/rtdata/logs/overview.log"

clear

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 'Bash Arsenal'"
echo "  SPDW Factory Lab / sirpips"
echo "==============================================="
echo ""

if [ -f "$OVERVIEW" ]; then
    cat "$OVERVIEW"
else
    echo "  overview.log not found at:"
    echo "  $OVERVIEW"
fi

echo ""
echo "==============================================="
echo "  Closing in 10 seconds..."
echo "==============================================="

sleep 10

FRONTEND start task
exit 0
