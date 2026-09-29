#!/usr/bin/env bash
# tmux-hint-open: find file paths in the current pane, pick one with fzf in a
# popup, open it in a layout-aware Neovim -- a vertical split if the window has
# no splits, else a new window in the same session. Requires fzf.
set -euo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

open_file() {              # $1 = pane id, $2 = file path
  local pane="$1" file="$2" pane_path panes win editor cmd
  pane_path="$(tmux display-message -p -t "$pane" '#{pane_current_path}')"
  editor="${EDITOR:-nvim}"
  quote() { local s=$1; printf "'%s'" "${s//\'/\'\\\'\'}"; }
  cmd="$editor -- $(quote "$file")"
  panes="$(tmux display-message -p -t "$pane" '#{window_panes}')"
  win="$(tmux display-message -p -t "$pane" '#{window_id}')"
  if [ "$panes" -eq 1 ]; then
    tmux split-window -h -t "$pane" -c "$pane_path" "$cmd"
  else
    tmux new-window -a -t "$win" -c "$pane_path" "$cmd"
  fi
}

# ---- fzf callback: runs inside the popup, opens the chosen file -----------
if [ "${1:-}" = "--fzf" ]; then
  listfile="$2"; pane="$3"
  file="$(fzf --reverse --prompt='open> ' \
              --preview='(bat --color=always --style=numbers -- {} 2>/dev/null || cat -- {}) 2>/dev/null' \
              --preview-window='down,50%,border-top,wrap' \
              < "$listfile" || true)"
  rm -f "$listfile"
  [ -n "$file" ] && open_file "$pane" "$file"
  exit 0
fi

# ---- collect mode ---------------------------------------------------------
command -v fzf >/dev/null 2>&1 || { tmux display-message "tmux-hint-open: fzf not installed"; exit 0; }

pane="${TMUX_PANE:-$(tmux display-message -p '#{pane_id}')}"
pane_path="$(tmux display-message -p -t "$pane" '#{pane_current_path}')"

# Visible pane text. We reflow by pane width rather than trusting capture's -J:
# some shells/prompts move the cursor instead of letting the terminal auto-wrap,
# so tmux never flags the row as "wrapped" and -J has nothing to rejoin. Any row
# that fills the full width is treated as continuing into the next. (Assumes
# single-width characters; CJK/tabs can throw the width count off.)
pane_width="$(tmux display-message -p -t "$pane" '#{pane_width}')"
content="$(tmux capture-pane -p -t "$pane" | awk -v w="$pane_width" '
  { buf = buf $0; if (length($0) >= w) next; print buf; buf = "" }
  END { if (buf != "") print buf }')"

# Precision comes from the filesystem, not the regex: screen text can't tell
# "1.0" the version from "1.0" the file. So by default we keep only tokens that
# resolve to a real file. Set @hint-open-verify 'off' for full recall -- then a
# slash is required to avoid every word matching.
VERIFY="$(tmux show-option -gqv '@hint-open-verify')"; VERIFY="${VERIFY:-on}"

if [ "$VERIFY" = off ]; then
  pattern='(~|\.{1,2})?/([[:alnum:]._-]+/?)+|([[:alnum:]._-]+/)+[[:alnum:]._-]+'
else
  pattern='(~|\.{1,2})?/?([[:alnum:]._-]+/)*[[:alnum:]._-]+'
fi

# Bare/relative tokens are tried against these bases in order: the pane's cwd,
# then the git root (so repo-relative paths in diffs/build output resolve too).
bases=("$pane_path")
gitroot="$(cd "$pane_path" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$gitroot" ] && [ "$gitroot" != "$pane_path" ] && bases+=("$gitroot")

raw=()
if [ -n "$content" ]; then
  mapfile -t raw < <(printf '%s\n' "$content" | grep -oE "$pattern" || true)
fi

declare -A seen
paths=()
if [ "${#raw[@]}" -gt 0 ]; then
  for tok in "${raw[@]}"; do
    case "$tok" in
      /*)    cands=("$tok") ;;
      "~/"*) cands=("$HOME/${tok#\~/}") ;;
      *)     cands=(); for b in "${bases[@]}"; do cands+=("$b/$tok"); done ;;
    esac
    f=""
    for c in "${cands[@]}"; do
      if [ "$VERIFY" = off ]; then f="$c"; break; fi   # take first candidate
      [ -e "$c" ] && { f="$c"; break; }                # or first that exists
    done
    [ -n "$f" ] || continue
    [ "$VERIFY" = off ] || f="$(realpath "$f" 2>/dev/null)" || continue
    [ -n "${seen[$f]:-}" ] && continue                 # dedupe, keep first order
    seen[$f]=1
    paths+=("$f")
  done
fi

if [ "${#paths[@]}" -eq 0 ]; then
  tmux display-message "tmux-hint-open: no file paths in view"
  exit 0
fi

# Resolved paths go in a temp file the popup's fzf reads.
listfile="$(mktemp)"
printf '%s\n' "${paths[@]}" > "$listfile"

# -E closes the popup when the command exits; the command runs fzf and opens
# the pick, targeting the original pane by id.
tmux display-popup -E -w 90% -h 80% "$SELF --fzf $listfile $pane"
