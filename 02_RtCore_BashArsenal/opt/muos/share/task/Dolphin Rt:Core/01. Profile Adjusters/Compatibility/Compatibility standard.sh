#!/bin/sh
# HELP: Profile Compatibility - standard (factory restore)
# ICON: storage
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

FRONTEND stop
rt_log_init

CFG="/opt/muos/share/emulator/dolphin/Config"
PRESET="/opt/muos/share/emulator/dolphin/rtdata/profiles_preset"
PROFILE="compatibility"
LABEL="Compatibility standard"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Compatibility"
echo "  Level    : standard (factory restore)"
echo "==============================================="
echo ""

if [ ! -d "$PRESET" ]; then
    echo "  [ERR] Preset folder not found: $PRESET"
    rt_log_event "ADJUSTER" "$LABEL" "FAILED - preset folder missing"
    sleep 5
    FRONTEND start task
    exit 1
fi

rt_snapshot
rt_log_event "ADJUSTER" "$LABEL" "snapshot saved"

find_preset() {
    local base="$1"
    for cand in "$PRESET/$base.$PROFILE" "$PRESET/$PROFILE/$base" "$PRESET/$base"; do
        [ -f "$cand" ] && { echo "$cand"; return 0; }
    done
    return 1
}

RESTORED=0
FAILED=0

restore_one() {
    local base="$1"
    local src
    src=$(find_preset "$base")
    if [ -z "$src" ]; then
        echo "  [SKIP] No preset found for $base"
        rt_log_event "ADJUSTER" "$LABEL" "SKIP $base (no preset)"
        FAILED=$((FAILED + 1))
        return
    fi
    cp "$src" "$CFG/$base.$PROFILE"         && echo "  [OK]   $base.$PROFILE"         || FAILED=$((FAILED + 1))
    cp "$src" "$CFG/$base"         && echo "  [OK]   $base"         || FAILED=$((FAILED + 1))
    rt_log_event "ADJUSTER" "$LABEL" "$base <- $(basename "$src")"
    RESTORED=$((RESTORED + 1))
}

restore_one "Dolphin.ini"
restore_one "GFX.ini"

echo ""
echo "  Summary: $RESTORED/2 presets applied, $FAILED failures"
echo ""
rt_log_event "ADJUSTER" "$LABEL" "completed ($RESTORED/2 applied)"
rt_write_state "$LABEL"

sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
