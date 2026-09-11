#!/bin/sh
# HELP: View Logs | Funzionalità: Visualizza i log delle sessioni | Descrizione: Mostra il contenuto del log più recente. | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Se qualcosa va storto, il log te lo dirà. Se non lo leggi, non lamentarti.
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : View Logs
#    View Logs | Funzionalità: Visualizza i log delle sessioni | Descrizione: Mostra il contenuto del log più recente. | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Se qualcosa va storto, il log te lo dirà. Se non lo leggi, non lamentarti.
#
. /opt/muos/script/var/func.sh

FRONTEND stop

LOGDIR="/opt/muos/share/emulator/dolphin/rtdata/logs"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 'Bash Arsenal'"
echo "  SPDW Factory Lab / sirpips"
echo "==============================================="
echo "  View Logs"
echo "==============================================="
echo ""

if [ ! -d "$LOGDIR" ]; then
    echo "  Log folder not found: $LOGDIR"
    sleep 5
    FRONTEND start task
    exit 1
fi

ITEMS=""
i=1
for f in $(ls -1t "$LOGDIR"/*.log 2>/dev/null | head -20); do
    name=$(basename "$f")
    ITEMS="$ITEMS \"$i\" \"$name\""
    eval "LOG_$i=\"$f\""
    i=$((i + 1))
done

if [ -z "$ITEMS" ]; then
    echo "  No log files found in:"
    echo "  $LOGDIR"
    sleep 5
    FRONTEND start task
    exit 0
fi

CHOICE=$(eval whiptail \
    --title "Dolphin Rt:Core - View Logs" \
    --cancel-button "Back" \
    --menu "\"\nPick a log file to read:\n\"" 20 70 12 \
    $ITEMS \
    3>&1 1>&2 2>&3)

RET=$?
if [ "$RET" -ne 0 ] || [ -z "$CHOICE" ]; then
    FRONTEND start task
    exit 0
fi

eval "SEL=\$LOG_$CHOICE"

clear
echo "==============================================="
echo "  Reading: $(basename "$SEL")"
echo "==============================================="
echo ""
cat "$SEL"
echo ""
echo "==============================================="
echo "  End of file - closing in 10 seconds"
echo "==============================================="

sleep 10
FRONTEND start task
exit 0