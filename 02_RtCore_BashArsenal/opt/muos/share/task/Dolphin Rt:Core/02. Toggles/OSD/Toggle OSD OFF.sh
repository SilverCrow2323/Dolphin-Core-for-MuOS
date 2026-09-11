#!/bin/sh
# HELP: Toggle OSD | Messaggi on-screen durante il gioco | Funzionalità: On-Screen Display messages | Descrizione: Mostra notifiche a schermo per eventi come salvataggi di stato, caricamenti, modifiche di impostazioni. | ON: Messaggi visibili | OFF (Default): Nessun messaggio | Risorse: Trascurabili | Downside: Possono coprire parte del gioco per qualche secondo | MINORU's Quick Lesson: Utile per confermare che il salvataggio di stato è andato a buon fine. Se lo disattivi, non lamentarti se non sai se hai salvato o meno. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : OSD
#     Funzionalità: On-Screen Display messages | Descrizione: Mostra notifiche a schermo per eventi come salvataggi di stato, caricamenti, modifiche di impostazioni. | ON: Messaggi visibili | OFF (Default): Nessun messaggio | Risorse: Trascurabili | Downside: Possono coprire parte del gioco per qualche secondo | MINORU's Quick Lesson: Utile per confermare che il salvataggio di stato è andato a buon fine. Se lo disattivi, non lamentarti se non sai se hai salvato o meno.
#
#  - Stato  : OFF
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/OSD/OSD OFF.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : OSD"
echo "  State  : OFF"
echo "  Effect : In-game on-screen messages"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/OSD.ini"
    echo "  [OK] OSD.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/OSD.ini" | sed 's/^/    /'
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
