#!/usr/bin/env bash
set -euo pipefail

# Copy mode: when the pane is in a mode (copy mode), hints must be computed
# from the mode screen the user is looking at, not from the live pane bottom.

plugin_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script="$plugin_dir/open_editor.sh"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
export TMPDIR="$tmpdir"

repo="$tmpdir/repo"
pane_dir="$repo/subdir"
file="$repo/osac/osac-operator/internal/controller/externalipattachment_controller.go"
mkdir -p "$pane_dir" "$(dirname -- "$file")"
printf 'package controller\n' > "$file"

# The live screen does not show the path; the scrolled copy mode view does.
printf 'prompt output still running\n' > "$tmpdir/visible.txt"
{
  printf 'older output above\n'
  printf ' ../osac/osac-operator/internal/controller/externalipattachment_controller.go:74–138\n'
  printf 'older output below\n'
} > "$tmpdir/copymode.txt"

mkdir -p "$tmpdir/bin" "$tmpdir/pending"
export TEST_PENDING_DIR="$tmpdir/pending" TEST_SCRIPT="$script"

cat > "$tmpdir/bin/tmux" <<'MOCK_TMUX'
#!/usr/bin/env bash
set -euo pipefail

case "$1" in
  display-message)
    for arg in "$@"; do
      case "$arg" in
        '#{pane_id}') printf '%1\n'; exit 0 ;;
        '#{pane_current_path}') printf '%s\n' "$TEST_PANE_PATH"; exit 0 ;;
        '#{pane_width}') printf '200\n'; exit 0 ;;
        '#{pane_height}') printf '30\n'; exit 0 ;;
        '#{window_id}') printf '@1\n'; exit 0 ;;
        '#{session_id}') printf '$1\n'; exit 0 ;;
        '#{pane_in_mode}') printf '%s\n' "${TEST_PANE_IN_MODE:-0}"; exit 0 ;;
        '#{scroll_position}') printf '%s\n' "${TEST_SCROLL_POSITION:-}"; exit 0 ;;
      esac
    done
    ;;
  show-option)
    for arg in "$@"; do
      case "$arg" in
        '@open_editor_pending_'*) [[ -f "$TEST_PENDING_DIR/$arg" ]] && cat "$TEST_PENDING_DIR/$arg"; exit 0 ;;
        '@open_editor_'*) exit 0 ;;
      esac
    done
    printf 'on\n'
    ;;
  set-option)
    shift
    option=""; value=""; unset_option=0
    while (($#)); do
      case "$1" in
        -u|-uq|-qu) unset_option=1; shift ;;
        -t) shift 2 ;;
        -q) shift ;;
        *) if [[ -z "$option" ]]; then option="$1"; else value="$1"; fi; shift ;;
      esac
    done
    if [[ "$option" == @open_editor_pending_* ]]; then
      if ((unset_option)); then rm -f "$TEST_PENDING_DIR/$option"; else printf '%s' "$value" > "$TEST_PENDING_DIR/$option"; fi
    fi
    ;;
  display-menu)
    for arg in "$@"; do
      if [[ "$arg" == *"--open-choice split "* ]]; then
        command="${arg#run-shell -b }"
        command="${command:1:${#command}-2}"
        /bin/bash -c "$command"
      fi
    done
    ;;
  capture-pane)
    if [[ "$*" == *"-S"* ]]; then
      cat "${TEST_PANE_CAPTURE_MODE:-$TEST_PANE_CAPTURE}"
    else
      cat "$TEST_PANE_CAPTURE"
    fi
    ;;
  display-popup)
    command="${!#}"
    printf '%s' "${TEST_HINT_KEY:-a}" | /bin/bash -c "$command" > /dev/null
    ;;
  split-window|new-window)
    printf '%s\n' "$@" > "$TEST_TMUX_CALLS"
    ;;
  send-keys)
    printf '%s\n' "$*" >> "${TEST_SEND_KEYS:-/dev/null}"
    ;;
esac
MOCK_TMUX
chmod +x "$tmpdir/bin/tmux"

expected="$(realpath -- "$file")"

# Case 1: pane is in copy mode, the path only exists in the mode screen.
if PATH="$tmpdir/bin:$PATH" \
  TMUX_PANE='%1' \
  TEST_PANE_IN_MODE=1 \
  TEST_SCROLL_POSITION=10 \
  TEST_PANE_PATH="$pane_dir" \
  TEST_PANE_CAPTURE="$tmpdir/visible.txt" \
  TEST_PANE_CAPTURE_MODE="$tmpdir/copymode.txt" \
  TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
  "$script"; then
  :
fi

if [[ ! -f "$tmpdir/tmux-calls" ]] || ! grep -Fq -- "$expected" "$tmpdir/tmux-calls"; then
  printf 'FAIL: copy mode view path was not opened: %s\n' "$expected" >&2
  exit 1
fi

printf 'PASS: copy mode screen paths are hinted and opened\n'

# Case 2: pane not in a mode, live screen has no path, nothing must open.
rm -f "$tmpdir/tmux-calls"
if PATH="$tmpdir/bin:$PATH" \
  TMUX_PANE='%1' \
  TEST_PANE_IN_MODE=0 \
  TEST_PANE_PATH="$pane_dir" \
  TEST_PANE_CAPTURE="$tmpdir/visible.txt" \
  TEST_PANE_CAPTURE_MODE="$tmpdir/copymode.txt" \
  TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
  "$script"; then
  :
fi

if [[ -f "$tmpdir/tmux-calls" ]]; then
  printf 'FAIL: live pane opened a path that only exists in the mode screen\n' >&2
  exit 1
fi

printf 'PASS: live pane capture is unchanged when not in a mode\n'

# Case 3: split-window resets a copy-mode pane's scroll position; the split
# choice must restore the view the user was looking at.
rm -f "$tmpdir/tmux-calls" "$tmpdir/send-keys"
if PATH="$tmpdir/bin:$PATH" \
  TMUX_PANE='%1' \
  TEST_PANE_IN_MODE=1 \
  TEST_SCROLL_POSITION=10 \
  TEST_PANE_PATH="$pane_dir" \
  TEST_PANE_CAPTURE="$tmpdir/visible.txt" \
  TEST_PANE_CAPTURE_MODE="$tmpdir/copymode.txt" \
  TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
  TEST_SEND_KEYS="$tmpdir/send-keys" \
  "$script"; then
  :
fi

if [[ ! -f "$tmpdir/send-keys" ]] || ! grep -Fq -- '-X -N 10 scroll-up' "$tmpdir/send-keys"; then
  printf 'FAIL: split did not restore the copy-mode scroll position\n' >&2
  exit 1
fi

printf 'PASS: split restores the copy-mode scroll position\n'
