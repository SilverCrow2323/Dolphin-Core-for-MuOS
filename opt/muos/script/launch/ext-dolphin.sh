#SPDW Factory Lab - Dolphin Core for MuOS (WIP)
#!/bin/bash

. /opt/muos/script/var/func.sh

NAME=$1
CORE=$2
ROM=$3

LOG_INFO "$0" 0 "Content Launch" "DETAIL"
LOG_INFO "$0" 0 "NAME" "$NAME"
LOG_INFO "$0" 0 "CORE" "$CORE"
LOG_INFO "$0" 0 "ROM" "$ROM"

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

# Dolphin.ini (Overclock/CPU per-profilo): se il file del profilo manca si ricade sempre
# sul default, così non resta mai la configurazione dell'ultimo lancio.
case ${CORE} in
	*striker*)
		CONFIG=Dolphin.ini.striker
		;;
	*scaler*)
		CONFIG=Dolphin.ini.scaler
		;;
	*luigismansion*)
		CONFIG=Dolphin.ini.luigismansion
		;;
	*)
		CONFIG=Dolphin.ini.default
		;;
esac
[ -f "$CONFIG" ] || CONFIG=Dolphin.ini.default
cp "$CONFIG" Dolphin.ini

# GFX.ini: stesso pattern — profilo mancante o non riconosciuto => default, mai sticky.
case ${CORE} in
	*speedhack*)
		CONFIG=GFX.ini.speedhacks
		;;
	*blackscreenfix*)
		CONFIG=GFX.ini.blackscreenfix
		;;
	*striker*)
		CONFIG=GFX.ini.striker
		;;
	*scaler*)
		CONFIG=GFX.ini.scaler
		;;
	*luigismansion*)
		CONFIG=GFX.ini.luigismansion
		;;
	*)
		CONFIG=GFX.ini.default
		;;
esac
[ -f "$CONFIG" ] || CONFIG=GFX.ini.default
cp "$CONFIG" GFX.ini

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
	*)
		cp WiimoteNew.ini.${NUMSTICKS}joy WiimoteNew.ini
		;;
esac

cd ..

/opt/muos/script/mux/track.sh "$NAME" "$CORE" "$ROM" start

/opt/muos/bin/gptokeyb dolphin -c "/opt/muos/share/emulator/gptokeyb/ext-dolphin.gptk" &
GPTOKEYB_PID=$!

"./dolphin" -e "$ROM" -u "$EMUDIR"

kill -9 $GPTOKEYB_PID 2>/dev/null

/opt/muos/script/mux/track.sh "$NAME" "$CORE" "$ROM" stop

unset SDL_GAMECONTROLLERCONFIG_FILE SDL_HQ_SCALER SDL_ROTATION SDL_BLITTER_DISABLED
