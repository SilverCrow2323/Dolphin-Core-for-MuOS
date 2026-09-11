#!/bin/sh
# HELP: Toggle OSDDuration | Durata dei messaggi OSD (Short/Normal/Long) | Funzionalità: OSD message duration | Descrizione: Controlla per quanto tempo i messaggi on-screen restano visibili. Short=1s, Normal=2.5s, Long=5s. | ON: Durata selezionata attiva | OFF (Default): Normal (2.5s) | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson: Short se sei impaziente. Long se hai il riflesso lento. Normal se sei una persona normale. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OSDDuration
#     Funzionalità: OSD message duration | Descrizione: Controlla per quanto tempo i messaggi on-screen restano visibili. Short=1s, Normal=2.5s, Long=5s. | ON: Durata selezionata attiva | OFF (Default): Normal (2.5s) | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson: Short se sei impaziente. Long se hai il riflesso lento. Normal se sei una persona normale.
#
#  - Stato  : Long
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OSDDuration/OSDDuration Long.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - OSD Duration"
echo "==============================================="
echo "  State : Long"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OSDDuration.ini"
    echo "  [OK] OSDDuration.ini updated"
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
