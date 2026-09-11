#!/bin/sh
# HELP: Toggle OverlayProjStats | Overlay con statistiche di proiezione | Funzionalità: Projection statistics overlay | Descrizione: Mostra metriche relative alla proiezione e al rendering geometrico. | ON: Overlay attivo | OFF (Default): Overlay non attivo | Risorse: Impatto moderato | Downside: Può ridurre le prestazioni | MINORU's Quick Lesson: Se non stai debuggando il renderer, non ti serve. Punto. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OverlayProjStats
#     Funzionalità: Projection statistics overlay | Descrizione: Mostra metriche relative alla proiezione e al rendering geometrico. | ON: Overlay attivo | OFF (Default): Overlay non attivo | Risorse: Impatto moderato | Downside: Può ridurre le prestazioni | MINORU's Quick Lesson: Se non stai debuggando il renderer, non ti serve. Punto.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OverlayProjStats/OverlayProjStats OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OverlayProjStats"
echo "  State  : OFF"
echo "  Effect : Projection statistics overlay"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OverlayProjStats.ini"
    echo "  [OK] OverlayProjStats.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/OverlayProjStats.ini" | sed 's/^/    /'
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
