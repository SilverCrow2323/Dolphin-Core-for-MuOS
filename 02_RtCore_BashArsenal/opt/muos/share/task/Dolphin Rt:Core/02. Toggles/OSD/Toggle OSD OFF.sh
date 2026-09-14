#!/bin/sh
# HELP: Toggle OSD | State: OFF
# ICON: theme
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

FRONTEND stop
rt_log_init

CFG="/opt/muos/share/emulator/dolphin/Config"
FILES="Dolphin.ini Dolphin.ini.compatibility Dolphin.ini.performance Dolphin.ini.rintromping GFX.ini GFX.ini.compatibility GFX.ini.performance GFX.ini.rintromping"
KEY="OnScreenDisplayMessages"
VALUE="False"
SECTION="Interface"
LABEL="Toggle OSD OFF"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OSD"
echo "  State  : OFF"
echo "==============================================="
echo ""

OLD=$(rt_get_ini "$CFG/GFX.ini" "$KEY")
rt_snapshot

CHANGED=0
SKIPPED=0

for F in $FILES; do
    FILE="$CFG/$F"
    [ -f "$FILE" ] || { SKIPPED=$((SKIPPED+1)); continue; }
    rt_set_ini "$FILE" "$SECTION" "$KEY" "$VALUE"
    echo "  [OK]   $F"
    CHANGED=$((CHANGED+1))
done

echo ""
echo "  Files updated: $CHANGED"
echo "  Files skipped: $SKIPPED"
echo ""

rt_log_change "TOGGLE" "$LABEL" "all INIs" "$KEY" "$OLD" "$VALUE"
rt_log_event  "TOGGLE" "$LABEL" "updated $CHANGED files, skipped $SKIPPED"
rt_write_state "$LABEL"

sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
