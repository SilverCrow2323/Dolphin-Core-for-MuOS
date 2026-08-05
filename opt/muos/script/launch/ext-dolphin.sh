#SPDW Factory Lab - Dolphin Core for MuOS (WIP)
#!/bin/bash

. /opt/muos/script/var/func.sh

NAME=$1
CORE=$2
ROM=$3

LOG_INFO "$0" 0 "Content Launch" "DETAIL"
LOG_INFO "$0" 0 "NAME" "$NAME"
LOG_INFO "$0" 0 "CORE" "$CORE"
LOG_INFO "$0" 0 "FILE" "$FILE"

NUMSTICKS=$(cat /opt/muos/device/config/board/stick)

HOME="$(GET_VAR "device" "board/home")"
export HOME

EMUDIR="/opt/muos/share/emulator/dolphin"
SDL_GAMECONTROLLERCONFIG_FILE="/usr/lib32/gamecontrollerdb.txt"

if [ "$(GET_VAR "global" "boot/device_mode")" -eq 1 ]; then
        SDL_HQ_SCALER=2
        SDL_ROTATION=0
        SDL_BLITTER_DISABLED=1
else
        SDL_HQ_SCALER="$(GET_VAR "device" "sdl/scaler")"
        SDL_ROTATION="$(GET_VAR "device" "sdl/rotation")"
        SDL_BLITTER_DISABLED="$(GET_VAR "device" "sdl/blitter_disabled")"
fi

export SDL_GAMECONTROLLERCONFIG_FILE SDL_HQ_SCALER SDL_ROTATION SDL_BLITTER_DISABLED
SET_VAR "system" "foreground_process" "dolphin"

chmod +x "$EMUDIR"/dolphin
cd "$EMUDIR" || exit

cd Config

# Dolphin.ini (Overclock/CPU per-profilo — se nessun ramo combacia resta quello dell'ultimo lancio, per questo defaultgfx/speedhack/blackscreenfix devono SEMPRE ripristinare esplicitamente il default)
case ${CORE} in
	*striker*)
		cp Dolphin.ini.striker Dolphin.ini
		;;
	*scaler*)
		cp Dolphin.ini.scaler Dolphin.ini
		;;
	*luigismansion*)
		cp Dolphin.ini.luigismansion Dolphin.ini
		;;
	*)
		cp Dolphin.ini.default Dolphin.ini
		;;
esac

# GFX.ini
case ${CORE} in
	*defaultgfx*)
		cp GFX.ini.default GFX.ini
		;;
	*speedhack*)
		cp GFX.ini.speedhacks GFX.ini
		;;
	*blackscreenfix*)
		cp GFX.ini.blackscreenfix GFX.ini
		;;
	*striker*)
		cp GFX.ini.striker GFX.ini
		;;
	*scaler*)
		cp GFX.ini.scaler GFX.ini
		;;
	*luigismansion*)
		cp GFX.ini.luigismansion GFX.ini
		;;
esac

# GCPadNew.ini
cp GCPadNew.ini.${NUMSTICKS}joy GCPadNew.ini

# WiimoteNew.ini
case ${CORE} in
	*upright*)
		cp WiimoteNew.ini.${NUMSTICKS}joy WiimoteNew.ini
		;;
	*sideways*)
		cp WiimoteNew.ini.${NUMSTICKS}joy.sideways WiimoteNew.ini
		;;
esac

cd ..

/opt/muos/script/mux/track.sh "$NAME" "$CORE" "$FILE" start

/opt/muos/bin/gptokeyb dolphin -c "/opt/muos/share/emulator/gptokeyb/ext-dolphin.gptk" &
GPTOKEYB_PID=$!

"./dolphin" -e "$ROM" -u "$EMUDIR"

kill -9 $GPTOKEYB_PID 2>/dev/null

/opt/muos/script/mux/track.sh "$NAME" "$CORE" "$FILE" stop

unset SDL_GAMECONTROLLERCONFIG_FILE SDL_HQ_SCALER SDL_ROTATION SDL_BLITTER_DISABLED
