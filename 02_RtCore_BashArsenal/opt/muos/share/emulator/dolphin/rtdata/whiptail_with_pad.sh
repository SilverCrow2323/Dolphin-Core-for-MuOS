#!/bin/sh
# ============================================================
# whiptail_with_pad.sh
# Wrapper: starts gptokeyb2 with whiptail.gptk, runs whiptail,
# then kills gptokeyb2. Allows gamepad navigation of whiptail.
# ============================================================

GPTBIN="/mnt/mmc/MUOS/PortMaster/gptokeyb2"
GPTLIB="/mnt/mmc/MUOS/PortMaster/libinterpose.aarch64.so"
GPTLIB_DST="/usr/lib/libinterpose.aarch64.so"
GPTK="/opt/muos/share/emulator/gptokeyb/whiptail.gptk"

# Ensure libinterpose symlink exists
if [ -f "$GPTLIB" ] && [ ! -e "$GPTLIB_DST" ]; then
    ln -sf "$GPTLIB" "$GPTLIB_DST" 2>/dev/null
fi

# Start gptokeyb2 in background
"$GPTBIN" whiptail -c "$GPTK" >/dev/null 2>&1 &
GPT_PID=$!
sleep 0.4

# Run whiptail passing all arguments through
whiptail "$@"
RC=$?

# Kill gptokeyb2
kill -9 "$GPT_PID" 2>/dev/null
pkill -9 -f "gptokeyb2 whiptail" 2>/dev/null

exit $RC
