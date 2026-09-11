#!/bin/sh
# HELP: Toggle FrameTimes | Logga i tempi di rendering e mostra statistiche overlay | Funzionalità: Frame timing overlay | Descrizione: Registra il tempo impiegato per ogni frame e lo mostra in un overlay dettagliato. Utile per diagnosticare stutter. | ON: Overlay con statistiche di timing | OFF (Default): Overlay non attivo | Risorse: Impatto moderato su CPU e I/O | Downside: Può introdurre micro-stutter a causa del logging | MINORU's Quick Lesson: Usalo solo quando qualcosa scatta e vuoi capire perché. Tenerlo sempre attivo è come andare in autostrada con il cofano aperto per guardare il motore. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : FrameTimes
#     Funzionalità: Frame timing overlay | Descrizione: Registra il tempo impiegato per ogni frame e lo mostra in un overlay dettagliato. Utile per diagnosticare stutter. | ON: Overlay con statistiche di timing | OFF (Default): Overlay non attivo | Risorse: Impatto moderato su CPU e I/O | Downside: Può introdurre micro-stutter a causa del logging | MINORU's Quick Lesson: Usalo solo quando qualcosa scatta e vuoi capire perché. Tenerlo sempre attivo è come andare in autostrada con il cofano aperto per guardare il motore.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/FrameTimes/FrameTimes OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : FrameTimes"
echo "  State  : OFF"
echo "  Effect : Log render times and show overlay stats"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/FrameTimes.ini"
    echo "  [OK] FrameTimes.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/FrameTimes.ini" | sed 's/^/    /'
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
