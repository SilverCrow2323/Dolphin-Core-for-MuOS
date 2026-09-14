#!/bin/sh
# HELP: View Last State | Snapshot of current INI values.
# ICON: diagnostic
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"
FRONTEND stop
rt_log_init
clear
echo "==============================================="
echo "  Dolphin Rt:Core - Current State"
echo "==============================================="
echo ""
if [ -f "$RT_STATE" ]; then
    cat "$RT_STATE"
else
    echo "  last_state.txt not found."
fi
echo ""
echo "==============================================="
echo "  Closing in 10 seconds..."
echo "==============================================="
sleep 10
FRONTEND start task
exit 0
