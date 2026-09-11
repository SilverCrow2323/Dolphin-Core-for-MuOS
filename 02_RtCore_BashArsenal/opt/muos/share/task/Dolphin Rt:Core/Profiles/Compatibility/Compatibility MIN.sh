#!/bin/sh
# HELP: Compatibility MIN - Apply this performance level
# ICON: storage

. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/compatibility/MIN"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Compatibility"
echo "  Level    : MIN"
echo "  Scouter  : -3"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini"
echo "     Overclock          : 1.50"
echo "     TimingVariance     : 20"
echo "     EnableIdleSkipping : False"
echo "     SyncGPU            : True"
echo "   GFX.ini"
echo "     InternalResolution : 3"
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
