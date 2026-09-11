#!/bin/sh
# HELP: Profilo Compatibility | Profilo Compatibility - Massima stabilità | Funzionalità: Profilo di emulazione per titoli problematici | Descrizione: Sacrifica velocità per accuratezza. Usa SyncGPU, Overclock alto, e disabilita le ottimizzazioni grafiche aggressive. | ON: Profilo attivo | OFF (Default): Non applicato | Risorse: Più pesante sulla CPU | Downside: FPS più bassi | MINORU's Quick Lesson: Usalo quando il gioco crasha, si blocca o fa glitch. Non usarlo per giocare a Mario Kart a 60 FPS. | MINORU's Quick Lesson #001
# ICON: storage
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Profilo : Compatibility
#     Funzionalità: Profilo di emulazione per titoli problematici | Descrizione: Sacrifica velocità per accuratezza. Usa SyncGPU, Overclock alto, e disabilita le ottimizzazioni grafiche aggressive. | ON: Profilo attivo | OFF (Default): Non applicato | Risorse: Più pesante sulla CPU | Downside: FPS più bassi | MINORU's Quick Lesson: Usalo quando il gioco crasha, si blocca o fa glitch. Non usarlo per giocare a Mario Kart a 60 FPS.
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/compatibility/+2"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Compatibility"
echo "  Level    : +2"
echo "  Scouter  : 2"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini"
echo "     Overclock          : 0.80"
echo "     TimingVariance     : 50"
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
  Compatibility tips
  -----------------------------------------
   - Use when a game crashes, hangs, or glitches
   - MIN / -2 for "broken" titles
   - standard is the safe default
   - Moving up frees FPS at cost of accuracy
echo ""
echo "  Sync Filesystem"
sync

echo "All Done!"
sleep 5

FRONTEND start task
exit 0
