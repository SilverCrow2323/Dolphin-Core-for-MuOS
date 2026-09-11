#!/bin/sh
# HELP: Toggle RTC | Orologio in tempo reale nei movie | Funzionalità: Real-time clock in movie playback | Descrizione: Mostra l'orologio di sistema durante la riproduzione di movie (TAS). | ON: Orologio visibile | OFF (Default): Orologio non visibile | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Utile solo se registri TAS. Per il resto, è un orologio che non guarderai mai. | MINORU's Quick Lesson #001
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Toggle : RTC
#     Funzionalità: Real-time clock in movie playback | Descrizione: Mostra l'orologio di sistema durante la riproduzione di movie (TAS). | ON: Orologio visibile | OFF (Default): Orologio non visibile | Risorse: Trascurabili | Downside: Nessuno | MINORU's Quick Lesson: Utile solo se registri TAS. Per il resto, è un orologio che non guarderai mai.
#
#  - Stato  : ON
#
. /opt/muos/script/var/func.sh

FRONTEND stop

EMU="/opt/muos/share/emulator/dolphin"
CFG="$EMU/Config"
SRC="$EMU/rtdata/pocket_workshop/settings/RTC/RTC ON.ini"

echo "==============================================="
echo "  Dolphin Rt:Core v11.0.0 - Toggle"
echo "==============================================="
echo "  Toggle : RTC"
echo "  State  : ON"
echo "  Effect : Real-time clock in movie playback"
echo "==============================================="
echo ""

if [ -f "$SRC" ]; then
    cp "$SRC" "$CFG/RTC.ini"
    echo "  [OK] RTC.ini updated"
    echo ""
    echo "  Current state in Config:"
    grep "^State *=" "$CFG/RTC.ini" | sed 's/^/    /'
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
