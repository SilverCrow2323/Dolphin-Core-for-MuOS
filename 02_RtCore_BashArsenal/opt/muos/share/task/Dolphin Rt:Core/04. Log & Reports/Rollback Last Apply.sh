#!/bin/sh
# HELP: Rollback Last Apply | Restore Config/ from last snapshot.
# ICON: diagnostic
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"
FRONTEND stop
rt_log_init
clear
echo "==============================================="
echo "  Dolphin Rt:Core - Rollback"
echo "==============================================="
echo ""
if [ ! -d "$RT_ROLLBACK" ] || [ -z "$(ls -A "$RT_ROLLBACK" 2>/dev/null)" ]; then
    echo "  No rollback snapshot found."
    echo "  Nothing to restore."
    echo ""
    echo "  Closing in 10 seconds..."
    sleep 10
    FRONTEND start task
    exit 0
fi
echo "  Restoring files from last snapshot..."
echo ""
N=$(rt_rollback)
echo "  [OK] Restored $N files."
rt_log_event "TOOL" "Rollback Last Apply" "restored $N files"
rt_write_state "Rollback Last Apply"
echo ""
sync
echo "All Done!"
sleep 10
FRONTEND start task
exit 0
