#!/bin/sh
# HELP: Device Report | Funzionalità: Report diagnostico del device | Descrizione: Raccoglie info su sistema, hardware, input, emulatori. | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Utile per bug report. O per scoprire che il tuo device è più strano di quanto pensassi.
# ICON: diagnostic
#
# ============================================================
#  [Bash Arsenal | Rt:CORE Sector]
# ============================================================
#
#  - Tool : Device Report
#    Device Report | Funzionalità: Report diagnostico del device | Descrizione: Raccoglie info su sistema, hardware, input, emulatori. | Risorse: Nessuna | Downside: Nessuno | MINORU's Quick Lesson #001: Utile per bug report. O per scoprire che il tuo device è più strano di quanto pensassi.
#
. /opt/muos/script/var/func.sh 2>/dev/null

LOGDIR="/opt/muos/share/task/Dolphin Rt:Core/Log & Reports/"
[ -d "$LOGDIR" ] || LOGDIR="/tmp"
OUT="$LOGDIR/Device Sbrobbing Report.log"
TMP="/tmp/device_sbrobbing.log"

# ---- Wrapper: write to both file and screen ----
SEC() {
    echo ""
    echo "============================================================"
    echo "  $1"
    echo "============================================================"
    {
        echo ""
        echo "============================================================"
        echo "  $1"
        echo "============================================================"
    } >> "$TMP"
}

SUB() {
    echo ""
    echo "--- $1 ---"
    {
        echo ""
        echo "--- $1 ---"
    } >> "$TMP"
}

P() {
    echo "$@"
    echo "$@" >> "$TMP"
}

RUN() {
    # run command, show output, log it
    "$@" 2>&1 | while IFS= read -r line; do
        echo "$line"
        echo "$line" >> "$TMP"
    done
}

CMDOUT() {
    # capture stdout of command
    "$@" 2>&1
}

CMDOUT_LOG() {
    OUTV=$(CMDOUT "$@")
    echo "$OUTV"
    echo "$OUTV" >> "$TMP"
}

# ============================================================
: > "$TMP"

SEC "Device Sbrobbing Report"
P "Date     : $(date)"
P "Uptime   : $(cat /proc/uptime 2>/dev/null | awk '{print $1}') s"
P "Hostname : $(hostname 2>/dev/null)"
P "Kernel   : $(uname -a)"
P "Reporter : SPDW Factory Lab / sirpips"

# ============================================================
SEC "1. SYSTEM IDENTITY"

SUB "os-release"
[ -f /etc/os-release ] && CMDOUT_LOG cat /etc/os-release

SUB "muOS version"
[ -f /opt/muos/config/system/version ] && P "version : $(cat /opt/muos/config/system/version)"
[ -f /opt/muos/config/system/build ]   && P "build   : $(cat /opt/muos/config/system/build)"

SUB "Board / Device"
for f in board/name board/home board/network board/rumble board/hdmi board/udc \
         screen/internal/width screen/internal/height screen/bright screen/colour \
         cpu/governor cpu/default cpu/min_freq cpu/max_freq \
         audio/min audio/max audio/control audio/pf_internal audio/pf_external \
         led/normal led/low led/rgb \
         storage/rom/mount storage/rom/dev storage/rom/num storage/rom/sep \
         storage/sdcard/mount storage/usb/mount \
         network/iface network/iface_active network/name network/type \
         sdl/name sdl/scaler sdl/rotation sdl/blitter_disabled \
         battery/capacity battery/charger battery/boot_mode \
         board/stick; do
    V=$(GET_VAR "device" "$f" 2>/dev/null)
    [ -n "$V" ] && P "device/$f = $V"
done

SUB "Global config"
for f in boot/device_mode boot/first_init boot/factory_reset \
         theme/active; do
    V=$(GET_VAR "global" "$f" 2>/dev/null)
    [ -n "$V" ] && P "global/$f = $V"
done

# ============================================================
SEC "2. HARDWARE"

SUB "CPU"
[ -f /proc/cpuinfo ] && CMDOUT_LOG head -n 30 /proc/cpuinfo

SUB "Memory"
CMDOUT_LOG free -m 2>/dev/null
CMDOUT_LOG cat /proc/meminfo | head -n 15

SUB "Storage mounts"
CMDOUT_LOG df -h

SUB "Block devices"
CMDOUT_LOG cat /proc/partitions

SUB "Thermal zones"
for z in /sys/class/thermal/thermal_zone*; do
    [ -e "$z" ] || continue
    T=$(cat "$z/temp" 2>/dev/null)
    N=$(cat "$z/type" 2>/dev/null)
    P "$(basename $z) ($N) = $T"
done

SUB "Battery"
for f in /sys/class/power_supply/*; do
    [ -d "$f" ] || continue
    P "$(basename $f):"
    for k in capacity status voltage_now current_now health; do
        [ -f "$f/$k" ] && P "  $k = $(cat $f/$k 2>/dev/null)"
    done
done

# ============================================================
SEC "3. INPUT DEVICES (critical for key handling)"

SUB "/proc/bus/input/devices"
[ -f /proc/bus/input/devices ] && CMDOUT_LOG cat /proc/bus/input/devices

SUB "/dev/input/*"
CMDOUT_LOG ls -la /dev/input/

SUB "/dev/input/js*"
CMDOUT_LOG ls -la /dev/input/js* 2>/dev/null

SUB "Joystick device names (sysfs)"
for d in /dev/input/event*; do
    [ -e "$d" ] || continue
    N=$(cat /sys/class/input/$(basename $d)/device/name 2>/dev/null)
    P "$d = $N"
done

SUB "evtest available?"
command -v evtest >/dev/null 2>&1 && P "evtest: yes ($(command -v evtest))" || P "evtest: NO"

SUB "sdl2-jstest available?"
command -v sdl2-jstest >/dev/null 2>&1 && P "sdl2-jstest: yes" || P "sdl2-jstest: NO"
[ -x /opt/muos/bin/sdl2-jstest ] && P "sdl2-jstest (muos): /opt/muos/bin/sdl2-jstest"

SUB "jstest available?"
command -v jstest >/dev/null 2>&1 && P "jstest: yes" || P "jstest: NO"

SUB "Joystick list (if sdl2-jstest works)"
[ -x /opt/muos/bin/sdl2-jstest ] && CMDOUT_LOG /opt/muos/bin/sdl2-jstest --list

# ============================================================
SEC "4. GPTKEYB / INPUT MAPPING"

SUB "gptokeyb2 binaries"
CMDOUT_LOG ls -la /mnt/mmc/MUOS/PortMaster/gptokeyb2 2>/dev/null
CMDOUT_LOG ls -la /mnt/mmc/MUOS/PortMaster/libinterpose.aarch64.so 2>/dev/null
CMDOUT_LOG ls -la /opt/muos/bin/gptokeyb 2>/dev/null

SUB "gptokeyb .gptk files"
CMDOUT_LOG ls -la /opt/muos/share/emulator/gptokeyb/ 2>/dev/null
CMDOUT_LOG find /opt/muos -name "*.gptk" 2>/dev/null

SUB "gptokeyb2 --help"
[ -x /mnt/mmc/MUOS/PortMaster/gptokeyb2 ] && CMDOUT_LOG /mnt/mmc/MUOS/PortMaster/gptokeyb2 --help 2>&1 | head -n 20

SUB "Hotkey JSON files"
CMDOUT_LOG ls -la /opt/muos/share/hotkey/ 2>/dev/null
for f in /opt/muos/share/hotkey/*.json; do
    [ -f "$f" ] || continue
    P "--- $f ---"
    CMDOUT_LOG cat "$f"
done

SUB "Hotkey INI files"
for f in /opt/muos/share/hotkey/*.ini; do
    [ -f "$f" ] || continue
    P "--- $f ---"
    CMDOUT_LOG cat "$f"
done

SUB "muhotkey binary"
CMDOUT_LOG ls -la /opt/muos/frontend/muhotkey 2>/dev/null
[ -x /opt/muos/frontend/muhotkey ] && CMDOUT_LOG /opt/muos/frontend/muhotkey --help 2>&1 | head -n 20

SUB "hotkey.sh script"
CMDOUT_LOG sed -n '1,80p' /opt/muos/script/mux/hotkey.sh 2>/dev/null

# ============================================================
SEC "5. ICONS (the hunt)"

SUB "Search for icon folders"
for d in /opt/muos/share/themes /opt/muos/share/icons /opt/muos/share/gui \
         /opt/muos/share/theme /opt/muos/theme /opt/muos/config/theme \
         /opt/muos/share/catalogue; do
    [ -d "$d" ] && P "FOUND: $d" && CMDOUT_LOG ls -la "$d"
done

SUB "Find PNGs matching task icon names"
find / \( -path /proc -o -path /sys -o -path /dev -o -path /mnt \) -prune -o \
    -type f -name "*.png" -print 2>/dev/null \
    | grep -Ei "diagnostic|backup|theme|network|retroarch|junk|sdcard|storage|hotspot|ethernet|clear|task" | head -n 60

SUB "All task-related folders"
find / -type d -name "task" 2>/dev/null | head -n 20

SUB "Sample task icons from ROM storage"
find /mnt/mmc/MUOS -type d -name "*icon*" 2>/dev/null | head -n 10
find /mnt/mmc/MUOS -type f -name "*.png" -path "*task*" 2>/dev/null | head -n 20

# ============================================================
SEC "6. EMULATORS"

for EMU in dolphin drastic-trngaje drastic-legacy mupen64plus ppsspp \
           flycast yabasanshiro scummvm amiberry openbor pico8 \
           retroarch freej2me mreader crisp xroar; do

    E="/opt/muos/share/emulator/$EMU"
    [ -d "$E" ] || continue

    SUB "Emulator: $EMU"
    P "Path: $E"
    CMDOUT_LOG ls -la "$E" | head -n 40

    # Config files
    for cfg in "$E"/*.cfg "$E"/*.ini "$E"/.config "$E"/config "$E"/.config/* ; do
        [ -e "$cfg" ] || continue
        P "  cfg: $cfg"
    done
done

SUB "RetroArch cores"
CMDOUT_LOG ls -la /opt/muos/share/core/ 2>/dev/null | head -n 50

SUB "RetroArch binary info"
[ -x /usr/bin/retroarch ] && CMDOUT_LOG /usr/bin/retroarch --version 2>&1 | head -n 5

# ============================================================
SEC "7. PACKAGES & DEPENDENCIES"

SUB "Installed binaries in /usr/bin"
CMDOUT_LOG ls -1 /usr/bin | head -n 200

SUB "Installed binaries in /opt/muos/bin"
CMDOUT_LOG ls -1 /opt/muos/bin | head -n 200

SUB "Shared libraries in /usr/lib (aarch64)"
CMDOUT_LOG ls -1 /usr/lib | head -n 200

SUB "Shared libraries in /usr/lib32 (armhf)"
CMDOUT_LOG ls -1 /usr/lib32 2>/dev/null | head -n 200

SUB "SDL2 libraries"
CMDOUT_LOG find / -name "libSDL2*" 2>/dev/null | head -n 20

SUB "Python version and modules"
command -v python3 >/dev/null 2>&1 && CMDOUT_LOG python3 --version
command -v python3 >/dev/null 2>&1 && python3 -c "import sys; mods=['curses','os','subprocess','struct','select','fcntl']; [print(m, 'OK' if __import__(m) else 'FAIL') for m in mods]" 2>&1 | while read l; do P "$l"; done

SUB "jq / curl / wget / ffmpeg / mpv"
for b in jq curl wget ffmpeg mpv amixer wpctl pipewire wireplumber; do
    if command -v "$b" >/dev/null 2>&1; then
        P "$b: $(command -v $b)"
    else
        P "$b: NOT FOUND"
    fi
done

# ============================================================
SEC "8. RUNNING PROCESSES"

SUB "ps -ef"
CMDOUT_LOG ps -ef 2>/dev/null

SUB "pgrep list of key processes"
for p in muxfrontend frontend.sh muhotkey hotkey.sh gptokeyb2 retroarch dolphin \
         PPSSPP mupen64plus flycast yabasanshiro scummvm amiberry pico8_64 \
         adbd umtprd syncthing pipewire wireplumber; do
    PIDS=$(pgrep -f "$p" 2>/dev/null)
    [ -n "$PIDS" ] && P "$p : $PIDS"
done

# ============================================================
SEC "9. HOW TO READ BUTTONS IN SHELL SCRIPTS (recipe)"

P "Method 1: /dev/input/js* (joystick API, simple)"
P "  - Read 8-byte structs from /dev/input/jsX."
P "  - Each event: time(u32) value(i16) type(u8) number(u8)"
P "  - type & 0x01 == button, value=1 pressed, value=0 released"
P "  - number = button index (device-specific)"
P ""
P "Method 2: /dev/input/event* (evdev API, rich)"
P "  - 16-byte input_event structs: time(16) type(u16) code(u16) value(i32)"
P "  - type EV_KEY (1), code = BTN_* constants, value 1/0"
P "  - Requires knowing the correct event device (see /proc/bus/input/devices)"
P ""
P "Method 3: gptokeyb2 + .gptk mapping (translate pad -> keyboard)"
P "  - gptokeyb2 <name> -c <file.gptk>"
P "  - Input: gamepad buttons (semantic names a, b, x, y, l1...)"
P "  - Output: keyboard events that scripts read via whiptail/curses/read"
P "  - Used by our Overlay Menu"
P ""
P "Method 4: muOS hotkey system (muhotkey + JSON)"
P "  - /opt/muos/share/hotkey/*.json describes combos"
P "  - muhotkey emits events to FIFO /run/muos/hotkey"
P "  - hotkey.sh reads FIFO and triggers actions"
P ""

SUB "Our current calibration (from earlier sessions)"
P "MENU  -> kernel buttons 8 and 13"
P "START -> kernel button 7"

# ============================================================
SEC "10. muOS SCRIPT STRUCTURE (what we found)"

SUB "Directory: /opt/muos/script"
CMDOUT_LOG find /opt/muos/script -maxdepth 2 -type d | sort

SUB "Launchers available"
CMDOUT_LOG ls -1 /opt/muos/script/launch/ 2>/dev/null

SUB "Tasks available"
CMDOUT_LOG find /opt/muos/share/task -type f -name "*.sh" 2>/dev/null | sort

SUB "Function library key exports"
P "func.sh defines:"
for fn in GET_VAR SET_VAR FRONTEND HOTKEY MESSAGE GPTOKEYB \
          SETUP_SDL_ENVIRONMENT CONTENT_UNSET MUXCTL \
          DISPLAY_WRITE DISPLAY_READ RUMBLE FB_SWITCH \
          HDMI_SWITCH SET_DEFAULT_GOVERNOR RESET_AMIXER \
          PARSE_INI LOG_INFO LOG_WARN LOG_ERROR LOG_SUCCESS; do
    grep -q "^$fn()" /opt/muos/script/var/func.sh 2>/dev/null && P "  $fn()"
done

# ============================================================
SEC "11. NETWORK"

SUB "Interfaces"
CMDOUT_LOG ip addr 2>/dev/null

SUB "Routes"
CMDOUT_LOG ip route 2>/dev/null

SUB "WiFi status"
CMDOUT_LOG iw dev 2>/dev/null

SUB "DNS"
CMDOUT_LOG cat /etc/resolv.conf 2>/dev/null

# ============================================================
SEC "12. FONTS (terminal size)"

SUB "Console fonts available"
CMDOUT_LOG ls -la /usr/share/consolefonts/ 2>/dev/null
CMDOUT_LOG ls -la /usr/share/kbd/consolefonts/ 2>/dev/null
CMDOUT_LOG find / -name "*.psf*" 2>/dev/null | head -n 20

SUB "setfont available?"
command -v setfont >/dev/null 2>&1 && P "setfont: yes ($(command -v setfont))" || P "setfont: NO"

SUB "Current framebuffer"
CMDOUT_LOG cat /sys/class/graphics/fb0/virtual_size 2>/dev/null
CMDOUT_LOG cat /sys/class/graphics/fb0/bits_per_pixel 2>/dev/null

# ============================================================
SEC "END OF REPORT"

P "Report complete at $(date)"
P ""
P "Log saved to: $TMP"
P "Persistent:   $OUT"

# ---- Persist final log ----
cp -f "$TMP" "$OUT" 2>/dev/null

echo ""
echo "============================================================"
echo "  Report finished. Copying to persistent storage..."
echo "  $OUT"
echo "============================================================"
sleep 5

exit 0
