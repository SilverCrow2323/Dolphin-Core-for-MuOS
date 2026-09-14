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
echo "  TOGGLES - DISPLAY OVERLAYS"
echo "------------------------------------------------------------"
echo "  These write to GFX.ini (and its profile variants)."
echo ""
echo "  FPS (ShowFPS)"
echo "    Frames-per-second counter. Cost: minimal. Recommended: ON."
echo ""
echo "  VPS (ShowVPS)"
echo "    Vertical sync rate. Cost: minimal. Use when chasing stutter."
echo ""
echo "  Speed (ShowSpeed)"
echo "    Emulation speed %. Cost: minimal. Useful to spot CPU bottleneck."
echo ""
echo "  OverlayStats (OverlayStats)"
echo "    Full stats overlay. Cost: moderate. Diagnostic use only."
echo ""
echo "  OverlayProjStats (OverlayProjStats)"
echo "    Projection stats. Cost: moderate. Debug only."
echo ""
echo "  FrameTimes (LogRenderTimeToFile)"
echo "    Logs render time per frame. May introduce micro-stutter."
echo ""
echo "  FrameCount (ShowFrameCount)"
echo "    Total frames this session. Negligible cost. Rarely useful."
echo ""
echo "  ExtendedFPS (ExtendedFPSInfo)"
echo "    Detailed FPS/VPS/Speed. Negligible cost."
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
