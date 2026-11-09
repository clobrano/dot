#!/usr/bin/env bash
set -euo pipefail

plugin_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script="$plugin_dir/open_editor.sh"
tmpdir="$(mktemp -d)"
cleanup() {
  if [[ -f "$tmpdir/nvim-pids" ]]; then while IFS= read -r pid; do kill "$pid" 2>/dev/null || true; done < "$tmpdir/nvim-pids"; fi
  if [[ -f "$tmpdir/shell-pids" ]]; then while IFS= read -r pid; do kill "$pid" 2>/dev/null || true; done < "$tmpdir/shell-pids"; fi
  rm -rf "$tmpdir"
}
trap cleanup EXIT
export TMPDIR="$tmpdir"

mkdir -p "$tmpdir/bin" "$tmpdir/tmux-state"
: > "$tmpdir/tmux-calls"
: > "$tmpdir/nvim-calls"

for name in split-first split-second window-first window-second popup-first popup-second stale-first stale-second custom-first custom-second; do
  printf 'file\n' > "$tmpdir/$name.md"
done

cat > "$tmpdir/bin/tmux" <<'MOCK_TMUX'
#!/usr/bin/env bash
set -euo pipefail

state_dir="$TEST_TMUX_STATE/${TEST_SESSION_ID#\$}"
read_target() {
  while (($#)); do
    if [[ "$1" == -t ]]; then
      printf '%s' "$2"
      return
    fi
    shift
  done
}
run_editor_command() {
  local command="$1" previous_count current_count last_call socket
  if [[ "$command" == *'--listen '* ]]; then
    previous_count="$(wc -l < "$TEST_NVIM_CALLS")"
    /bin/bash -c "$command" >/dev/null 2>&1 </dev/null &
    printf '%s\n' "$!" >> "$TEST_SHELL_PIDS"
    for _ in {1..50}; do
      current_count="$(wc -l < "$TEST_NVIM_CALLS")"
      if ((current_count > previous_count)); then
        last_call="$(tail -n 1 "$TEST_NVIM_CALLS")"
        socket="${last_call#--listen }"; socket="${socket%% *}"
        [[ -e "$socket" ]] && return 0
      fi
      sleep 0.02
    done
    return 1
  fi
  /bin/bash -c "$command"
}

case "$1" in
  display-message)
    format="${!#}"
    target="$(read_target "$@")"
    case "$format" in
      '#{pane_id}')
        [[ "${TEST_INVALID_TARGET:-}" == 1 && "$target" == '%2' ]] && exit 1
        printf '%s\n' "${target:-${TMUX_PANE:-%1}}"
        ;;
      '#{pane_current_path}') printf '%s\n' "$TEST_PANE_PATH" ;;
      '#{pane_width}') printf '200\n' ;;
      '#{pane_height}') printf '30\n' ;;
      '#{window_panes}') printf '1\n' ;;
      '#{window_id}')
        if [[ "$target" == %* ]]; then printf '@1\n'; else printf '%s\n' "$target"; fi
        ;;
      '#{session_id}') printf '%s\n' "${TEST_SESSION_ID:-\$1}" ;;
    esac
    ;;
  show-option)
    option="${!#}"
    if [[ "$option" == '@hint-open-verify' ]]; then
      printf 'on\n'
      exit 0
    fi
    [[ -f "$state_dir/$option" ]] && cat "$state_dir/$option"
    ;;
  set-option)
    shift
    target="${TEST_SESSION_ID:-\$1}"
    option=""
    value=""
    unset_option=0
    while (($#)); do
      case "$1" in
        -u|-uq|-qu) unset_option=1; shift ;;
        -t) target="$2"; shift 2 ;;
        -q) shift ;;
        *)
          if [[ -z "$option" ]]; then option="$1"; else value="$1"; fi
          shift
          ;;
      esac
    done
    state_dir="$TEST_TMUX_STATE/${target#\$}"
    mkdir -p "$state_dir"
    if ((unset_option)); then rm -f "$state_dir/$option"; else printf '%s' "$value" > "$state_dir/$option"; fi
    ;;
  display-menu)
    printf 'display-menu\n' >> "$TEST_TMUX_CALLS"
    has_window_label=0; has_new_window_label=0
    for arg in "$@"; do
      case "$arg" in
        Window) has_window_label=1 ;;
        'New window') has_new_window_label=1 ;;
      esac
    done
    if (( ! has_window_label || has_new_window_label )); then
      printf 'FAIL: window menu label should describe the reusable destination\n' >&2
      exit 1
    fi
    choice="${TEST_EDITOR_CHOICE:-split}"
    for arg in "$@"; do
      if [[ "$arg" == *"--open-choice $choice "* ]]; then
        command="${arg#run-shell -b }"
        command="${command:1:${#command}-2}"
        /bin/bash -c "$command"
      fi
    done
    ;;
  capture-pane) cat "$TEST_PANE_CAPTURE" ;;
  display-popup)
    command="${!#}"
    printf 'display-popup %s\n' "$command" >> "$TEST_TMUX_CALLS"
    if [[ "$command" == *'--hints'* ]]; then
      printf '%s' "${TEST_HINT_KEY:-a}" | /bin/bash -c "$command" > "${TEST_POPUP_OUTPUT:-/dev/null}"
    elif [[ "${TEST_EXEC_EDITOR:-0}" == 1 ]]; then
      run_editor_command "$command"
    fi
    ;;
  split-window|new-window)
    printf '%s %s\n' "$1" "${!#}" >> "$TEST_TMUX_CALLS"
    if [[ "${TEST_EXEC_EDITOR:-0}" == 1 ]]; then run_editor_command "${!#}"; fi
    if [[ "$1" == split-window ]]; then printf '%%2\n'; else printf '@2\n'; fi
    ;;
  select-pane|select-window)
    printf '%s %s\n' "$1" "${!#}" >> "$TEST_TMUX_CALLS"
    ;;
esac
MOCK_TMUX
chmod +x "$tmpdir/bin/tmux"

cat > "$tmpdir/bin/fake-editor" <<'MOCK_EDITOR'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$TEST_FAKE_CALLS"
MOCK_EDITOR
chmod +x "$tmpdir/bin/fake-editor"

cat > "$tmpdir/bin/nvim" <<'MOCK_NVIM'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$TEST_NVIM_CALLS"
server=""
remote=0
remote_expr=0
while (($#)); do
  case "$1" in
    --listen|--server) server="$2"; shift 2 ;;
    --remote) remote=1; shift ;;
    --remote-expr) remote_expr=1; shift 2 ;;
    *) shift ;;
  esac
done
if ((remote_expr || remote)); then
  [[ -f "$server" ]] || exit 1
elif [[ -n "$server" ]]; then
  : > "$server"
  printf '%s\n' "$$" >> "$TEST_NVIM_PIDS"
  child=""
  trap '[[ -n "$child" ]] && kill "$child" 2>/dev/null || true; exit 0' TERM INT
  while :; do sleep 60 & child="$!"; wait "$child" || true; done
fi
MOCK_NVIM
chmod +x "$tmpdir/bin/nvim"

run_request() {
  local name="$1" mode="$2" line="${3:-}" editor="${4:-nvim}"
  local target="$tmpdir/$name.md"
  printf '%s%s\n' "$target" "${line:+:$line}" > "$tmpdir/pane.txt"
  PATH="$tmpdir/bin:$PATH" \
    EDITOR="$editor" \
    TMUX_PANE='%1' \
    TEST_SESSION_ID="${TEST_SESSION_ID:-\$1}" \
    TEST_PANE_PATH="$tmpdir" \
    TEST_PANE_CAPTURE="$tmpdir/pane.txt" \
    TEST_SCRIPT="$script" \
    TEST_TMUX_CALLS="$tmpdir/tmux-calls" \
    TEST_TMUX_STATE="$tmpdir/tmux-state" \
    TEST_NVIM_CALLS="$tmpdir/nvim-calls" \
    TEST_NVIM_PIDS="$tmpdir/nvim-pids" \
    TEST_SHELL_PIDS="$tmpdir/shell-pids" \
    TEST_FAKE_CALLS="$tmpdir/fake-editor-calls" \
    TEST_POPUP_OUTPUT="$tmpdir/popup-output" \
    TEST_EDITOR_CHOICE="$mode" \
    TEST_HINT_KEY=a \
    TEST_EXEC_EDITOR=1 \
    "$script"
}

run_request split-first split 7
run_request split-second split 12
split_count="$(grep -c '^split-window ' "$tmpdir/tmux-calls" || true)"
if [[ "$split_count" -ne 1 ]] || ! grep -Fq -- "--remote-expr execute('edit ' . fnameescape('$tmpdir/split-second.md') . ' | call cursor(12, 1)')" "$tmpdir/nvim-calls" ||
  ! grep -Fq -- 'select-pane %2' "$tmpdir/tmux-calls"; then
  printf 'FAIL: repeated split choice did not reuse the same Neovim instance\n' >&2
  printf 'tmux calls:\n'; cat "$tmpdir/tmux-calls"
  printf 'nvim calls:\n'; cat "$tmpdir/nvim-calls"
  printf 'tmux state:\n'; find "$tmpdir/tmux-state" -type f -print -exec cat {} \;
  exit 1
fi
printf 'PASS: split choice reuses its Neovim instance and keeps line numbers\n'

run_request window-first window
run_request window-second window
window_count="$(grep -c '^new-window ' "$tmpdir/tmux-calls" || true)"
if [[ "$window_count" -ne 1 ]] || ! grep -Fq -- "--remote-expr execute('edit ' . fnameescape('$tmpdir/window-second.md'))" "$tmpdir/nvim-calls" ||
  ! grep -Fq -- 'select-window @2' "$tmpdir/tmux-calls"; then
  printf 'FAIL: repeated window choice did not reuse and select its original window\n' >&2
  exit 1
fi
printf 'PASS: new-window choice reuses and focuses its original window\n'

run_request popup-first popup
run_request popup-second popup
popup_editor_count="$(grep -c '^display-popup nvim --listen' "$tmpdir/tmux-calls" || true)"
if [[ "$popup_editor_count" -ne 1 ]] || ! grep -Fq -- "--remote-expr execute('edit ' . fnameescape('$tmpdir/popup-second.md'))" "$tmpdir/nvim-calls"; then
  printf 'FAIL: repeated popup choice did not reuse its Neovim instance\n' >&2
  printf 'tmux calls:\n'; cat "$tmpdir/tmux-calls"
  printf 'nvim calls:\n'; cat "$tmpdir/nvim-calls"
  exit 1
fi
printf 'PASS: popup choice reuses its Neovim instance\n'

run_request stale-first split
TEST_INVALID_TARGET=1 run_request stale-second split
split_count="$(grep -c '^split-window ' "$tmpdir/tmux-calls" || true)"
if [[ "$split_count" -ne 2 ]]; then
  printf 'FAIL: stale split target was not replaced; expected 2 split launches, got %s\n' "$split_count" >&2
  exit 1
fi
printf 'PASS: stale split targets start a fresh editor\n'

before_split_count="$(grep -c '^split-window ' "$tmpdir/tmux-calls" || true)"
TEST_SESSION_ID="\$2" run_request split-second split
session_split_count="$(grep -c '^split-window ' "$tmpdir/tmux-calls" || true)"
if [[ "$session_split_count" -ne $((before_split_count + 1)) ]]; then
  printf 'FAIL: a different tmux session reused the first session editor\n' >&2
  exit 1
fi
printf 'PASS: editor instances are separate between tmux sessions\n'

before_split_count="$session_split_count"
run_request custom-first split '' fake-editor
run_request custom-second split '' fake-editor
custom_split_count="$(grep -c '^split-window ' "$tmpdir/tmux-calls" || true)"
if [[ "$custom_split_count" -ne $((before_split_count + 2)) ]] ||
  [[ "$(wc -l < "$tmpdir/fake-editor-calls")" -ne 2 ]]; then
  printf 'FAIL: non-Neovim editors did not keep launching normally\n' >&2
  exit 1
fi
printf 'PASS: other editors keep launching without Neovim reuse\n'
