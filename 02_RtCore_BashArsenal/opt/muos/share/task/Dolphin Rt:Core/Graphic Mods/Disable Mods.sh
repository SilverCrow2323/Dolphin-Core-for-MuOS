#!/bin/sh
# HELP: Deactivate the Graphics Mods system
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool 002 : DISABLE GRAPHICS MODS
#    Sets EnableGraphicsMods = False in Config/GFX.ini.
#    Installed mods remain on disk but are ignored.


. /opt/muos/script/var/func.sh
FRONTEND stop

GFX="/opt/muos/share/emulator/dolphin/Config/GFX.ini"
LOGDIR="/opt/muos/share/emulator/dolphin/rtdata/logs"
mkdir -p "$LOGDIR"
LOG="$LOGDIR/graphic_mods.log"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Disable Graphics Mods"
echo "==============================================="
echo ""

if [ ! -f "$GFX" ]; then
    echo "  [ERR] GFX.ini not found"
    sleep 5
    FRONTEND start task
    exit 1
fi

if grep -q "^EnableGraphicsMods" "$GFX"; then
    sed -i 's/^EnableGraphicsMods *=.*/EnableGraphicsMods = False/' "$GFX"
else
    sed -i '/^\[Settings\]/a EnableGraphicsMods = False' "$GFX"
fi

echo "  [OK] EnableGraphicsMods = False"
echo "[$(date '+%F %T')] EnableGraphicsMods = False" >> "$LOG"
echo ""
sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
