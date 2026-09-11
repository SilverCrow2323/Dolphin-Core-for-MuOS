#!/bin/sh
# HELP: Performance -1 - Apply this performance level
# ICON: storage

. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/performance/-1"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Apply Profile"
echo "==============================================="
echo "  Profile  : Performance"
echo "  Level    : -1"
echo "  Scouter  : -1"
echo "==============================================="
echo ""
echo "  Values applied"
echo "  -----------------------------------------"
echo "   Dolphin.ini"
echo "     Overclock          : 1.10"
echo "     TimingVariance     : 35"
echo "     EnableIdleSkipping : True"
echo "     SyncGPU            : True"
echo "   GFX.ini"
echo "     InternalResolution : 1"
echo "     DisableFog         : False"
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
echo "   Slightly conservative. Good for problem titles."
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
