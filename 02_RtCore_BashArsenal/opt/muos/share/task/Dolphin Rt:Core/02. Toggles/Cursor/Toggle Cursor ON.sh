#!/bin/sh
# HELP: Toggle Cursor | Visibilità del cursore del mouse | Funzionalità: Mouse cursor visibility | Descrizione: Controlla se il cursore del mouse è visibile durante il gioco. | ON: Cursore visibile | OFF (Default): Cursore nascosto | Risorse: Nessuna | Downside: Il cursore può distrarre | MINORU's Quick Lesson: Su un handheld non hai il mouse. Quindi è inutile. Ma se usi un mouse USB, fai pure. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : Cursor
#     Funzionalità: Mouse cursor visibility | Descrizione: Controlla se il cursore del mouse è visibile durante il gioco. | ON: Cursore visibile | OFF (Default): Cursore nascosto | Risorse: Nessuna | Downside: Il cursore può distrarre | MINORU's Quick Lesson: Su un handheld non hai il mouse. Quindi è inutile. Ma se usi un mouse USB, fai pure.
#
#  - Stato  : ON
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/Cursor/Cursor ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : Cursor"
echo "  State  : ON"
echo "  Effect : Mouse cursor visibility in-game"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/Cursor.ini"
    echo "  [OK] Cursor.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/Cursor.ini" | sed 's/^/    /'
else
    echo "  [ERR] Source file missing in $SRC"
fi

echo ""
echo "  Sync Filesystem"
sync

echo "All Done!"
sleep 5

FRONTEND start task
exit 0
