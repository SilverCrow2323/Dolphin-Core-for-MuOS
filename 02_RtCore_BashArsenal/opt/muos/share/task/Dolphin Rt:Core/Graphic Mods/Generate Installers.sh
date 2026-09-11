#!/bin/sh
# HELP: Generate one install script per mod
# ICON: backup
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool 005 : GENERATE INSTALLERS
#    Scans rtdata/graphic_mods/ and creates one .sh per mod
#    inside Graphic Mods/Installers/.
#
#    At the end, removes the RUNGIF placeholder
#    ("Launch 'Generate Installers' First.sh") if present,
#    since the folder is no longer empty.
#
#    Re-run anytime after adding new mods.
#

. /opt/muos/script/var/func.sh
FRONTEND stop

EMUDIR="/opt/muos/share/emulator/dolphin"
MODSRC="$EMUDIR/rtdata/graphic_mods"
OUTDIR="/opt/muos/share/task/Dolphin Rt:Core/Graphic Mods/Installers"
RUNGIF="Launch 'Generate Installers' First.sh"
LOGDIR="$EMUDIR/rtdata/logs"
LOG="$LOGDIR/graphic_mods.log"
mkdir -p "$LOGDIR" "$OUTDIR"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Generate Installers"
echo "==============================================="
echo ""

# Purge previous installers (but keep RUNGIF until we're done)
find "$OUTDIR" -maxdepth 1 -type f -name "*.sh" \
    ! -name "$RUNGIF" -delete 2>/dev/null

COUNT=0

# ----- All-games mods -----
for d in "$MODSRC/all_games"/*; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    safe=$(echo "$name" | tr '/' '_')
    out="$OUTDIR/[ALL] $safe.sh"

    cat > "$out" <<SCRIPT
#!/bin/sh
# HELP: Install - [ALL] $name
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - GameID : ALL
#  - Mod    : $name
#  - Source : rtdata/graphic_mods/all_games/$name
#

. /opt/muos/script/var/func.sh
FRONTEND stop

SRC="/opt/muos/share/emulator/dolphin/rtdata/graphic_mods/all_games/$name"
DST="/opt/muos/share/emulator/dolphin/Load/GraphicMods/$name"
LOGDIR="/opt/muos/share/emulator/dolphin/rtdata/logs"
mkdir -p "\$LOGDIR"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Install Mod"
echo "==============================================="
echo "  GameID : ALL"
echo "  Mod    : $name"
echo "==============================================="
echo ""

mkdir -p "\$(dirname "\$DST")"

if [ -e "\$DST" ]; then
    echo "  [SKIP] Already installed."
else
    cp -r "\$SRC" "\$DST" && echo "  [OK] Installed."
    echo "[\$(date '+%F %T')] installed ALL - $name" >> "\$LOGDIR/graphic_mods.log"
fi

echo ""
echo "  Reminder: run 'Enable Mods' once."
sync
echo ""
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
SCRIPT
    chmod +x "$out"
    COUNT=$((COUNT + 1))
done

# ----- Game-specific mods -----
for d in "$MODSRC/game_specific"/*; do
    [ -d "$d" ] || continue
    name=$(basename "$d")

    case "$name" in
        *" - "*)
            gameid="${name%% -*}"
            modname="${name#* - }"
            ;;
        *)
            gameid="????"
            modname="$name"
            ;;
    esac

    safe=$(echo "$modname" | tr '/' '_')
    out="$OUTDIR/$gameid - $safe.sh"

    cat > "$out" <<SCRIPT
#!/bin/sh
# HELP: Install - $gameid $modname
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - GameID : $gameid
#  - Mod    : $modname
#  - Source : rtdata/graphic_mods/game_specific/$name
#

. /opt/muos/script/var/func.sh
FRONTEND stop

SRC="/opt/muos/share/emulator/dolphin/rtdata/graphic_mods/game_specific/$name"
DST="/opt/muos/share/emulator/dolphin/Load/GraphicMods/$name"
LOGDIR="/opt/muos/share/emulator/dolphin/rtdata/logs"
mkdir -p "\$LOGDIR"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Install Mod"
echo "==============================================="
echo "  GameID : $gameid"
echo "  Mod    : $modname"
echo "==============================================="
echo ""

mkdir -p "\$(dirname "\$DST")"

if [ -e "\$DST" ]; then
    echo "  [SKIP] Already installed."
else
    cp -r "\$SRC" "\$DST" && echo "  [OK] Installed."
    echo "[\$(date '+%F %T')] installed $gameid - $modname" >> "\$LOGDIR/graphic_mods.log"
fi

echo ""
echo "  Reminder: run 'Enable Mods' once."
sync
echo ""
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
SCRIPT
    chmod +x "$out"
    COUNT=$((COUNT + 1))
done

# ----- Remove RUNGIF placeholder (folder is now populated) -----
if [ -f "$OUTDIR/$RUNGIF" ]; then
    rm -f "$OUTDIR/$RUNGIF"
    echo "  [OK] RUNGIF removed (folder populated)"
fi

echo ""
echo "[$(date '+%F %T')] generated $COUNT installers" >> "$LOG"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Generate Installers"
echo "==============================================="
echo ""
echo "  Generated: $COUNT installer scripts"
echo "  Location : Installers/"
echo ""
echo "  Refresh the muOS menu to see them."
echo ""
sync
sleep 6
FRONTEND start task
exit 0
