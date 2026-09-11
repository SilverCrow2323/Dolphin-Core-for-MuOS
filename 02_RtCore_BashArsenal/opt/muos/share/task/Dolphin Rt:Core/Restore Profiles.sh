#!/bin/sh
# HELP: Restore every profile to factory defaults
# ICON: backup
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  Copies every .ini from rtdata/profiles_preset/ to Config/,
#  overwriting any user modification.
#
#  Overwrites:
#    Dolphin.ini, Dolphin.ini.*
#    GFX.ini, GFX.ini.*
#    GCPadNew.ini, WiimoteNew.ini
#    Hotkeys.ini, Logger.ini
#
#  Preserves:
#    rtdata/pocket_workshop/   (boost level presets)
#    rtdata/graphic_mods/      (Graphics Mods sources)
#    GameSettings/             (per-game overrides)


. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
SRC="$EMU/rtdata/profiles_preset"
DST="$EMU/Config"

clear

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 'Bash Arsenal'"
echo "  SPDW Factory Lab / sirpips"
echo "==============================================="
echo "  Rintro-Reset - Restore Factory Profiles"
echo "==============================================="
echo ""
echo "  This will OVERWRITE any user modification"
echo "  to the following files in Config/:"
echo ""
echo "   - Dolphin.ini"
echo "   - Dolphin.ini.compatibility"
echo "   - Dolphin.ini.performance"
echo "   - Dolphin.ini.maxrintromping"
echo "   - GFX.ini"
echo "   - GFX.ini.compatibility"
echo "   - GFX.ini.performance"
echo "   - GFX.ini.maxrintromping"
echo "   - GCPadNew.ini"
echo "   - WiimoteNew.ini"
echo "   - Hotkeys.ini"
echo "   - Logger.ini"
echo ""
echo "==============================================="
echo ""

if [ ! -d "$SRC" ]; then
    echo "  [ERR] Source folder not found:"
    echo "        $SRC"
    echo ""
    echo "  Nothing to restore."
    echo ""
    echo "Closing in 5 seconds..."
    sleep 5
    FRONTEND start task
    exit 1
fi

if [ ! -d "$DST" ]; then
    echo "  [ERR] Target folder not found:"
    echo "        $DST"
    echo ""
    echo "Closing in 5 seconds..."
    sleep 5
    FRONTEND start task
    exit 1
fi

RESTORED=0
FAILED=0

for f in "$SRC"/*.ini; do
    [ -f "$f" ] || continue
    name=$(basename "$f")
    if cp "$f" "$DST/$name"; then
        echo "  [OK]  $name"
        RESTORED=$((RESTORED + 1))
    else
        echo "  [ERR] $name"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "==============================================="
echo "  Summary"
echo "-----------------------------------------------"
echo "  Restored : $RESTORED file(s)"
echo "  Failed   : $FAILED file(s)"
echo "==============================================="
echo ""

echo "  Sync Filesystem"
sync

echo ""
echo "All Done!"
echo ""
echo "==============================================="
echo "  Closing in 5 seconds..."
echo "==============================================="

sleep 5

FRONTEND start task
exit 0