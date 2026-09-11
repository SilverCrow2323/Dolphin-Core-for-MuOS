#!/bin/sh
# HELP: Toggle ActiveTitle | Titolo del gioco nella barra della finestra | Funzionalità: Active title display | Descrizione: Mostra il nome del gioco in esecuzione nella barra del titolo. | ON: Titolo visibile | OFF (Default): Titolo non visibile | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson: Su un handheld non vedi la barra del titolo. Quindi è inutile. Ma se ti piace, accomodati. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : ActiveTitle
#     Funzionalità: Active title display | Descrizione: Mostra il nome del gioco in esecuzione nella barra del titolo. | ON: Titolo visibile | OFF (Default): Titolo non visibile | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson: Su un handheld non vedi la barra del titolo. Quindi è inutile. Ma se ti piace, accomodati.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/ActiveTitle/ActiveTitle OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : ActiveTitle"
echo "  State  : OFF"
echo "  Effect : Running game title shown in window"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/ActiveTitle.ini"
    echo "  [OK] ActiveTitle.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/ActiveTitle.ini" | sed 's/^/    /'
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
