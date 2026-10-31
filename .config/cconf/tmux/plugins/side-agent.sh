#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  codex)
    exec codex fork --last
    ;;
  pi)
    project_key="$(pwd -P | sed 's|^/||;s|/|-|g;s|:|-|g')"
    session_dir="$HOME/.pi/agent/sessions/--${project_key}--"
    latest="$(find "$session_dir" -maxdepth 1 -type f -name '*.jsonl' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 1 | cut -d ' ' -f 2-)" || true
    if [[ -n "$latest" ]]; then
      exec pi --fork "$latest"
    fi
    ;;
esac

exec pi
