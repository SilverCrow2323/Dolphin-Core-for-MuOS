#!/bin/bash
# Regenerate all adjusters and toggles with unified logging.

ROOT="$(pwd)"
LOGDIR="$ROOT/04. Log & Reports"
ADJ="$ROOT/01. Profile Adjusters"
TOG="$ROOT/02. Toggles"

mkdir -p "$LOGDIR"

# ============================================================
#  1. Shared logging library
# ============================================================
cat > "$LOGDIR/rt_log.sh" <<'RTLIB_EOF'
#!/bin/sh
# rt_log.sh - shared logging for Dolphin Rt:Core.
#   . "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

RT_LOGDIR="/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports"
RT_HISTORY="$RT_LOGDIR/history.log"
RT_STATE="$RT_LOGDIR/last_state.txt"
RT_ROLLBACK="$RT_LOGDIR/rollback"
RT_HISTORY_MAX=2000
RT_CFG="/opt/muos/share/emulator/dolphin/Config"

rt_log_init() {
    mkdir -p "$RT_LOGDIR" "$RT_ROLLBACK"
    [ -f "$RT_HISTORY" ] || : > "$RT_HISTORY"
    [ -f "$RT_STATE" ] || : > "$RT_STATE"
}

rt_ts() { date '+%Y-%m-%d %H:%M:%S'; }

rt_log_append() {
    printf "%s\n" "$1" >> "$RT_HISTORY"
    L=$(wc -l < "$RT_HISTORY" 2>/dev/null || echo 0)
    if [ "$L" -gt "$RT_HISTORY_MAX" ]; then
        K=$((RT_HISTORY_MAX / 2))
        T=$(tail -n "$K" "$RT_HISTORY")
        printf "%s\n" "$T" > "$RT_HISTORY"
    fi
}

rt_log_event() {
    rt_log_append "$(rt_ts) | $1 | $2 | $3"
}

rt_log_change() {
    if [ "$5" = "$6" ]; then
        rt_log_append "$(rt_ts) | $1 | $2 | $3 | $4 | $5 (unchanged)"
    else
        rt_log_append "$(rt_ts) | $1 | $2 | $3 | $4 | $5 -> $6"
    fi
}

rt_get_ini() {
    local f="$1" k="$2"
    [ -f "$f" ] || return 0
    grep -E "^[[:space:]]*${k}[[:space:]]*=" "$f" 2>/dev/null \
        | head -1 \
        | sed -E 's/^[^=]*=[[:space:]]*//; s/[[:space:]]+$//'
}

rt_set_ini() {
    local file="$1" section="$2" key="$3" value="$4"
    [ -f "$file" ] || return 1
    if grep -q "^[[:space:]]*${key}[[:space:]]*=" "$file"; then
        sed -i "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = ${value}|" "$file"
    elif grep -q "^\[${section}\]" "$file"; then
        sed -i "/^\[${section}\]/a ${key} = ${value}" "$file"
    else
        printf "\n[%s]\n%s = %s\n" "$section" "$key" "$value" >> "$file"
    fi
}

rt_snapshot() {
    mkdir -p "$RT_ROLLBACK"
    rm -f "$RT_ROLLBACK"/* 2>/dev/null
    for f in "$RT_CFG"/*.ini "$RT_CFG"/*.ini.*; do
        [ -f "$f" ] || continue
        cp "$f" "$RT_ROLLBACK/" 2>/dev/null
    done
}

rt_rollback() {
    [ -d "$RT_ROLLBACK" ] || return 1
    N=0
    for f in "$RT_ROLLBACK"/*; do
        [ -f "$f" ] || continue
        cp "$f" "$RT_CFG/$(basename "$f")" 2>/dev/null && N=$((N+1))
    done
    echo "$N"
}

rt_write_state() {
    local last_action="${1:-}"
    {
        echo "=== Dolphin Rt:Core - Current State ==="
        echo "Updated: $(rt_ts)"
        [ -n "$last_action" ] && echo "Last action: $last_action"
        echo ""
        echo "--- Profile Files ---"
        for f in "$RT_CFG"/Dolphin.ini "$RT_CFG"/Dolphin.ini.* \
                 "$RT_CFG"/GFX.ini "$RT_CFG"/GFX.ini.*; do
            [ -f "$f" ] || continue
            MT=$(stat -c '%y' "$f" 2>/dev/null | cut -d. -f1)
            [ -n "$MT" ] || MT="?"
            printf "  %-32s %s\n" "$(basename "$f")" "$MT"
        done
        echo ""
        echo "--- Active Core (Dolphin.ini) ---"
        for k in Overclock TimingVariance EnableIdleSkipping SyncGPU; do
            v=$(rt_get_ini "$RT_CFG/Dolphin.ini" "$k")
            printf "  %-20s = %s\n" "$k" "$v"
        done
        echo ""
        echo "--- Active GFX (GFX.ini) ---"
        for k in InternalResolution DisableFog FastDepthCalc EFBToTextureEnable SkipEFBCopyToRam DeferEFBCopies; do
            v=$(rt_get_ini "$RT_CFG/GFX.ini" "$k")
            printf "  %-20s = %s\n" "$k" "$v"
        done
        echo ""
        echo "--- Toggles (GFX.ini) ---"
        for k in ShowFPS ShowVPS ShowSpeed OverlayStats OverlayProjStats LogRenderTimeToFile ShowFrameCount ExtendedFPSInfo EnableGraphicsMods; do
            v=$(rt_get_ini "$RT_CFG/GFX.ini" "$k")
            printf "  %-22s = %s\n" "$k" "$v"
        done
        echo ""
        echo "--- Toggles (Dolphin.ini) ---"
        for k in OnScreenDisplayMessages OSDDuration ShowActiveTitle CursorVisibility ShowInputDisplay ShowRTC ShowLag ShowNetPlayPing DebugModeEnabled; do
            v=$(rt_get_ini "$RT_CFG/Dolphin.ini" "$k")
            printf "  %-22s = %s\n" "$k" "$v"
        done
    } > "$RT_STATE"
}
RTLIB_EOF
chmod +x "$LOGDIR/rt_log.sh"

# ============================================================
#  2. Viewer / rollback tools
# ============================================================
cat > "$LOGDIR/View History.sh" <<'VIEW_HIST_EOF'
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
VIEW_HIST_EOF
chmod +x "$LOGDIR/View History.sh"

cat > "$LOGDIR/View Last State.sh" <<'VIEW_STATE_EOF'
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
VIEW_STATE_EOF
chmod +x "$LOGDIR/View Last State.sh"

cat > "$LOGDIR/Rollback Last Apply.sh" <<'ROLLBACK_EOF'
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
ROLLBACK_EOF
chmod +x "$LOGDIR/Rollback Last Apply.sh"

# ============================================================
#  3. Adjusters
# ============================================================
mkdir -p "$ADJ/Rintromping" "$ADJ/Compatibility" "$ADJ/Performance"
rm -rf "$ADJ/MaxRintromping_backup"

write_adjuster_standard() {
    local profile="$1" title="$2"
    local out="$ADJ/$title/$title standard.sh"
    cat > "$out" <<TEMPLATE_EOF
#!/bin/sh
# HELP: Profile $title - standard (factory restore)
# ICON: storage
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

FRONTEND stop
rt_log_init

CFG="/opt/muos/share/emulator/dolphin/Config"
PRESET="/opt/muos/share/emulator/dolphin/rtdata/profiles_preset"
PROFILE="$profile"
LABEL="$title standard"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : $title"
echo "  Level    : standard (factory restore)"
echo "==============================================="
echo ""

if [ ! -d "\$PRESET" ]; then
    echo "  [ERR] Preset folder not found: \$PRESET"
    rt_log_event "ADJUSTER" "\$LABEL" "FAILED - preset folder missing"
    sleep 5
    FRONTEND start task
    exit 1
fi

rt_snapshot
rt_log_event "ADJUSTER" "\$LABEL" "snapshot saved"

find_preset() {
    local base="\$1"
    for cand in "\$PRESET/\$base.\$PROFILE" "\$PRESET/\$PROFILE/\$base" "\$PRESET/\$base"; do
        [ -f "\$cand" ] && { echo "\$cand"; return 0; }
    done
    return 1
}

RESTORED=0
FAILED=0

restore_one() {
    local base="\$1"
    local src
    src=\$(find_preset "\$base")
    if [ -z "\$src" ]; then
        echo "  [SKIP] No preset found for \$base"
        rt_log_event "ADJUSTER" "\$LABEL" "SKIP \$base (no preset)"
        FAILED=\$((FAILED + 1))
        return
    fi
    cp "\$src" "\$CFG/\$base.\$PROFILE" \
        && echo "  [OK]   \$base.\$PROFILE" \
        || FAILED=\$((FAILED + 1))
    cp "\$src" "\$CFG/\$base" \
        && echo "  [OK]   \$base" \
        || FAILED=\$((FAILED + 1))
    rt_log_event "ADJUSTER" "\$LABEL" "\$base <- \$(basename "\$src")"
    RESTORED=\$((RESTORED + 1))
}

restore_one "Dolphin.ini"
restore_one "GFX.ini"

echo ""
echo "  Summary: \$RESTORED/2 presets applied, \$FAILED failures"
echo ""
rt_log_event "ADJUSTER" "\$LABEL" "completed (\$RESTORED/2 applied)"
rt_write_state "\$LABEL"

sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
TEMPLATE_EOF
    chmod +x "$out"
    echo "[+] $out"
}

write_adjuster_patch() {
    local profile="$1" title="$2" level="$3"
    local d_oc="$4" d_tv="$5" d_idle="$6" d_sync="$7"
    local g_ir="$8" g_fog="$9" g_fd="${10}" g_efbt="${11}" g_skip="${12}" g_def="${13}"
    local out="$ADJ/$title/$title $level.sh"
    cat > "$out" <<TEMPLATE_EOF
#!/bin/sh
# HELP: Profile $title - $level
# ICON: storage
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

FRONTEND stop
rt_log_init

CFG="/opt/muos/share/emulator/dolphin/Config"
PROFILE="$profile"
LABEL="$title $level"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : $title"
echo "  Level    : $level"
echo "==============================================="
echo ""

rt_snapshot
rt_log_event "ADJUSTER" "\$LABEL" "snapshot saved"

apply_ini() {
    local file="\$1" section="\$2" key="\$3" value="\$4" ref="\$5"
    [ -f "\$file" ] || return 1
    local old
    old=\$(rt_get_ini "\$file" "\$key")
    rt_set_ini "\$file" "\$section" "\$key" "\$value"
    rt_log_change "ADJUSTER" "\$LABEL" "\$ref" "\$key" "\$old" "\$value"
}

for F in "Dolphin.ini.\$PROFILE" "Dolphin.ini"; do
    FILE="\$CFG/\$F"
    [ -f "\$FILE" ] || { echo "  [SKIP] \$F"; continue; }
    apply_ini "\$FILE" "Core" "Overclock"          "$d_oc"   "\$F"
    apply_ini "\$FILE" "Core" "TimingVariance"     "$d_tv"   "\$F"
    apply_ini "\$FILE" "Core" "EnableIdleSkipping" "$d_idle" "\$F"
    apply_ini "\$FILE" "Core" "SyncGPU"            "$d_sync" "\$F"
    echo "  [OK]   \$F"
done

for F in "GFX.ini.\$PROFILE" "GFX.ini"; do
    FILE="\$CFG/\$F"
    [ -f "\$FILE" ] || { echo "  [SKIP] \$F"; continue; }
    apply_ini "\$FILE" "Settings" "InternalResolution" "$g_ir"   "\$F"
    apply_ini "\$FILE" "Hacks"    "DisableFog"         "$g_fog"  "\$F"
    apply_ini "\$FILE" "Hacks"    "FastDepthCalc"      "$g_fd"   "\$F"
    apply_ini "\$FILE" "Hacks"    "EFBToTextureEnable" "$g_efbt" "\$F"
    apply_ini "\$FILE" "Hacks"    "SkipEFBCopyToRam"   "$g_skip" "\$F"
    apply_ini "\$FILE" "Hacks"    "DeferEFBCopies"     "$g_def"  "\$F"
    echo "  [OK]   \$F"
done

echo ""
rt_log_event "ADJUSTER" "\$LABEL" "completed"
rt_write_state "\$LABEL"

sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
TEMPLATE_EOF
    chmod +x "$out"
    echo "[+] $out"
}

# Rintromping
write_adjuster_standard rintromping Rintromping
write_adjuster_patch rintromping Rintromping MIN 1.10 30 True  True   2 True  True  True  True  True
write_adjuster_patch rintromping Rintromping -2  1.00 35 True  True   1 True  True  True  True  True
write_adjuster_patch rintromping Rintromping -1  0.90 40 True  False  1 True  True  True  True  True
write_adjuster_patch rintromping Rintromping +1  0.70 50 True  False  1 True  True  True  True  True
write_adjuster_patch rintromping Rintromping +2  0.65 55 True  False  1 True  True  True  True  True
write_adjuster_patch rintromping Rintromping MAX 0.60 60 True  False  1 True  True  True  True  True

# Compatibility
write_adjuster_standard compatibility Compatibility
write_adjuster_patch compatibility Compatibility MIN 1.50 20 False True   3 False False False False False
write_adjuster_patch compatibility Compatibility -2  1.40 25 False True   3 False True  False False False
write_adjuster_patch compatibility Compatibility -1  1.25 30 False True   2 False True  True  False False
write_adjuster_patch compatibility Compatibility +1  0.90 45 True  False  1 True  True  True  True  True
write_adjuster_patch compatibility Compatibility +2  0.80 50 True  False  1 True  True  True  True  True
write_adjuster_patch compatibility Compatibility MAX 0.70 60 True  False  1 True  True  True  True  True

# Performance
write_adjuster_standard performance Performance
write_adjuster_patch performance Performance MIN 1.30 25 False True   2 False False False False False
write_adjuster_patch performance Performance -2  1.20 30 False True   2 False True  True  False False
write_adjuster_patch performance Performance -1  1.10 35 True  True   1 False True  True  True  True
write_adjuster_patch performance Performance +1  0.90 45 True  False  1 True  True  True  True  True
write_adjuster_patch performance Performance +2  0.80 50 True  False  1 True  True  True  True  True
write_adjuster_patch performance Performance MAX 0.70 60 True  False  1 True  True  True  True  True

# ============================================================
#  4. Toggles
# ============================================================
write_toggle() {
    local toggle="$1" state="$2" key="$3" value="$4" section="$5"
    local dir="$TOG/$toggle"
    local out="$dir/Toggle $toggle $state.sh"
    mkdir -p "$dir"
    cat > "$out" <<TEMPLATE_EOF
#!/bin/sh
# HELP: Toggle $toggle | State: $state
# ICON: theme
. /opt/muos/script/var/func.sh
. "/opt/muos/share/task/Dolphin Rt:Core/04. Log & Reports/rt_log.sh"

FRONTEND stop
rt_log_init

CFG="/opt/muos/share/emulator/dolphin/Config"
FILES="Dolphin.ini Dolphin.ini.compatibility Dolphin.ini.performance Dolphin.ini.rintromping GFX.ini GFX.ini.compatibility GFX.ini.performance GFX.ini.rintromping"
KEY="$key"
VALUE="$value"
SECTION="$section"
LABEL="Toggle $toggle $state"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : $toggle"
echo "  State  : $state"
echo "==============================================="
echo ""

OLD=\$(rt_get_ini "\$CFG/GFX.ini" "\$KEY")
rt_snapshot

CHANGED=0
SKIPPED=0

for F in \$FILES; do
    FILE="\$CFG/\$F"
    [ -f "\$FILE" ] || { SKIPPED=\$((SKIPPED+1)); continue; }
    rt_set_ini "\$FILE" "\$SECTION" "\$KEY" "\$VALUE"
    echo "  [OK]   \$F"
    CHANGED=\$((CHANGED+1))
done

echo ""
echo "  Files updated: \$CHANGED"
echo "  Files skipped: \$SKIPPED"
echo ""

rt_log_change "TOGGLE" "\$LABEL" "all INIs" "\$KEY" "\$OLD" "\$VALUE"
rt_log_event  "TOGGLE" "\$LABEL" "updated \$CHANGED files, skipped \$SKIPPED"
rt_write_state "\$LABEL"

sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
TEMPLATE_EOF
    chmod +x "$out"
    echo "[+] $out"
}

# Display overlays (GFX.ini)
write_toggle FPS ON  ShowFPS True  Settings
write_toggle FPS OFF ShowFPS False Settings
write_toggle VPS ON  ShowVPS True  Settings
write_toggle VPS OFF ShowVPS False Settings
write_toggle Speed ON  ShowSpeed True  Settings
write_toggle Speed OFF ShowSpeed False Settings
write_toggle OverlayStats ON  OverlayStats True  Settings
write_toggle OverlayStats OFF OverlayStats False Settings
write_toggle OverlayProjStats ON  OverlayProjStats True  Settings
write_toggle OverlayProjStats OFF OverlayProjStats False Settings
write_toggle FrameTimes ON  LogRenderTimeToFile True  Settings
write_toggle FrameTimes OFF LogRenderTimeToFile False Settings
write_toggle FrameCount ON  ShowFrameCount True  Settings
write_toggle FrameCount OFF ShowFrameCount False Settings
write_toggle ExtendedFPS ON  ExtendedFPSInfo True  Settings
write_toggle ExtendedFPS OFF ExtendedFPSInfo False Settings

# On-screen info (Dolphin.ini)
write_toggle OSD ON  OnScreenDisplayMessages True  Interface
write_toggle OSD OFF OnScreenDisplayMessages False Interface
write_toggle ActiveTitle ON  ShowActiveTitle True  Interface
write_toggle ActiveTitle OFF ShowActiveTitle False Interface
write_toggle Cursor ON  CursorVisibility 1 Interface
write_toggle Cursor OFF CursorVisibility 0 Interface
write_toggle InputDisplay ON  ShowInputDisplay True  Movie
write_toggle InputDisplay OFF ShowInputDisplay False Movie
write_toggle RTC ON  ShowRTC True  Interface
write_toggle RTC OFF ShowRTC False Interface
write_toggle Lag ON  ShowLag True  Interface
write_toggle Lag OFF ShowLag False Interface
write_toggle NetPlayPing ON  ShowNetPlayPing True  Interface
write_toggle NetPlayPing OFF ShowNetPlayPing False Interface
write_toggle DebugUI ON  DebugModeEnabled True  Interface
write_toggle DebugUI OFF DebugModeEnabled False Interface

# OSDDuration (numeric, three values)
write_toggle OSDDuration Short  OSDDuration 1000 Interface
write_toggle OSDDuration Normal OSDDuration 2500 Interface
write_toggle OSDDuration Long   OSDDuration 5000 Interface

echo ""
echo "============================================================"
echo "  Build complete."
echo "  - 21 adjusters"
echo "  - 35 toggles"
echo "  - rt_log.sh library"
echo "  - 3 viewer/rollback tools"
echo "============================================================"
