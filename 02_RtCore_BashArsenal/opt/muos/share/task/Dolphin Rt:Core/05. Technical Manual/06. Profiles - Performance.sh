#!/bin/sh
# HELP: Technical Manual | Read-only reference page.
# ICON: diagnostic
. /opt/muos/script/var/func.sh
FRONTEND stop

ORIG_FONT=""
[ -r /etc/vconsole.conf ] && ORIG_FONT=$(grep -i '^FONT=' /etc/vconsole.conf 2>/dev/null | cut -d= -f2-)

try_font() {
    [ -n "$1" ] || return 1
    for d in /usr/share/consolefonts /usr/share/kbd/consolefonts /usr/lib/kbd/consolefonts; do
        [ -d "$d" ] || continue
        for ext in .psf.gz .psf .fnt .fnt.gz; do
            if [ -f "$d/$1$ext" ] && command -v setfont >/dev/null 2>&1; then
                setfont "$d/$1$ext" 2>/dev/null && return 0
            fi
        done
    done
    return 1
}

FONT_OK=0
for f in ter-132n ter-124n ter-120n ter-116n LatArCyrHeb-22 LatArCyrHeb-19 LatArCyrHeb-16 sun12x22 VGA16; do
    if try_font "$f"; then FONT_OK=1; break; fi
done

clear
echo "============================================================"
echo "  Dolphin Rt:Core v11.0.0 - Technical Manual"
echo "  SPDW Factory Lab / sirpips"
echo "============================================================"
echo ""
echo "  PROFILES - PERFORMANCE"
echo "------------------------------------------------------------"
echo "  Balanced. Daily driver."
echo ""
echo "  LEVELS"
echo "   MIN      Overclock 1.30  SyncGPU ON   2x res"
echo "   -2       Overclock 1.20  SyncGPU ON   2x res"
echo "   -1       Overclock 1.10  SyncGPU ON   1x res"
echo "   standard Overclock 1.00  SyncGPU OFF  1x res"
echo "   +1       Overclock 0.90  SyncGPU OFF  1x res"
echo "   +2       Overclock 0.80  SyncGPU OFF  1x res"
echo "   MAX      Overclock 0.70  SyncGPU OFF  1x res"
echo ""

echo ""
echo "============================================================"
echo "  End of page. Closing in 10 seconds..."
echo "============================================================"
sleep 10
if [ "$FONT_OK" = "1" ] && [ -n "$ORIG_FONT" ] && command -v setfont >/dev/null 2>&1; then
    setfont "$ORIG_FONT" 2>/dev/null || true
fi
FRONTEND start task
exit 0
