#!/bin/sh
# HELP: Profilo MaxRintromping | Profilo Max Rintromping - Massima velocità | Funzionalità: Profilo di emulazione aggressivo | Descrizione: Spinge al massimo le prestazioni. Overclock basso, TimingVariance alto, tutte le ottimizzazioni grafiche attive. | ON: Profilo attivo | OFF (Default): Non applicato | Risorse: Più leggero sulla CPU | Downside: Possibili glitch grafici e audio | MINORU's Quick Lesson: Usalo su giochi leggeri o quando vuoi spremere l'ultimo FPS. Non lamentarti se Yoshi ha la coda invisibile. | MINORU's Quick Lesson #001
# ICON: storage
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Profilo : MaxRintromping
#     Funzionalità: Profilo di emulazione aggressivo | Descrizione: Spinge al massimo le prestazioni. Overclock basso, TimingVariance alto, tutte le ottimizzazioni grafiche attive. | ON: Profilo attivo | OFF (Default): Non applicato | Risorse: Più leggero sulla CPU | Downside: Possibili glitch grafici e audio | MINORU's Quick Lesson: Usalo su giochi leggeri o quando vuoi spremere l'ultimo FPS. Non lamentarti se Yoshi ha la coda invisibile.
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/rintromping/+2"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : MaxRintromping"
echo "  Level    : +2"
echo "  Scouter  : 2"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini"
echo "     Overclock          : 0.65"
echo "     TimingVariance     : 55"
echo "     EnableIdleSkipping : True"
echo "     SyncGPU            : False"
echo "   GFX.ini"
echo "     InternalResolution : 1"
echo "     DisableFog         : True"
echo "     FastDepthResult    : True"
echo "     EFBToTextureEnable : True"
echo "     SkipEFBCopyToRam   : True"
echo "     DeferEFBCopies     : True"
echo ""

if [ -f "$SRC/Dolphin.ini" ] && [ -f "$SRC/GFX.ini" ]; then
    cp "$SRC/Dolphin.ini" "$CFG/Dolphin.ini"
    cp "$SRC/GFX.ini"     "$CFG/GFX.ini"
    echo "  [OK] Dolphin.ini and GFX.ini updated"
else
    echo "  [ERR] Source files missing in $SRC"
fi

echo ""
echo "  Expected performance"
echo "  -----------------------------------------"
echo "   Noticeably faster. Some visual shortcuts."
echo ""
  Rintromping tips
  -----------------------------------------
   - Aggressive: highest speed, lowest accuracy
   - Best on 60 FPS-native or light titles
   - MIN / -2 if MAX stutters or audio crackles
   - Disable Bounding Box and copy filters for more
echo ""
echo "  Sync Filesystem"
sync

echo "All Done!"
sleep 5

FRONTEND start task
exit 0
