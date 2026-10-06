#!/bin/bash
cd "$(dirname "$0")/.."
find frontend -name "*.lua" | while read -r f; do
  dups=$(grep -oE 'local function [a-zA-Z_][a-zA-Z0-9_]*' "$f" \
    | awk '{print $3}' | sort | uniq -d)
  if [ -n "$dups" ]; then
    echo "=== $f ==="
    echo "$dups" | while read -r name; do
      grep -n "local function $name" "$f"
    done
    echo ""
  fi
done
