#!/usr/bin/env bash
set -euo pipefail

plugin_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script="$plugin_dir/open_editor.sh"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

file="$tmpdir/tenant-scoped-ssh-key-manual-test.md"
printf 'guide\n' > "$file"
printf 'Saved the guide to %s.\n' "$file" > "$tmpdir/pane.txt"
mkdir "$tmpdir/bin"

cat > "$tmpdir/bin/tmux" <<'MOCK_TMUX'
#!/usr/bin/env bash
set -euo pipefail

case "$1" in
  display-message)
    for arg in "$@"; do
      case "$arg" in
        '#{pane_id}') printf '%s\n' '%1'; exit 0 ;;
        '#{pane_current_path}') printf '%s\n' "$TEST_PANE_PATH"; exit 0 ;;
        '#{pane_width}') printf '200\n'; exit 0 ;;
        '#{pane_height}') printf '30\n'; exit 0 ;;
        '#{window_panes}') printf '1\n'; exit 0 ;;
        '#{window_id}') printf '%s\n' '@1'; exit 0 ;;
      esac
    done
    ;;
  show-option)
    printf 'on\n'
    ;;
  capture-pane)
    cat "$TEST_PANE_CAPTURE"
    ;;
  display-popup)
    command="${!#}"
    printf 'a' | /bin/bash -c "$command" >/dev/null
    ;;
  split-window|new-window)
    printf '%s\n' "$@" > "$TEST_TMUX_CALLS"
    ;;
esac
MOCK_TMUX
chmod +x "$tmpdir/bin/tmux"

if PATH="$tmpdir/bin:$PATH" \
  TMUX_PANE='%1' \
  TEST_PANE_PATH="$tmpdir" \
  TEST_PANE_CAPTURE="$tmpdir/pane.txt" \
  TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
  "$script"; then
  :
fi

if [[ ! -f "$tmpdir/tmux-calls" ]] || ! grep -Fq -- "$file" "$tmpdir/tmux-calls"; then
  printf 'FAIL: did not open path before sentence punctuation: %s\n' "$file" >&2
  exit 1
fi

printf 'PASS: path detection excludes trailing sentence punctuation\n'

repo="$tmpdir/repo"
relative_file="$repo/fulfillment-service/internal/servers/private_secrets_server.go"
mkdir -p "$repo/subdir" "$(dirname -- "$relative_file")"
printf 'package servers\n' > "$relative_file"
git -C "$repo" init -q
printf 'See fulfillment-service/internal/servers/private_secrets_server.go.\n' > "$tmpdir/relative-pane.txt"
rm -f "$tmpdir/tmux-calls"

if PATH="$tmpdir/bin:$PATH" \
  TMUX_PANE='%1' \
  TEST_PANE_PATH="$repo/subdir" \
  TEST_PANE_CAPTURE="$tmpdir/relative-pane.txt" \
  TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
  "$script"; then
  :
fi

if [[ ! -f "$tmpdir/tmux-calls" ]] || ! grep -Fq -- "$relative_file" "$tmpdir/tmux-calls"; then
  printf 'FAIL: did not open relative path before sentence punctuation: %s\n' "$relative_file" >&2
  exit 1
fi

printf 'PASS: relative path detection excludes trailing sentence punctuation\n'
