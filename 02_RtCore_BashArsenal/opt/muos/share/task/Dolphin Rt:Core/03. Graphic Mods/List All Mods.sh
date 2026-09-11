#!/bin/sh
# HELP: List All Mods | Funzionalità: Elenca tutte le mod disponibili | Descrizione: Mostra ogni mod in rtdata/graphic_mods/ con [X] installata e [ ] non installata. | ON: Lista visibile | OFF (Default): Nessuna lista | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Utile per sapere cosa hai installato senza dover aprire ogni cartella.
# ICON: theme
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : List All Mods
#    List All Mods | Funzionalità: Elenca tutte le mod disponibili | Descrizione: Mostra ogni mod in rtdata/graphic_mods/ con [X] installata e [ ] non installata. | ON: Lista visibile | OFF (Default): Nessuna lista | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Utile per sapere cosa hai installato senza dover aprire ogni cartella.
#
. /opt/muos/script/var/func.sh
FRONTEND stop

MODSRC="/opt/muos/share/emulator/dolphin/rtdata/graphic_mods"
MODDST="/opt/muos/share/emulator/dolphin/Load/GraphicMods"

clear
echo "==============================================="
echo "  Dolphin Rt:Core - Available Graphics Mods"
echo "==============================================="
echo ""

echo "  --- All-Games Mods ---"
for d in "$MODSRC/all_games"/*; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    if [ -d "$MODDST/$name" ]; then
        echo "    [X] $name"
    else
        echo "    [ ] $name"
    fi
done

echo ""
echo "  --- Game-Specific Mods ---"
for d in "$MODSRC/game_specific"/*; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    if [ -d "$MODDST/$name" ]; then
        echo "    [X] $name"
    else
        echo "    [ ] $name"
    fi
done

echo ""
echo "  [X] = installed   [ ] = not installed"
echo ""
echo "==============================================="
echo "  Closing in 15 seconds..."
sleep 15

FRONTEND start task
exit 0
