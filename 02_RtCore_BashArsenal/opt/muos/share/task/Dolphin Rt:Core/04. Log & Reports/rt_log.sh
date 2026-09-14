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
