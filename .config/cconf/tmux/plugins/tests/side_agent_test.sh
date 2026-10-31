#!/usr/bin/env bash
set -euo pipefail

plugin_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script="$plugin_dir/side-agent.sh"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/bin" "$tmpdir/home/.pi/agent/sessions" "$tmpdir/project"
cat > "$tmpdir/bin/mock-agent" <<'MOCK_AGENT'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$(basename -- "$0")" "$@" > "$CALL_LOG"
MOCK_AGENT
chmod +x "$tmpdir/bin/mock-agent"
ln -s mock-agent "$tmpdir/bin/pi"
ln -s mock-agent "$tmpdir/bin/codex"

run_case() {
  local expected="$1"
  shift
  local log="$tmpdir/call.log"
  : > "$log"
  (
    cd "$tmpdir/project"
    HOME="$tmpdir/home" PATH="$tmpdir/bin:$PATH" CALL_LOG="$log" "$script" "$@"
  )
  if [[ "$(<"$log")" != "$expected" ]]; then
    printf 'FAIL: expected call:\n%s\nreceived:\n%s\n' "$expected" "$(<"$log")" >&2
    exit 1
  fi
}

run_case $'codex\nfork\n--last' codex
printf 'PASS: Codex forks its latest session\n'

project_key="$(printf '%s' "$tmpdir/project" | sed 's|^/||;s|/|-|g;s|:|-|g')"
session_dir="$tmpdir/home/.pi/agent/sessions/--${project_key}--"
mkdir -p "$session_dir"
printf 'older\n' > "$session_dir/older.jsonl"
printf 'newer\n' > "$session_dir/newer.jsonl"
touch -t 202001010000 "$session_dir/older.jsonl"
touch -t 202101010000 "$session_dir/newer.jsonl"
run_case "$(printf 'pi\n--fork\n%s' "$session_dir/newer.jsonl")" pi
printf 'PASS: Pi forks the newest session for the current directory\n'

run_case $'pi' shell
printf 'PASS: an unrecognized command starts a fresh Pi session\n'

empty_home="$tmpdir/empty-home"
mkdir -p "$empty_home"
log="$tmpdir/call.log"
: > "$log"
(
  cd "$tmpdir/project"
  HOME="$empty_home" PATH="$tmpdir/bin:$PATH" CALL_LOG="$log" "$script" pi
)
if [[ "$(<"$log")" != pi ]]; then
  printf 'FAIL: Pi with no saved session should start fresh\n' >&2
  exit 1
fi
printf 'PASS: Pi starts fresh when no saved session exists\n'
