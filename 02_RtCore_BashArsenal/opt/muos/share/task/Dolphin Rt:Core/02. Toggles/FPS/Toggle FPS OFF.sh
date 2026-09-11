#!/bin/sh
# HELP: Toggle FPS | Mostra il contatore FPS a schermo | Funzionalità: FPS counter overlay | Descrizione: Visualizza in tempo reale i frame al secondo renderizzati. Utile per valutare le prestazioni e capire se il gioco gira a 60, 30 o meno. | ON: Il contatore appare nell'angolo dello schermo | OFF (Default): Overlay non attivo | Risorse: Impatto minimo, qualche frame di CPU | Downside: Nessuno rilevante | MINORU's Quick Lesson: Se non lo tieni su almeno una volta per gioco, non saprai mai se stai giocando a 12 FPS e incolpando la ROM sbagliata. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : FPS
#     Funzionalità: FPS counter overlay | Descrizione: Visualizza in tempo reale i frame al secondo renderizzati. Utile per valutare le prestazioni e capire se il gioco gira a 60, 30 o meno. | ON: Il contatore appare nell'angolo dello schermo | OFF (Default): Overlay non attivo | Risorse: Impatto minimo, qualche frame di CPU | Downside: Nessuno rilevante | MINORU's Quick Lesson: Se non lo tieni su almeno una volta per gioco, non saprai mai se stai giocando a 12 FPS e incolpando la ROM sbagliata.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/FPS/FPS OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : FPS"
echo "  State  : OFF"
echo "  Effect : Frames-per-second counter on screen"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/FPS.ini"
    echo "  [OK] FPS.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/FPS.ini" | sed 's/^/    /'
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
