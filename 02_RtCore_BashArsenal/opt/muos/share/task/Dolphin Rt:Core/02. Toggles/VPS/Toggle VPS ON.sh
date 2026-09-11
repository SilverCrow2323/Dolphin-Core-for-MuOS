#!/bin/sh
# HELP: Toggle VPS | Mostra il VPS (Vertical Sync rate) | Funzionalità: VPS counter overlay | Descrizione: Mostra il refresh rate verticale effettivo. Serve per capire se il frame pacing è stabile. | ON: VPS visibile a schermo | OFF (Default): Overlay non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Utile solo se sei un nerd del frame pacing. Se non sai cosa sia il VPS, lascialo spento. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : VPS
#     Funzionalità: VPS counter overlay | Descrizione: Mostra il refresh rate verticale effettivo. Serve per capire se il frame pacing è stabile. | ON: VPS visibile a schermo | OFF (Default): Overlay non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Utile solo se sei un nerd del frame pacing. Se non sai cosa sia il VPS, lascialo spento.
#
#  - Stato  : ON
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/VPS/VPS ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : VPS"
echo "  State  : ON"
echo "  Effect : Vertical sync rate display"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/VPS.ini"
    echo "  [OK] VPS.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/VPS.ini" | sed 's/^/    /'
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
