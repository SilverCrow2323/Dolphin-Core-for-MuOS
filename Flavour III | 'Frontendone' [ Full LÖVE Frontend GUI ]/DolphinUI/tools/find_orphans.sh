#!/bin/bash
cd "$(dirname "$0")/.."
find frontend -name "*.lua" -type f | while read -r f; do
  mod=$(echo "$f" | sed 's|^frontend/||; s|\.lua$||; s|/|.|g')
  refs=$(grep -rl "require.*[\"']$mod[\"']" frontend --include="*.lua" 2>/dev/null | wc -l)
  if [ "$refs" -eq 0 ]; then
    echo "ORPHAN: $f"
  fi
done
