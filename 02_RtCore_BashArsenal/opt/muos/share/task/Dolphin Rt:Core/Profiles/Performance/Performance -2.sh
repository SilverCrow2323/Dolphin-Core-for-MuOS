#!/bin/sh
# HELP: Performance -2 - Apply this performance level
# ICON: storage

. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/performance/-2"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Performance"
echo "  Level    : -2"
echo "  Scouter  : -2"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini"
echo "     Overclock          : 1.20"
echo "     TimingVariance     : 30"
echo "     EnableIdleSkipping : False"
echo "     SyncGPU            : True"
echo "   GFX.ini"
echo "     InternalResolution : 2"
echo "     DisableFog         : False"
echo "     FastDepthResult    : True"
echo "     EFBToTextureEnable : True"
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
echo "   Conservative. Try if MIN is too slow."
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
