#!/bin/sh
# HELP: Profile Compatibility - +1
# ICON: storage
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

FRONTEND stop
rt_log_init

CFG="/opt/muos/share/emulator/dolphin/Config"
PROFILE="compatibility"
LABEL="Compatibility +1"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Compatibility"
echo "  Level    : +1"
echo "==============================================="
echo ""

rt_snapshot
rt_log_event "ADJUSTER" "$LABEL" "snapshot saved"

apply_ini() {
    local file="$1" section="$2" key="$3" value="$4" ref="$5"
    [ -f "$file" ] || return 1
    local old
    old=$(rt_get_ini "$file" "$key")
    rt_set_ini "$file" "$section" "$key" "$value"
    rt_log_change "ADJUSTER" "$LABEL" "$ref" "$key" "$old" "$value"
}

for F in "Dolphin.ini.$PROFILE" "Dolphin.ini"; do
    FILE="$CFG/$F"
    [ -f "$FILE" ] || { echo "  [SKIP] $F"; continue; }
    apply_ini "$FILE" "Core" "Overclock"          "0.90"   "$F"
    apply_ini "$FILE" "Core" "TimingVariance"     "45"   "$F"
    apply_ini "$FILE" "Core" "EnableIdleSkipping" "True" "$F"
    apply_ini "$FILE" "Core" "SyncGPU"            "False" "$F"
    echo "  [OK]   $F"
done

for F in "GFX.ini.$PROFILE" "GFX.ini"; do
    FILE="$CFG/$F"
    [ -f "$FILE" ] || { echo "  [SKIP] $F"; continue; }
    apply_ini "$FILE" "Settings" "InternalResolution" "1"   "$F"
    apply_ini "$FILE" "Hacks"    "DisableFog"         "True"  "$F"
    apply_ini "$FILE" "Hacks"    "FastDepthCalc"      "True"   "$F"
    apply_ini "$FILE" "Hacks"    "EFBToTextureEnable" "True" "$F"
    apply_ini "$FILE" "Hacks"    "SkipEFBCopyToRam"   "True" "$F"
    apply_ini "$FILE" "Hacks"    "DeferEFBCopies"     "True"  "$F"
    echo "  [OK]   $F"
done

echo ""
rt_log_event "ADJUSTER" "$LABEL" "completed"
rt_write_state "$LABEL"

sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
