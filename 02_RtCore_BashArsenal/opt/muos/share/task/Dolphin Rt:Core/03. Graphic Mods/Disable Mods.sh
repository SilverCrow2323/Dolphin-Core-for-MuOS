#!/bin/sh
# HELP: Disable Mods | Funzionalità: Disattiva il sistema Graphics Mods | Descrizione: Imposta EnableGraphicsMods = False in GFX.ini. Le mod restano su disco ma vengono ignorate. | ON: Mod disattivate | OFF (Default): Mod attive se abilitate | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Utile se una mod causa problemi e vuoi disattivarle tutte senza cancellarle.
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : Disable Mods
#    Disable Mods | Funzionalità: Disattiva il sistema Graphics Mods | Descrizione: Imposta EnableGraphicsMods = False in GFX.ini. Le mod restano su disco ma vengono ignorate. | ON: Mod disattivate | OFF (Default): Mod attive se abilitate | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Utile se una mod causa problemi e vuoi disattivarle tutte senza cancellarle.
#
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
