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
    printf '%s' "${TEST_HINT_KEY:-a}" | /bin/bash -c "$command" > "${TEST_POPUP_OUTPUT:-/dev/null}"
    ;;
  set-buffer)
    printf '%s\n' "$@" > "${TEST_TMUX_BUFFER:-/dev/null}"
    if [[ "${2:-}" == -w ]]; then
      printf '%s' "${!#}" > "${TEST_CLIPBOARD:-/dev/null}"
    fi
    ;;
  split-window|new-window)
    printf '%s\n' "$@" > "$TEST_TMUX_CALLS"
    ;;
esac
MOCK_TMUX
chmod +x "$tmpdir/bin/tmux"

cat > "$tmpdir/bin/wl-copy" <<'MOCK_WL_COPY'
#!/usr/bin/env bash
printf 'unexpected wl-copy invocation\n' >&2
exit 1
MOCK_WL_COPY
chmod +x "$tmpdir/bin/wl-copy"

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

duplicate_file="$tmpdir/repeated.md"
printf 'guide\n' > "$duplicate_file"
printf 'Repeated: %s; then %s; lines: %s:1 and %s:2.\n' \
  "$duplicate_file" "$duplicate_file" "$duplicate_file" "$duplicate_file" > "$tmpdir/duplicate-pane.txt"
popup_output="$tmpdir/popup-output"
rm -f "$tmpdir/tmux-calls" "$popup_output"

if PATH="$tmpdir/bin:$PATH" \
  TMUX_PANE='%1' \
  TEST_PANE_PATH="$tmpdir" \
  TEST_PANE_CAPTURE="$tmpdir/duplicate-pane.txt" \
  TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
  TEST_POPUP_OUTPUT="$popup_output" \
  "$script"; then
  :
fi

hint_a=$'\033[1;30;103ma\033[0m'
hint_b=$'\033[1;30;103mb\033[0m'
hint_c=$'\033[1;30;103mc\033[0m'
hint_a_count="$(grep -Fo "$hint_a" "$popup_output" | wc -l || true)"
hint_b_count="$(grep -Fo "$hint_b" "$popup_output" | wc -l || true)"
hint_c_count="$(grep -Fo "$hint_c" "$popup_output" | wc -l || true)"
if [[ "$hint_a_count" -ne 2 || "$hint_b_count" -ne 1 || "$hint_c_count" -ne 1 ]]; then
  printf 'FAIL: expected hints a=2, b=1, c=1; got a=%s, b=%s, c=%s\n' \
    "$hint_a_count" "$hint_b_count" "$hint_c_count" >&2
  exit 1
fi
if [[ ! -f "$tmpdir/tmux-calls" ]] || ! grep -Fq -- "$duplicate_file" "$tmpdir/tmux-calls"; then
  printf 'FAIL: selecting the shared hint did not open the filepath: %s\n' "$duplicate_file" >&2
  exit 1
fi

printf 'PASS: repeated targets share hints; line targets remain distinct\n'

copy_file="$tmpdir/copy-target.go"
printf 'package main\n' > "$copy_file"
printf 'See %s:42.\n' "$copy_file" > "$tmpdir/copy-pane.txt"
for n in {1..26}; do
  extra_file="$tmpdir/extra-$n.md"
  printf 'guide\n' > "$extra_file"
  printf '%s\n' "$extra_file" >> "$tmpdir/copy-pane.txt"
done
clipboard_call="$tmpdir/clipboard-call"
tmux_buffer="$tmpdir/tmux-buffer"
rm -f "$tmpdir/tmux-calls" "$clipboard_call" "$tmux_buffer" "$popup_output"

if PATH="$tmpdir/bin:$PATH" \
  TMUX_PANE='%1' \
  TEST_PANE_PATH="$tmpdir" \
  TEST_PANE_CAPTURE="$tmpdir/copy-pane.txt" \
  TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
  TEST_TMUX_BUFFER="$tmux_buffer" \
  TEST_CLIPBOARD="$clipboard_call" \
  TEST_HINT_KEY=A \
  TEST_POPUP_OUTPUT="$popup_output" \
  "$script"; then
  :
fi

if [[ -f "$tmpdir/tmux-calls" ]]; then
  printf 'FAIL: capital hint opened the file instead of copying it\n' >&2
  exit 1
fi
if [[ ! -f "$clipboard_call" ]] || ! grep -Fqx -- "$copy_file" "$clipboard_call"; then
  printf 'FAIL: capital hint did not copy the path without its line suffix\n' >&2
  exit 1
fi
if [[ ! -f "$tmux_buffer" ]] || ! grep -Fqx -- "$copy_file" "$tmux_buffer"; then
  printf 'FAIL: capital hint did not retain the path in tmux buffer\n' >&2
  exit 1
fi
if ! grep -Fqx -- '-w' "$tmux_buffer"; then
  printf 'FAIL: capital hint did not request clipboard output from tmux\n' >&2
  exit 1
fi
if ! grep -Fq -- $'\033[1;30;103m;a\033[0m' "$popup_output"; then
  printf 'FAIL: targets after a-z did not move to multi-key hints\n' >&2
  exit 1
fi
if grep -Fq -- $'\033[1;30;103mA\033[0m' "$popup_output"; then
  printf 'FAIL: uppercase A is still assigned as an opening hint\n' >&2
  exit 1
fi

printf 'PASS: capital hint copies the path without opening it\n'
