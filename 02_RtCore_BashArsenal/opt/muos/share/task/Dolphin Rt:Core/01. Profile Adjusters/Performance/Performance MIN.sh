#!/bin/sh
# HELP: Profilo Performance | Profilo Performance - Bilanciato | Funzionalità: Profilo di emulazione daily driver | Descrizione: Bilanciamento tra velocità e accuratezza. Overclock moderato, SyncGPU disattivato, ottimizzazioni grafiche attive. | ON: Profilo attivo | OFF (Default): Non applicato | Risorse: Bilanciato | Downside: Nessuno rilevante | MINORU's Quick Lesson: È il profilo che dovresti usare nel 90% dei casi. Se non sai quale scegliere, scegli questo. | MINORU's Quick Lesson #001
# ICON: storage
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Profilo : Performance
#     Funzionalità: Profilo di emulazione daily driver | Descrizione: Bilanciamento tra velocità e accuratezza. Overclock moderato, SyncGPU disattivato, ottimizzazioni grafiche attive. | ON: Profilo attivo | OFF (Default): Non applicato | Risorse: Bilanciato | Downside: Nessuno rilevante | MINORU's Quick Lesson: È il profilo che dovresti usare nel 90% dei casi. Se non sai quale scegliere, scegli questo.
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/performance/MIN"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Performance"
echo "  Level    : MIN"
echo "  Scouter  : -3"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini"
echo "     Overclock          : 1.30"
echo "     TimingVariance     : 25"
echo "     EnableIdleSkipping : False"
echo "     SyncGPU            : True"
echo "   GFX.ini"
echo "     InternalResolution : 2"
echo "     DisableFog         : False"
echo "     FastDepthResult    : False"
echo "     EFBToTextureEnable : False"
echo "     SkipEFBCopyToRam   : False"
echo "     DeferEFBCopies     : False"
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
echo "   Lowest FPS in range - highest accuracy. Last resort."
echo ""
  Performance tips
  -----------------------------------------
   - Daily driver, best balance speed/accuracy
   - Start at standard, move up/down to taste
   - MIN / -2 if you see audio/video desync
   - +1 / +2 / MAX for smoother framerate
echo ""
echo "  Sync Filesystem"
sync

echo "All Done!"
sleep 5

FRONTEND start task
exit 0
