#!/bin/sh
# HELP: View Status | Funzionalità: Mostra lo stato attuale | Descrizione: Visualizza profilo attivo, livello, toggle e mod installate. | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Se non sai cosa sta succedendo, guarda qui.
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : View Status
#    View Status | Funzionalità: Mostra lo stato attuale | Descrizione: Visualizza profilo attivo, livello, toggle e mod installate. | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Se non sai cosa sta succedendo, guarda qui.
#
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
