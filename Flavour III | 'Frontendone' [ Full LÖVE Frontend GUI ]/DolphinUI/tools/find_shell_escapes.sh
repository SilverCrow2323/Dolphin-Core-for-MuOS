#!/bin/bash
cd "$(dirname "$0")/.."
echo "=== conteggio os.execute / io.popen per file (fuori da sh.lua) ==="
grep -rl "os\.execute\|io\.popen" frontend --include="*.lua" \
  | grep -v "sh\.lua" \
  | while read -r f; do
      n=$(grep -c "os\.execute\|io\.popen" "$f")
      echo "$n $f"
    done | sort -rn
