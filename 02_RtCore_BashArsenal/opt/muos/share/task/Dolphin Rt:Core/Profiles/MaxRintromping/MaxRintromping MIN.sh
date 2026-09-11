#!/bin/sh
# HELP: MaxRintromping MIN - Apply this performance level
# ICON: storage

. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/rintromping/MIN"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : MaxRintromping"
echo "  Level    : MIN"
echo "  Scouter  : -3"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini"
echo "     Overclock          : 1.10"
echo "     TimingVariance     : 30"
echo "     EnableIdleSkipping : True"
echo "     SyncGPU            : True"
echo "   GFX.ini"
echo "     InternalResolution : 2"
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
echo "   Lowest FPS in range - highest accuracy. Last resort."
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
