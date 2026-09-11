#!/bin/sh
# HELP: Toggle OverlayStats | Overlay completo con statistiche di gioco | Funzionalità: Full statistics overlay | Descrizione: Mostra un overlay dettagliato con FPS, VPS, speed, utilization, e altre metriche. | ON: Overlay completo | OFF (Default): Overlay non attivo | Risorse: Impatto moderato | Downside: Può ridurre le prestazioni se lasciato attivo | MINORU's Quick Lesson: È il pannello di controllo della NASA. Usalo per diagnosticare, non per giocare. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OverlayStats
#     Funzionalità: Full statistics overlay | Descrizione: Mostra un overlay dettagliato con FPS, VPS, speed, utilization, e altre metriche. | ON: Overlay completo | OFF (Default): Overlay non attivo | Risorse: Impatto moderato | Downside: Può ridurre le prestazioni se lasciato attivo | MINORU's Quick Lesson: È il pannello di controllo della NASA. Usalo per diagnosticare, non per giocare.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OverlayStats/OverlayStats OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OverlayStats"
echo "  State  : OFF"
echo "  Effect : Full on-screen statistics overlay"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OverlayStats.ini"
    echo "  [OK] OverlayStats.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/OverlayStats.ini" | sed 's/^/    /'
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
