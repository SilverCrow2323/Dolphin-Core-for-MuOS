#!/bin/sh
# HELP: Toggle Lag | Contatore di input lag | Funzionalità: Input lag counter | Descrizione: Misura il ritardo tra l'input del controller e la risposta a schermo. | ON: Contatore visibile | OFF (Default): Contatore non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Se pensi che il gioco sia laggoso, questo ti dirà se è vero o se sei solo scarso. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : Lag
#     Funzionalità: Input lag counter | Descrizione: Misura il ritardo tra l'input del controller e la risposta a schermo. | ON: Contatore visibile | OFF (Default): Contatore non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Se pensi che il gioco sia laggoso, questo ti dirà se è vero o se sei solo scarso.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/Lag/Lag OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : Lag"
echo "  State  : OFF"
echo "  Effect : Input lag counter"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/Lag.ini"
    echo "  [OK] Lag.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/Lag.ini" | sed 's/^/    /'
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
