#!/bin/sh
# HELP: View Logs | Shows the most recent session log. | Resources: None | Downside: None
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
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

SEL=$(ls -1t "$LOGDIR"/*.log 2>/dev/null | head -1)

if [ -z "$SEL" ]; then
    echo "  No log files found in:"
    echo "  $LOGDIR"
    sleep 5
    FRONTEND start task
    exit 0
fi

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
