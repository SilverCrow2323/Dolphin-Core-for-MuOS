#!/bin/sh
# HELP: Uninstall Dolphin | Funzionalità: Rimuove l'intera installazione | Descrizione: Cancella /opt/muos/share/emulator/dolphin/ ricorsivamente. | Risorse: Nessuna | Downside: Perdi tutto | MINORU's Quick Lesson #001: Se lo lanci, Dolphin sparisce. Per sempre.
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : Uninstall Dolphin
#    Uninstall Dolphin | Funzionalità: Rimuove l'intera installazione | Descrizione: Cancella /opt/muos/share/emulator/dolphin/ ricorsivamente. | Risorse: Nessuna | Downside: Perdi tutto | MINORU's Quick Lesson #001: Se lo lanci, Dolphin sparisce. Per sempre.
#
. /opt/muos/script/var/func.sh

FRONTEND stop

TARGET="/opt/muos/share/emulator/dolphin"

clear

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 'Bash Arsenal'"
echo "  SPDW Factory Lab / sirpips"
echo "==============================================="
echo "  Eradicate The Dolpheen"
echo "==============================================="
echo ""
echo "  WARNING - DESTRUCTIVE OPERATION"
echo "  -------------------------------"
echo "  The following folder will be DELETED:"
echo ""
echo "    $TARGET"
echo ""
echo "  This includes:"
echo "    - dolphin binary"
echo "    - Config/        (all profiles and toggles)"
echo "    - rtdata/        (presets, logs, workshop, settings)"
echo "    - GameSettings/  (per-game overrides)"
echo "    - GC/  Wii/      (memory cards, NAND, saves)"
echo "    - every other file and folder inside"
echo ""
echo "  This action CANNOT be undone."
echo ""
echo "==============================================="
echo ""
echo "  Type ERADICATE (uppercase) to confirm,"
echo "  or press ENTER to abort:"
echo ""
printf "  > "
read -r CONFIRM

echo ""

if [ "$CONFIRM" != "ERADICATE" ]; then
    echo "  [ABORT] Confirmation failed."
    echo "  Nothing was removed."
    echo ""
    echo "  Closing in 5 seconds..."
    sleep 5
    FRONTEND start task
    exit 0
fi

if [ ! -d "$TARGET" ]; then
    echo "  [INFO] Target folder does not exist:"
    echo "         $TARGET"
    echo "  Nothing to remove."
    echo ""
    echo "  Closing in 5 seconds..."
    sleep 5
    FRONTEND start task
    exit 0
fi

echo "  Removing: $TARGET"
echo ""

# Count items for the summary
COUNT=$(find "$TARGET" 2>/dev/null | wc -l)

rm -rf "$TARGET"

if [ -d "$TARGET" ]; then
    echo "  [ERR] Removal failed - folder still present."
    echo ""
    echo "  Check permissions or mount status."
    echo ""
    echo "  Closing in 5 seconds..."
    sleep 5
    FRONTEND start task
    exit 1
else
    echo "  [OK]  Removed successfully."
fi

echo ""
echo "==============================================="
echo "  Summary"
echo "-----------------------------------------------"
echo "  Path    : $TARGET"
echo "  Entries : $COUNT"
echo "  Status  : REMOVED"
echo "==============================================="
echo ""

echo "  Sync Filesystem"
sync

echo ""
echo "All Done."
echo ""
echo "  Dolphin Rt:Core has been eradicated."
echo "  Reinstall it to use Dolphin again."
echo ""
echo "==============================================="
echo "  Closing in 5 seconds..."
echo "==============================================="

sleep 5

FRONTEND start task
exit 0