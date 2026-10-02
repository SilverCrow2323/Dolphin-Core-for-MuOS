#!/usr/bin/env bash
# dev.sh — DolphinUI development helper.
#
# Every invocation writes a detailed, ordered log to:
#   <root>/.pclogs/dev_<YYYYMMDD>_<HHMMSS>_<cmd>.log
#
# A symlink `.pclogs/latest.log` always points to the newest log.
# Old logs are rotated: the 50 most recent are kept.
#
# Subcommands:
#   run [WxH]   Launch LÖVE (default 640x480)
#   check       Syntax-check all Lua files
#   clean       Rotate logs (dev.sh and LÖVE)
#   shell       Open a shell in frontend/
#   logs        Show the tail of the latest log
#
# The log format:
#   ┌ header (command, timestamp, host, env)
#   ├ environment (love / luajit / luac / git versions)
#   ├ [section header for the command]
#   ├ [command output — full stdout + stderr]
#   ├ summary (exit code, duration)
#   └ end of log

set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
GAME_DIR="$ROOT/frontend"
LOG_DIR_GAME="$GAME_DIR/data/logs"
PC_LOGS="$ROOT/.pclogs"

CMD="${1:-run}"
shift 2>/dev/null || true
[ -z "$CMD" ] && CMD="run"

mkdir -p "$PC_LOGS"

TS="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$PC_LOGS/dev_${TS}_${CMD}.log"
LATEST="$PC_LOGS/latest.log"

# ── Subcommands ─────────────────────────────────────────────
need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }

clean_logs() {
  # LÖVE logs: keep 7 days.
  if [ -d "$LOG_DIR_GAME" ]; then
    find "$LOG_DIR_GAME" -type f -name "*.log" -mtime +7 -delete 2>/dev/null || true
    echo "LÖVE logs older than 7 days cleaned in $LOG_DIR_GAME"
  fi
  # dev.sh logs: keep 50 most recent.
  if [ -d "$PC_LOGS" ]; then
    local n
    n=$(ls -1 "$PC_LOGS"/dev_*.log 2>/dev/null | wc -l)
    ls -1t "$PC_LOGS"/dev_*.log 2>/dev/null | tail -n +51 | while read -r f; do
      rm -f "$f"
    done
    echo "dev.sh logs: $n present, kept 50 most recent"
  fi
}

check_lua() {
  local CHECK total failed
  if command -v luajit >/dev/null 2>&1; then
    CHECK="luajit -bl"
  elif command -v luac5.1 >/dev/null 2>&1; then
    CHECK="luac5.1 -p"
  else
    need luac
    CHECK="luac -p"
    echo "  ! luajit not found — using $(luac -v 2>&1 | head -1)"
  fi

  total=0
  failed=0
  while IFS= read -r -d '' f; do
    total=$((total + 1))
    if ! $CHECK "$f" >/dev/null 2>&1; then
      echo "  ✗ $f"
      $CHECK "$f" 2>&1 | head -3 | sed 's/^/      /'
      failed=$((failed + 1))
    fi
  done < <(find "$GAME_DIR" -name '*.lua' -type f -print0)

  echo
  if [ "$failed" = "0" ]; then
    echo "  ✅ All $total Lua files OK"
  else
    echo "  ❌ $failed/$total files with errors"
    return 1
  fi
}

run_love() {
  need love
  cd "$GAME_DIR"
  love . "${@:-640x480}"
}

open_shell() {
  cd "$GAME_DIR"
  exec "${SHELL:-/bin/sh}"
}

tail_latest() {
  if [ -f "$LATEST" ]; then
    tail -n 80 "$LATEST"
  else
    echo "(no log yet)"
  fi
}

# ── Work body (everything inside is logged) ─────────────────
do_work() {
  local t0 t1 dt rc

  # ── Header ────────────────────────────────────────────────
  echo "================================================================"
  echo "  DolphinUI — dev.sh"
  echo "================================================================"
  printf "  %-14s %s\n" "Command :" "$CMD"
  printf "  %-14s %s\n" "Date    :" "$(date '+%F %T')"
  printf "  %-14s %s\n" "Host    :" "$(uname -srm)"
  printf "  %-14s %s\n" "Shell   :" "bash ${BASH_VERSION}"
  printf "  %-14s %s\n" "Root    :" "$ROOT"
  printf "  %-14s %s\n" "Log     :" "$LOG_FILE"
  echo "================================================================"
  echo

  # ── Environment ───────────────────────────────────────────
  echo "── Environment ────────────────────────────────────────────────"
  if command -v love >/dev/null 2>&1; then
    printf "  %-14s %s\n" "love:" "$(love --version 2>&1 | head -1)"
  else
    printf "  %-14s %s\n" "love:" "(not found)"
  fi
  if command -v luajit >/dev/null 2>&1; then
    printf "  %-14s %s\n" "luajit:" "$(luajit -v 2>&1 | head -1)"
  else
    printf "  %-14s %s\n" "luajit:" "(not found)"
  fi
  if command -v luac >/dev/null 2>&1; then
    printf "  %-14s %s\n" "luac:" "$(luac -v 2>&1 | head -1)"
  else
    printf "  %-14s %s\n" "luac:" "(not found)"
  fi
  if command -v git >/dev/null 2>&1 && [ -d "$ROOT/.git" ]; then
    printf "  %-14s %s\n" "git HEAD:" "$(git -C "$ROOT" log -1 --oneline 2>/dev/null || echo '?')"
    printf "  %-14s %s\n" "git branch:" "$(git -C "$ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
    local dirty
    dirty=$(git -C "$ROOT" status --porcelain 2>/dev/null | wc -l)
    printf "  %-14s %s\n" "git status:" "$dirty change(s)"
  fi
  echo

  t0=$(date +%s)
  rc=0

  # ── Dispatch ──────────────────────────────────────────────
  case "$CMD" in
    run)
      echo "── Running LÖVE ───────────────────────────────────────────────"
      run_love "$@" || rc=$?
      ;;
    check)
      echo "── Lua syntax check ───────────────────────────────────────────"
      check_lua || rc=$?
      ;;
    clean)
      echo "── Cleaning logs ──────────────────────────────────────────────"
      clean_logs || rc=$?
      ;;
    shell)
      echo "── Opening shell in $GAME_DIR ─────────────────────────────────"
      open_shell
      rc=$?
      ;;
    logs)
      echo "── Tail of latest log ─────────────────────────────────────────"
      tail_latest
      ;;
    *)
      echo "── Usage ──────────────────────────────────────────────────────"
      echo "Usage: $0 {run|check|clean|shell|logs} [args]"
      echo
      echo "  run [WxH]   Launch LÖVE (default 640x480)"
      echo "  check       Syntax-check all Lua files"
      echo "  clean       Rotate dev.sh and LÖVE logs"
      echo "  shell       Open a shell in frontend/"
      echo "  logs        Tail the latest dev.sh log"
      rc=1
      ;;
  esac

  t1=$(date +%s)
  dt=$((t1 - t0))

  echo
  echo "── Summary ────────────────────────────────────────────────────"
  printf "  %-14s %d\n" "Exit code :" "$rc"
  printf "  %-14s %ds\n" "Duration  :" "$dt"
  printf "  %-14s %s\n" "Log saved :" "$LOG_FILE"
  echo "================================================================"

  return "$rc"
}

# ── Run do_work, tee everything, capture exit code ──────────
set +e
do_work "$@" 2>&1 | tee "$LOG_FILE"
RC=${PIPESTATUS[0]}
set -e

# Refresh the latest.log symlink (relative, so the dir is movable).
ln -sf "$(basename "$LOG_FILE")" "$LATEST"

# Append end-of-log footer (after tee, so it isn't duplicated).
{
  echo
  echo "================================================================"
  echo "  END OF LOG"
  printf "  %-14s %d\n" "Exit code :" "$RC"
  printf "  %-14s %s\n" "Time      :" "$(date '+%F %T')"
  echo "================================================================"
} >> "$LOG_FILE"

echo
echo "Log       : $LOG_FILE"
echo "Latest    : $LATEST"

exit "$RC"