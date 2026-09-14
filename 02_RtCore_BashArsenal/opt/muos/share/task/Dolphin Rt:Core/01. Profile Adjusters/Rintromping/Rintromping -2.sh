#!/bin/sh
# HELP: Profile Rintromping - -2
# ICON: storage
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

FRONTEND stop
rt_log_init

CFG="/opt/muos/share/emulator/dolphin/Config"
PROFILE="rintromping"
LABEL="Rintromping -2"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Rintromping"
echo "  Level    : -2"
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
    apply_ini "$FILE" "Core" "Overclock"          "1.00"   "$F"
    apply_ini "$FILE" "Core" "TimingVariance"     "35"   "$F"
    apply_ini "$FILE" "Core" "EnableIdleSkipping" "True" "$F"
    apply_ini "$FILE" "Core" "SyncGPU"            "True" "$F"
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
