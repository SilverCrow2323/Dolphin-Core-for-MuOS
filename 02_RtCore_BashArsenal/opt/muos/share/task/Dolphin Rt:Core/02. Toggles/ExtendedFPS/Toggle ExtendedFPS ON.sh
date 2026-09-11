#!/bin/sh
# HELP: Toggle ExtendedFPS | Mostra FPS/VPS/Speed estesi nell'interfaccia | Funzionalità: Extended FPS info | Descrizione: Aggiunge nella barra dell'interfaccia informazioni dettagliate su FPS, VPS e velocità di emulazione. | ON: Info estese visibili | OFF (Default): Solo FPS base | Risorse: Minime | Downside: Nessuno | MINORU's Quick Lesson: Se ti piace guardare i numeri mentre giochi, accomodati. Altrimenti, non cambierà la tua vita. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : ExtendedFPS
#     Funzionalità: Extended FPS info | Descrizione: Aggiunge nella barra dell'interfaccia informazioni dettagliate su FPS, VPS e velocità di emulazione. | ON: Info estese visibili | OFF (Default): Solo FPS base | Risorse: Minime | Downside: Nessuno | MINORU's Quick Lesson: Se ti piace guardare i numeri mentre giochi, accomodati. Altrimenti, non cambierà la tua vita.
#
#  - Stato  : ON
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/ExtendedFPS/ExtendedFPS ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : ExtendedFPS"
echo "  State  : ON"
echo "  Effect : Detailed FPS / VPS / Speed in the interface"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/ExtendedFPS.ini"
    echo "  [OK] ExtendedFPS.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/ExtendedFPS.ini" | sed 's/^/    /'
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
