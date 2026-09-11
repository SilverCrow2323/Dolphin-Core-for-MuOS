#!/bin/sh
# HELP: Toggle FrameCount | Contatore di frame | Funzionalità: Frame counter | Descrizione: Mostra il numero totale di frame renderizzati dall'inizio della sessione. | ON: Contatore visibile | OFF (Default): Contatore non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Numeri grandi fanno impressione. Ma non servono a niente. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : FrameCount
#     Funzionalità: Frame counter | Descrizione: Mostra il numero totale di frame renderizzati dall'inizio della sessione. | ON: Contatore visibile | OFF (Default): Contatore non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Numeri grandi fanno impressione. Ma non servono a niente.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/FrameCount/FrameCount OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : FrameCount"
echo "  State  : OFF"
echo "  Effect : Frame counter"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/FrameCount.ini"
    echo "  [OK] FrameCount.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/FrameCount.ini" | sed 's/^/    /'
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
