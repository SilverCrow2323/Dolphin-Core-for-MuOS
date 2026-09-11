#!/bin/sh
# HELP: Enable Mods | Funzionalità: Attiva il sistema Graphics Mods | Descrizione: Imposta EnableGraphicsMods = True in GFX.ini. Necessario prima di installare qualsiasi mod. | ON: Mod attive | OFF (Default): Mod disattivate | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Se non lo attivi, le mod non funzioneranno. È come comprare un'auto e non mettere la benzina.
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : Enable Mods
#    Enable Mods | Funzionalità: Attiva il sistema Graphics Mods | Descrizione: Imposta EnableGraphicsMods = True in GFX.ini. Necessario prima di installare qualsiasi mod. | ON: Mod attive | OFF (Default): Mod disattivate | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Se non lo attivi, le mod non funzioneranno. È come comprare un'auto e non mettere la benzina.
#
. /opt/muos/script/var/func.sh
FRONTEND stop

GFX="/opt/muos/share/emulator/dolphin/Config/GFX.ini"
LOGDIR="/opt/muos/share/emulator/dolphin/rtdata/logs"
mkdir -p "$LOGDIR"
LOG="$LOGDIR/graphic_mods.log"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Enable Graphics Mods"
echo "==============================================="
echo ""

if [ ! -f "$GFX" ]; then
    echo "  [ERR] GFX.ini not found"
    sleep 5
    FRONTEND start task
    exit 1
fi

if grep -q "^EnableGraphicsMods" "$GFX"; then
    sed -i 's/^EnableGraphicsMods *=.*/EnableGraphicsMods = True/' "$GFX"
else
    sed -i '/^\[Settings\]/a EnableGraphicsMods = True' "$GFX"
fi

echo "  [OK] EnableGraphicsMods = True"
echo "[$(date '+%F %T')] EnableGraphicsMods = True" >> "$LOG"
echo ""
sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
