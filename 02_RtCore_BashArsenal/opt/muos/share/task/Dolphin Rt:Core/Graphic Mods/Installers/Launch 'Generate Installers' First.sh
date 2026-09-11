#!/bin/sh
# HELP: Finally. Your chance has come.
#
#  To meet the one and only. The magnanimous. The sensei.
#
#  RUNGIF.
#
#  ------------------------------------------------------------
#  WHO HE IS
#  ------------------------------------------------------------
#
#    ...who knows?!
#
#    An individual. Or an entity.
#    A walker in the unknown paths of life.
#
#    Apparently, he has been living in this folder lately.
#    This empty, quiet folder.
#
#    He waits. He lectures. He teaches.
#
#  ------------------------------------------------------------
#  WHAT HE WILL DO FOR YOU
#  ------------------------------------------------------------
#
#    Sigh at your arrival.
#
#    He may tell you what you were supposed to do.
#    Maybe not.
#
#    Maybe he is not here.
#    Maybe he does not exist.
#
#    For certain, he resides in the hearts of the lost ones.
#
#    With his typical appearance — yes, that persona you have
#    known since never in your life. With the exact expression
#    and gaze that look exactly how you imagine them.
#
#    Maybe.
#    Or maybe not.
#
#  ------------------------------------------------------------
#  - Rungif
#
#    Uncle. Sensei. Magnanimous. Aiming to the Top.
#
#    Gunbuster. Die, Buster. Master. Devaster. Stratocaster.
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  
#

. /opt/muos/script/var/func.sh
FRONTEND stop

SELF_DIR="/opt/muos/share/task/Dolphin Rt:Core/Graphic Mods"
GEN="$SELF_DIR/Generate Installers.sh"

clear

# --- Visual novel pacing helper ---
say() { echo "$1"; sleep "${2:-1.4}"; }

echo "==============================================="
say "  Dolphin Rt:Core - RUNGIF" 0.8
say "  Chapter One: The First Encounter" 2.5
echo "==============================================="
echo ""
sleep 1

say "Finally..." 2
say "...the moment has arrived." 2.5
echo ""
say "You. A wanderer. Alone in an empty Installers folder." 2.5
say "Me. RUNGIF." 1.8
say "The one and only." 1.4
say "The magnanimous." 1.4
say "The sensei." 2.5
echo ""
sleep 1

say "And you were supposed to go back one folder." 2
say "And launch: Generate Installers." 2.5
echo ""
say "But you did not." 2.5
echo ""
say "..." 1.2
say "." 1.2
say "." 1.2
say "." 2
echo ""
say "Come on now, you fool of the west." 2
say "Old uncle Rungif will take care of it." 2.5
echo ""
sleep 1

if [ ! -f "$GEN" ]; then
    say "  [ERR] Generate Installers.sh not found at:" 1.5
    say "        $GEN" 2
    echo ""
    say "Even RUNGIF has limits." 2.5
    sleep 4
    FRONTEND start task
    exit 1
fi

say "  Launching Generate Installers..." 2
echo ""

# ---- Hand over the work ----
sh "$GEN"

# ---- Farewell ----
sleep 1
echo ""
echo "==============================================="
say "  ...it is done." 2
echo "==============================================="
echo ""
say "Farewell, boy." 2.5
say "It has been brief..." 2
say "...and, from my side, not intense at all." 2
say "Hohoho-ha!" 2.5
echo ""
say "This is a goodbye, boy." 2
say "But the road of life..." 2
say "...you never know where it may take you." 3
echo ""
sleep 2

FRONTEND start task
exit 0
