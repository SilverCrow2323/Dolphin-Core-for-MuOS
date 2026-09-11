#!/bin/sh
# HELP: Toggle DebugUI | Interfaccia di debug di Dolphin | Funzionalità: Dolphin debugging interface | Descrizione: Mostra l'interfaccia di debug con informazioni interne sull'emulatore. | ON: Debug UI visibile | OFF (Default): Debug UI non visibile | Risorse: Impatto significativo | Downside: Rallenta l'emulazione e confonde | MINORU's Quick Lesson: Se non stai compilando Dolphin, non ti serve. Se lo attivi, aspettati un calo di prestazioni. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : DebugUI
#     Funzionalità: Dolphin debugging interface | Descrizione: Mostra l'interfaccia di debug con informazioni interne sull'emulatore. | ON: Debug UI visibile | OFF (Default): Debug UI non visibile | Risorse: Impatto significativo | Downside: Rallenta l'emulazione e confonde | MINORU's Quick Lesson: Se non stai compilando Dolphin, non ti serve. Se lo attivi, aspettati un calo di prestazioni.
#
#  - Stato  : ON
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/DebugUI/DebugUI ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : DebugUI"
echo "  State  : ON"
echo "  Effect : Dolphin debugging interface"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/DebugUI.ini"
    echo "  [OK] DebugUI.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/DebugUI.ini" | sed 's/^/    /'
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
