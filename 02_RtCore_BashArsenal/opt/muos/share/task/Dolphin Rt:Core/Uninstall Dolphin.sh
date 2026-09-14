#!/bin/sh
# HELP: Uninstall Dolphin | Removes Dolphin, assignments, task folder, launcher and gptk. | Resources: None | Downside: You lose everything. | MINORU's Quick Lesson #001: If you run this, Dolphin disappears. Forever.
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
. /opt/muos/script/var/func.sh

FRONTEND stop

clear

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 'Bash Arsenal'"
echo "  SPDW Factory Lab / sirpips"
echo "==============================================="
echo "  Eradicate The Dolphin"
echo "==============================================="
echo ""
echo "  WARNING - DESTRUCTIVE OPERATION"
echo "  -------------------------------"
echo "  Directories to delete:"
echo "    /opt/muos/share/emulator/dolphin"
echo "    /opt/muos/share/info/assign/Nintendo Gamecube"
echo "    /opt/muos/share/info/assign/Nintendo GameCube"
echo "    /opt/muos/share/info/assign/Nintendo Wii"
echo "    /opt/muos/share/task/Dolphin Rt:Core"
echo "    /opt/muos/share/task/Dolphin RtCore"
echo ""
echo "  Files to delete:"
echo "    /opt/muos/script/launch/ext-dolphin.sh"
echo "    /opt/muos/share/emulator/gptokeyb/ext-dolphin-gptk"
echo "    /opt/muos/share/emulator/gptokeyb/ext-dolphin.gptk"
echo ""
echo "  This action CANNOT be undone."
echo ""
echo "  Auto-confirming ERADICATE..."
echo ""

REMOVED_DIRS=0
TOTAL_ENTRIES=0
REMOVED_FILES=0

remove_dir() {
    d="$1"
    if [ -d "$d" ]; then
        count=$(find "$d" 2>/dev/null | wc -l)
        rm -rf "$d"
        if [ ! -d "$d" ]; then
            echo "  [OK] Removed directory: $d ($count entries)"
            REMOVED_DIRS=$((REMOVED_DIRS + 1))
            TOTAL_ENTRIES=$((TOTAL_ENTRIES + count))
        else
            echo "  [ERR] Failed to remove directory: $d"
        fi
    else
        echo "  [INFO] Directory not found: $d"
    fi
}

remove_file() {
    f="$1"
    if [ -e "$f" ]; then
        rm -f "$f"
        if [ ! -e "$f" ]; then
            echo "  [OK] Removed file: $f"
            REMOVED_FILES=$((REMOVED_FILES + 1))
        else
            echo "  [ERR] Failed to remove file: $f"
        fi
    else
        echo "  [INFO] File not found: $f"
    fi
}

remove_dir  "/opt/muos/share/emulator/dolphin"
remove_dir  "/opt/muos/share/info/assign/Nintendo Gamecube"
remove_dir  "/opt/muos/share/info/assign/Nintendo GameCube"
remove_dir  "/opt/muos/share/info/assign/Nintendo Wii"
remove_dir  "/opt/muos/share/task/Dolphin Rt:Core"
remove_dir  "/opt/muos/share/task/Dolphin RtCore"

remove_file "/opt/muos/script/launch/ext-dolphin.sh"
remove_file "/opt/muos/share/emulator/gptokeyb/ext-dolphin-gptk"
remove_file "/opt/muos/share/emulator/gptokeyb/ext-dolphin.gptk"

echo ""
echo "==============================================="
echo "  Summary"
echo "-----------------------------------------------"
echo "  Directories removed : $REMOVED_DIRS"
echo "  Total entries       : $TOTAL_ENTRIES"
echo "  Files removed       : $REMOVED_FILES"
echo "  Status              : ERADICATED"
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
