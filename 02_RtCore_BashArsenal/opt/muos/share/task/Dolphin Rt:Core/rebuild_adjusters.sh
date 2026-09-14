#!/bin/bash
# Regenerate all 21 Profile Adjuster scripts.
# - standard  -> restore from rtdata/profiles_preset/
# - others    -> patch keys in Config/*.ini

# ============================================================
#  STANDARD: restore from presets
# ============================================================
write_adjuster_standard() {
    local profile="$1"        # rintromping | compatibility | performance
    local profile_title="$2"  # Rintromping | Compatibility | Performance

    local outdir="01. Profile Adjusters/$profile_title"
    local outfile="$outdir/$profile_title standard.sh"
    mkdir -p "$outdir"

    cat > "$outfile" <<TEMPLATE
#!/bin/sh
# HELP: Profile $profile_title - Level standard (restore factory preset)
# ICON: storage
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector] - Profile Adjuster
#  ============================================================
#
. /opt/muos/script/var/func.sh

FRONTEND stop

CFG="/opt/muos/share/emulator/dolphin/Config"
PRESET="/opt/muos/share/emulator/dolphin/rtdata/profiles_preset"
PROFILE="$profile"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : $profile_title"
echo "  Level    : standard (factory restore)"
echo "  Scouter  : 0"
echo "==============================================="
echo ""
echo "  Restoring preset files from:"
echo "    \$PRESET"
echo ""

if [ ! -d "\$PRESET" ]; then
    echo "  [ERR] Preset folder not found:"
    echo "        \$PRESET"
    echo ""
    echo "  Sync Filesystem"
    sync
    echo "All Done!"
    sleep 5
    FRONTEND start task
    exit 1
fi

# ----- Find a preset file: try several naming conventions -----
find_preset() {
    local base="\$1"   # Dolphin.ini | GFX.ini
    for cand in \
        "\$PRESET/\$base.\$PROFILE" \
        "\$PRESET/\$PROFILE/\$base" \
        "\$PRESET/\$base" ; do
        [ -f "\$cand" ] && { echo "\$cand"; return 0; }
    done
    return 1
}

RESTORED=0
FAILED=0

restore_one() {
    local base="\$1"   # Dolphin.ini | GFX.ini
    local src
    src=\$(find_preset "\$base")
    if [ -z "\$src" ]; then
        echo "  [SKIP] No preset found for \$base"
        FAILED=\$((FAILED + 1))
        return
    fi

    # 1) update profile-specific file
    cp "\$src" "\$CFG/\$base.\$PROFILE" \
        && echo "  [OK]   \$base.\$PROFILE  <- \$(basename "\$src")" \
        || { echo "  [ERR]  \$base.\$PROFILE"; FAILED=\$((FAILED + 1)); }

    # 2) activate it as the currently used file
    cp "\$src" "\$CFG/\$base" \
        && echo "  [OK]   \$base           <- \$(basename "\$src")" \
        || { echo "  [ERR]  \$base"; FAILED=\$((FAILED + 1)); }

    RESTORED=\$((RESTORED + 1))
}

restore_one "Dolphin.ini"
restore_one "GFX.ini"

echo ""
echo "==============================================="
echo "  Summary"
echo "-----------------------------------------------"
echo "  Presets applied : \$RESTORED / 2"
echo "  Failures        : \$FAILED"
echo "  Expected perf.  : Balanced (factory default)"
echo "==============================================="
echo ""
echo "  Sync Filesystem"
sync

echo "All Done!"
sleep 5

FRONTEND start task
exit 0
TEMPLATE
    chmod +x "$outfile"
    echo "[+] $outfile"
}

# ============================================================
#  PATCHER: modify keys in INI files
# ============================================================
write_adjuster_patch() {
    local profile="$1" profile_title="$2" level="$3" scouter="$4"
    local d_oc="$5" d_tv="$6" d_idle="$7" d_sync="$8"
    local g_ir="$9" g_fog="${10}" g_fd="${11}" g_efbt="${12}" g_skip="${13}" g_def="${14}"
    local expected="${15}"

    local outdir="01. Profile Adjusters/$profile_title"
    local outfile="$outdir/$profile_title $level.sh"
    mkdir -p "$outdir"

    cat > "$outfile" <<TEMPLATE
#!/bin/sh
# HELP: Profile $profile_title - Level $level
# ICON: storage
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector] - Profile Adjuster
# ============================================================
#
. /opt/muos/script/var/func.sh

FRONTEND stop

CFG="/opt/muos/share/emulator/dolphin/Config"
PROFILE="$profile"

clear
echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : $profile_title"
echo "  Level    : $level"
echo "  Scouter  : $scouter"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini.*"
echo "     Overclock          : $d_oc"
echo "     TimingVariance     : $d_tv"
echo "     EnableIdleSkipping : $d_idle"
echo "     SyncGPU            : $d_sync"
echo "   GFX.ini.*"
echo "     InternalResolution : $g_ir"
echo "     DisableFog         : $g_fog"
echo "     FastDepthCalc      : $g_fd"
echo "     EFBToTextureEnable : $g_efbt"
echo "     SkipEFBCopyToRam   : $g_skip"
echo "     DeferEFBCopies     : $g_def"
echo ""

set_ini() {
    local file="\$1" section="\$2" key="\$3" value="\$4"
    [ -f "\$file" ] || return 1
    if grep -q "^[[:space:]]*\${key}[[:space:]]*=" "\$file"; then
        sed -i "s|^[[:space:]]*\${key}[[:space:]]*=.*|\${key} = \${value}|" "\$file"
    elif grep -q "^\\[\${section}\\]" "\$file"; then
        sed -i "/^\\[\${section}\\]/a \${key} = \${value}" "\$file"
    else
        printf "\\n[%s]\\n%s = %s\\n" "\$section" "\$key" "\$value" >> "\$file"
    fi
}

# --- Dolphin.ini : profile-specific first, then active ---
for F in "Dolphin.ini.\$PROFILE" "Dolphin.ini"; do
    FILE="\$CFG/\$F"
    if [ ! -f "\$FILE" ]; then
        echo "  [SKIP] \$F (not found)"
        continue
    fi
    set_ini "\$FILE" "Core" "Overclock"          "$d_oc"
    set_ini "\$FILE" "Core" "TimingVariance"     "$d_tv"
    set_ini "\$FILE" "Core" "EnableIdleSkipping" "$d_idle"
    set_ini "\$FILE" "Core" "SyncGPU"            "$d_sync"
    echo "  [OK]   \$F"
done

# --- GFX.ini : profile-specific first, then active ---
for F in "GFX.ini.\$PROFILE" "GFX.ini"; do
    FILE="\$CFG/\$F"
    if [ ! -f "\$FILE" ]; then
        echo "  [SKIP] \$F (not found)"
        continue
    fi
    set_ini "\$FILE" "Settings" "InternalResolution" "$g_ir"
    set_ini "\$FILE" "Hacks"    "DisableFog"         "$g_fog"
    set_ini "\$FILE" "Hacks"    "FastDepthCalc"      "$g_fd"
    set_ini "\$FILE" "Hacks"    "EFBToTextureEnable" "$g_efbt"
    set_ini "\$FILE" "Hacks"    "SkipEFBCopyToRam"   "$g_skip"
    set_ini "\$FILE" "Hacks"    "DeferEFBCopies"     "$g_def"
    echo "  [OK]   \$F"
done

echo ""
echo "  Expected performance"
echo "  -----------------------------------------"
echo "   $expected"
echo ""
echo "  Sync Filesystem"
sync

echo "All Done!"
sleep 5

FRONTEND start task
exit 0
TEMPLATE
    chmod +x "$outfile"
    echo "[+] $outfile"
}

# ============================================================
#  RINTROMPING
# ============================================================
write_adjuster_standard rintromping Rintromping

# write_adjuster_patch  profile  title  level  scouter  OC  TV  Idle  SyncGPU  IR  Fog  FastD  EFBT  Skip  Defer  expected
write_adjuster_patch rintromping Rintromping MIN  -3 1.10 30 True  True   2 True  True  True  True  True  "Lowest FPS in range - highest accuracy. Last resort."
write_adjuster_patch rintromping Rintromping -2   -2 1.00 35 True  True   1 True  True  True  True  True  "Conservative. Try if MIN is too slow."
write_adjuster_patch rintromping Rintromping -1   -1 0.90 40 True  False  1 True  True  True  True  True  "Slightly conservative. Good for problem titles."
write_adjuster_patch rintromping Rintromping +1    1 0.70 50 True  False  1 True  True  True  True  True  "Slight speed boost. Small accuracy trade-off."
write_adjuster_patch rintromping Rintromping +2    2 0.65 55 True  False  1 True  True  True  True  True  "Noticeably faster. Some visual shortcuts."
write_adjuster_patch rintromping Rintromping MAX   3 0.60 60 True  False  1 True  True  True  True  True  "Maximum speed. Largest accuracy trade-off."

# ============================================================
#  COMPATIBILITY
# ============================================================
write_adjuster_standard compatibility Compatibility

write_adjuster_patch compatibility Compatibility MIN  -3 1.50 20 False True   3 False False False False False "Lowest FPS in range - highest accuracy. Last resort."
write_adjuster_patch compatibility Compatibility -2   -2 1.40 25 False True   3 False True  False False False "Conservative. Try if MIN is too slow."
write_adjuster_patch compatibility Compatibility -1   -1 1.25 30 False True   2 False True  True  False False "Slightly conservative. Good for problem titles."
write_adjuster_patch compatibility Compatibility +1    1 0.90 45 True  False  1 True  True  True  True  True  "Slight speed boost. Small accuracy trade-off."
write_adjuster_patch compatibility Compatibility +2    2 0.80 50 True  False  1 True  True  True  True  True  "Noticeably faster. Some visual shortcuts."
write_adjuster_patch compatibility Compatibility MAX   3 0.70 60 True  False  1 True  True  True  True  True  "Maximum speed. Largest accuracy trade-off."

# ============================================================
#  PERFORMANCE
# ============================================================
write_adjuster_standard performance Performance

write_adjuster_patch performance Performance MIN  -3 1.30 25 False True   2 False False False False False "Lowest FPS in range - highest accuracy. Last resort."
write_adjuster_patch performance Performance -2   -2 1.20 30 False True   2 False True  True  False False "Conservative. Try if MIN is too slow."
write_adjuster_patch performance Performance -1   -1 1.10 35 True  True   1 False True  True  True  True  "Slightly conservative. Good for problem titles."
write_adjuster_patch performance Performance +1    1 0.90 45 True  False  1 True  True  True  True  True  "Slight speed boost. Small accuracy trade-off."
write_adjuster_patch performance Performance +2    2 0.80 50 True  False  1 True  True  True  True  True  "Noticeably faster. Some visual shortcuts."
write_adjuster_patch performance Performance MAX   3 0.70 60 True  False  1 True  True  True  True  True  "Maximum speed. Largest accuracy trade-off."

echo ""
echo "============================================================"
echo "  All 21 adjusters regenerated (3 standard + 18 patchers)"
echo "============================================================"
