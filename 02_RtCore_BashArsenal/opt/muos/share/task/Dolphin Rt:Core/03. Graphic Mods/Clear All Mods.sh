#!/bin/sh
# HELP: Clear All Mods | Funzionalità: Rimuove tutte le mod installate | Descrizione: Cancella Load/GraphicMods/ e gli installer. Ricrea RUNGIF. | ON: Mod rimosse | OFF (Default): Mod installate | Risorse: Nessuna | Downside: Perdi le mod installate | MINORU's Quick Lesson #001: Usalo quando vuoi ricominciare da zero. O quando RUNGIF ti manca.
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : Clear All Mods
#    Clear All Mods | Funzionalità: Rimuove tutte le mod installate | Descrizione: Cancella Load/GraphicMods/ e gli installer. Ricrea RUNGIF. | ON: Mod rimosse | OFF (Default): Mod installate | Risorse: Nessuna | Downside: Perdi le mod installate | MINORU's Quick Lesson #001: Usalo quando vuoi ricominciare da zero. O quando RUNGIF ti manca.
#
. /opt/muos/script/var/func.sh
FRONTEND stop

MODDST="/opt/muos/share/emulator/dolphin/Load/GraphicMods"
INSTDIR="/opt/muos/share/task/Dolphin Rt:Core/Graphic Mods/Installers"
RUNGIF="Launch 'Generate Installers' First.sh"
LOGDIR="/opt/muos/share/emulator/dolphin/rtdata/logs"
LOG="$LOGDIR/graphic_mods.log"
mkdir -p "$LOGDIR" "$INSTDIR"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Clear All Mods"
echo "==============================================="
echo ""

COUNT=$(find "$MODDST" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
echo "  Removing $COUNT installed mods..."
rm -rf "$MODDST"/* 2>/dev/null
echo "  [OK] Cleared $COUNT mods"
echo "[$(date '+%F %T')] cleared $COUNT mods" >> "$LOG"

# ---- Wipe installers too ----
IC=$(find "$INSTDIR" -maxdepth 1 -type f -name "*.sh" 2>/dev/null | wc -l)
rm -f "$INSTDIR"/*.sh 2>/dev/null
echo "  [OK] Cleared $IC installer scripts"

# ---- Resurrect RUNGIF — Chapter Two ----
cat > "$INSTDIR/$RUNGIF" <<'CH2'
#!/bin/sh
# HELP: Launch 'Generate Installers' First
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  Ah. You again.
#
#  The old sensei returns. The empty folder calls him back,
#  and he comes. Of course he comes.
#
#  ------------------------------------------------------------
#  CHAPTER TWO — THE RETURN
#  ------------------------------------------------------------
#
#    The young eastern colt walks back into the dojo.
#    He was here before. He will be here again.
#
#    The road of life, boy... sometimes it needs directions.
#
#    But I... I prefer teachings over directions.
#
#    Now. You know what to do. Or rather, you know what I
#    will do for you, because that is the way of things.
#
#  ------------------------------------------------------------
#  - Rungif
#    Still here. Still magnanimo. Still a bit tired.
#

. /opt/muos/script/var/func.sh
FRONTEND stop

SELF_DIR="/opt/muos/share/task/Dolphin Rt:Core/Graphic Mods"
GEN="$SELF_DIR/Generate Installers.sh"

clear

say() { echo "$1"; sleep "${2:-1.4}"; }

echo "==============================================="
say "  Dolphin Rt:Core - RUNGIF" 0.8
say "  Chapter Two: The Return" 2.5
echo "==============================================="
echo ""
sleep 1

say "Ah." 2.5
say "You again." 2.5
echo ""
say "The young eastern colt..." 2
say "...walks back into the dojo." 2.5
echo ""
say "Well, well, well." 2.5
echo ""
say "The road of life, boy..." 2
say "...sometimes needs directions." 2.5
echo ""
say "But I..." 2
say "...I prefer teachings over directions." 3
echo ""
sleep 1

say "Now listen, and I shall say it only once:" 2.5
say "You were supposed to go back one folder" 2
say "and launch: Generate Installers." 2.5
echo ""
say "But, of course..." 2
say "...you did not." 2.5
echo ""
say "..." 1.2
say "." 1.2
say "." 1.2
say "." 2
echo ""
say "Old uncle Rungif will take care of it." 2.5
say "As he always does." 2.5
echo ""
sleep 1

if [ ! -f "$GEN" ]; then
    say "  [ERR] Generate Installers.sh not found at:" 1.5
    say "        $GEN" 2
    echo ""
    say "Even RUNGIF has limits." 2.5
    sleep 4
    FRONTEND start task
    exit 1
fi

say "  Launching Generate Installers..." 2
echo ""

sh "$GEN"

# ---- Chapter Two farewell ----
sleep 1
echo ""
echo "==============================================="
say "  ...and so the folder is full once more." 2.5
echo "==============================================="
echo ""
say "Go now, boy." 2.5
say "The scripts are yours." 2
say "The lessons... are yours too." 2.5
echo ""
say "We shall meet again." 2.5
say "When this folder is empty." 2.5
echo ""
say "Until then... stay Rintromping." 3.5
echo ""
sleep 2

FRONTEND start task
exit 0
CH2
chmod +x "$INSTDIR/$RUNGIF"
echo "  [RUNGIF] Chapter Two resurrected"
echo ""
sync
echo "All Done!"
sleep 5
FRONTEND start task
exit 0
