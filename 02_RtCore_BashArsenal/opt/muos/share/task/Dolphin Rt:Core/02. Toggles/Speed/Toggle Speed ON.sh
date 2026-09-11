#!/bin/sh
# HELP: Toggle Speed | Mostra la percentuale di velocità di emulazione | Funzionalità: Speed percentage overlay | Descrizione: Indica se l'emulatore sta girando al 100% o se è in affanno (es. 87%). Fondamentale per capire se il collo di bottiglia è la CPU. | ON: Percentuale visibile a schermo | OFF (Default): Overlay non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Se vedi 99-100% sei a posto. Se vedi 85% e il gioco va lento, non è colpa della ROM. È il tuo H700 che piange. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : Speed
#     Funzionalità: Speed percentage overlay | Descrizione: Indica se l'emulatore sta girando al 100% o se è in affanno (es. 87%). Fondamentale per capire se il collo di bottiglia è la CPU. | ON: Percentuale visibile a schermo | OFF (Default): Overlay non attivo | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Se vedi 99-100% sei a posto. Se vedi 85% e il gioco va lento, non è colpa della ROM. È il tuo H700 che piange.
#
#  - Stato  : ON
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/Speed/Speed ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : Speed"
echo "  State  : ON"
echo "  Effect : Emulation speed percentage display"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/Speed.ini"
    echo "  [OK] Speed.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/Speed.ini" | sed 's/^/    /'
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
