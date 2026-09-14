#!/bin/sh
# HELP: View History | Last 200 actions.
# ICON: diagnostic
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"
FRONTEND stop
rt_log_init
clear
echo "==============================================="
echo "  Dolphin Rt:Core - History (last 200 lines)"
echo "==============================================="
echo ""
if [ -f "$RT_HISTORY" ]; then
    tail -n 200 "$RT_HISTORY"
else
    echo "  history.log not found."
fi
echo ""
echo "==============================================="
echo "  Closing in 10 seconds..."
echo "==============================================="
sleep 10
FRONTEND start task
exit 0
