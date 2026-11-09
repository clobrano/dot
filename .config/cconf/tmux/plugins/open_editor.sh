#!/usr/bin/env bash
# tmux-hint-open: show the current pane with a key hint beside each detected file.
set -euo pipefail

SELF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"

quote() { local s=$1; printf "'%s'" "${s//\'/\'\\\'\'}"; }
shell_quote() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//\$/\\\$}"
  s="${s//\`/\\\`}"
  printf '"%s"' "$s"
}
vim_quote() { local s=$1; printf "'%s'" "${s//\'/\'\'}"; }

session_option() {
  tmux show-option -qv -t "$1" "$2" 2>/dev/null || true
}

show_open_mode_menu() {
  local pane="$1" file="$2" session command
  session="$(tmux display-message -p -t "$pane" '#{session_id}')"
  # shortcut: simultaneous menus in one session share pending data; add per-menu keys if needed.
  tmux set-option -t "$session" @open_editor_pending_file "$file"
  tmux set-option -t "$session" @open_editor_pending_editor "${EDITOR:-}"
  tmux set-option -t "$session" @open_editor_pending_path "$PATH"
  command="exec $(shell_quote "$SELF") --open-choice"
  tmux display-menu -T 'Open file in' -t "$pane" \
    'Split' 1 "run-shell -b '$command split $pane'" \
    'Popup' 2 "run-shell -b '$command popup $pane'" \
    'Window' 3 "run-shell -b '$command window $pane'"
}

open_file() {              # $1 = pane id, $2 = file path, $3 = mode
  local pane="$1" file="$2" mode="$3" line="" pane_path pane_width pane_height win session editor editor_bin editor_name cmd
  local is_nvim=0 socket socket_dir socket_option target_option target target_ok=1 expr
  if [[ "$file" =~ :([0-9]+)$ ]]; then
    line="${BASH_REMATCH[1]}"
    file="${file%:*}"
  fi
  pane_path="$(tmux display-message -p -t "$pane" '#{pane_current_path}')"
  win="$(tmux display-message -p -t "$pane" '#{window_id}')"
  session="$(tmux display-message -p -t "$pane" '#{session_id}')"
  editor="${EDITOR:-nvim}"
  editor_bin="${editor%%[[:space:]]*}"
  editor_name="${editor_bin##*/}"
  [[ "$editor_name" == nvim ]] && is_nvim=1
  cmd="$editor"

  if ((is_nvim)); then
    socket_option="@open_editor_${mode}_socket"
    target_option="@open_editor_${mode}_target"
    socket="$(session_option "$session" "$socket_option")"
    target="$(session_option "$session" "$target_option")"
    if [[ "$mode" == split || "$mode" == window ]]; then
      if [[ -z "$target" ]]; then
        target_ok=0
      elif [[ "$mode" == split ]]; then
        tmux display-message -p -t "$target" '#{pane_id}' >/dev/null 2>&1 || target_ok=0
      else
        tmux display-message -p -t "$target" '#{window_id}' >/dev/null 2>&1 || target_ok=0
      fi
    fi
    if [[ -n "$socket" ]] && ((target_ok)) &&
      "$editor_bin" --server "$socket" --remote-expr 'v:servername' >/dev/null 2>&1; then
      case "$mode" in
        split) tmux select-pane -t "$target" ;;
        window) tmux select-window -t "$target" ;;
      esac
      expr="execute('edit ' . fnameescape($(vim_quote "$file"))"
      if [[ -n "$line" ]]; then expr+=" . ' | call cursor($line, 1)'"; fi
      expr+=")"
      "$editor_bin" --server "$socket" --remote-expr "$expr"
      return
    fi
    tmux set-option -uq -t "$session" "$socket_option" 2>/dev/null || true
    tmux set-option -uq -t "$session" "$target_option" 2>/dev/null || true
    # shortcut: force-killed editors can leave TMPDIR directories; add session-close cleanup if they accumulate.
    socket_dir="$(mktemp -d "${TMPDIR:-/tmp}/open-editor.XXXXXX")"
    socket="$socket_dir/nvim"
    tmux set-option -t "$session" "$socket_option" "$socket"
    cmd+=" --listen $(quote "$socket")"
  fi
  [[ -n "$line" ]] && cmd+=" +$line"
  cmd+=" -- $(quote "$file")"
  if ((is_nvim)); then cmd+="; rm -f -- $(quote "$socket") && rmdir -- $(quote "$socket_dir")"; fi

  case "$mode" in
    split)
      target="$(tmux split-window -h -l40% -P -F '#{pane_id}' -t "$pane" -c "$pane_path" "$cmd")"
      ;;
    popup)
      pane_width="$(tmux display-message -p -t "$pane" '#{pane_width}')"
      pane_height="$(tmux display-message -p -t "$pane" '#{pane_height}')"
      tmux display-popup -B -E -t "$pane" -x P -y P -w "$pane_width" -h "$pane_height" "$cmd"
      ;;
    window)
      target="$(tmux new-window -a -P -F '#{window_id}' -t "$win" -c "$pane_path" "$cmd")"
      ;;
  esac
  if ((is_nvim)) && [[ -n "$target" ]]; then
    tmux set-option -t "$session" "$target_option" "$target"
  fi
}

cell_span_free() {
  local row="$1" col="$2" length="$3" row_text cells key i
  (( row >= 0 && row < ${#screen_rows[@]} && col >= 0 && col + length <= pane_width )) || return 1
  row_text="${screen_rows[$row]}"
  cells="${row_text:col:length}"
  (( ${#cells} < length )) && cells+="$(printf '%*s' "$((length - ${#cells}))" '')"
  for ((i = 0; i < length; i++)); do
    key="$row:$((col + i))"
    [[ -z "${occupied[$key]+x}" ]] || return 1
  done
}

cell_span_blank() {
  local row="$1" col="$2" length="$3" row_text cells
  cell_span_free "$row" "$col" "$length" || return 1
  row_text="${screen_rows[$row]}"
  cells="${row_text:col:length}"
  (( ${#cells} < length )) && cells+="$(printf '%*s' "$((length - ${#cells}))" '')"
  [[ "$cells" =~ ^[[:space:]]+$ ]]
}

map_logical_offset() {
  local logical_row="$1" remaining="$2" row row_length
  row="${logical_starts[$logical_row]}"
  while (( row < ${#screen_rows[@]} )); do
    row_length=${#screen_rows[$row]}
    if (( remaining < row_length )); then
      mapped_row="$row"
      mapped_col="$remaining"
      return 0
    fi
    remaining=$((remaining - row_length))
    row=$((row + 1))
  done
  return 1
}

if [ "${1:-}" = "--open-choice" ]; then
  mode="$2"; pane="$3"
  case "$mode" in split|popup|window) ;; *) exit 0 ;; esac
  session="$(tmux display-message -p -t "$pane" '#{session_id}')"
  selected_file="$(session_option "$session" @open_editor_pending_file)"
  selected_editor="$(session_option "$session" @open_editor_pending_editor)"
  selected_path="$(session_option "$session" @open_editor_pending_path)"
  tmux set-option -uq -t "$session" @open_editor_pending_file 2>/dev/null || true
  tmux set-option -uq -t "$session" @open_editor_pending_editor 2>/dev/null || true
  tmux set-option -uq -t "$session" @open_editor_pending_path 2>/dev/null || true
  if [[ -n "$selected_path" ]]; then PATH="$selected_path"; export PATH; fi
  if [[ -n "$selected_editor" ]]; then EDITOR="$selected_editor"; export EDITOR; else unset EDITOR; fi
  if [[ -n "$selected_file" ]]; then open_file "$pane" "$selected_file" "$mode"; fi
  exit 0
fi

# ---- popup callback: redraws the captured pane with key hints --------------
if [ "${1:-}" = "--hints" ]; then
  styled_file="$2"; manifest="$3"; pane="$4"; selection_file="$5"

  restore_terminal() { printf '\033[0m\033[?25h'; }
  trap restore_terminal EXIT
  printf '\033[?25l\033[2J\033[H'
  display_row=0
  while IFS= read -r screen_line || [ -n "$screen_line" ]; do
    printf '\033[%d;1H%s' "$((display_row + 1))" "$screen_line"
    display_row=$((display_row + 1))
  done < "$styled_file"
  while IFS=$'\t' read -r label row col file; do
    printf '\033[%d;%dH\033[1;30;103m%s\033[0m' "$((row + 1))" "$((col + 1))" "$label"
  done < "$manifest"
  tmux display-message -d 5000 'a-z opens; A-Z copies; prefixed hints open; Escape cancels'

  IFS= read -r -s -n 1 first_key || exit 0
  [[ "$first_key" == $'\e' ]] && exit 0
  copy_path=0
  case "$first_key" in
    ';')
      IFS= read -r -s -n 1 -t 5 second_key || exit 0
      selected=";$second_key"
      ;;
    ',')
      IFS= read -r -s -n 1 -t 5 second_key || exit 0
      IFS= read -r -s -n 1 -t 5 third_key || exit 0
      selected=",$second_key$third_key"
      ;;
    [A-Z])
      selected="${first_key,,}"
      copy_path=1
      ;;
    *) selected="$first_key" ;;
  esac

  while IFS=$'\t' read -r label row col file; do
    if [[ "$label" == "$selected" ]]; then
      if [ "$copy_path" -eq 1 ]; then
        [[ "$file" =~ :[0-9]+$ ]] && file="${file%:*}"
        tmux set-buffer -w -- "$file"
        tmux display-message -d 5000 'File path copied to clipboard'
      else
        printf '%s\n' "$file" > "$selection_file"
      fi
      exit 0
    fi
  done < "$manifest"
  tmux display-message "tmux-hint-open: no file for hint '$selected'"
  exit 0
fi

# ---- collect mode ---------------------------------------------------------
pane="${TMUX_PANE:-$(tmux display-message -p '#{pane_id}')}"
pane_path="$(tmux display-message -p -t "$pane" '#{pane_current_path}')"
pane_width="$(tmux display-message -p -t "$pane" '#{pane_width}')"
pane_height="$(tmux display-message -p -t "$pane" '#{pane_height}')"

# Prefer files confirmed by the filesystem. Also recognize missing slash paths
# with an extension. Set @hint-open-verify 'off' to include all slash paths.
VERIFY="$(tmux show-option -gqv '@hint-open-verify')"; VERIFY="${VERIFY:-on}"

if [ "$VERIFY" = off ]; then
  pattern='((~|\.{1,2})?/([[:alnum:]._@-]+/?)+|([[:alnum:]._@-]+/)+[[:alnum:]._@-]+)(:[0-9]+)?'
else
  pattern='((~|\.{1,2})?/?([[:alnum:]._@-]+/)*[[:alnum:]._@-]+)(:[0-9]+)?'
fi
spaced_pattern='(/|~/|\.{1,2}/)([[:alnum:]_. @-]+/)*[[:alnum:]_. @-]+(:[0-9]+)?'

# Bare and relative paths are checked in the pane's directory, then the git
# root so paths printed by diffs and build tools resolve too.
bases=("$pane_path")
gitroot="$(cd "$pane_path" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$gitroot" ] && [ "$gitroot" != "$pane_path" ] && bases+=("$gitroot")

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
styled_file="$tmpdir/styled"
plain_file="$tmpdir/plain"
manifest="$tmpdir/hints"
tmux capture-pane -e -p -t "$pane" > "$styled_file"
# OSC 8 links are invisible on screen but would skew the hint coordinates.
sed -E $'s/\033\\[[0-9;:]*m//g; s/\033\\]8;[^\033\a]*(\a|\033\\\\)//g' "$styled_file" > "$plain_file"
mapfile -t screen_rows < "$plain_file"

# Join rows that fill the pane width so wrapped paths stay detectable. This
# follows the same single-cell-width assumption as the former picker.
logical_lines=()
logical_starts=()
buffer=""
buffer_start=0
for ((row = 0; row < ${#screen_rows[@]}; row++)); do
  screen_row="${screen_rows[$row]}"
  if [ -z "$buffer" ]; then buffer_start="$row"; fi
  buffer+="$screen_row"
  if (( ${#screen_row} < pane_width )); then
    logical_lines+=("$buffer")
    logical_starts+=("$buffer_start")
    buffer=""
  fi
done
if [ -n "$buffer" ]; then
  logical_lines+=("$buffer")
  logical_starts+=("$buffer_start")
fi

paths=()
hit_lines=()
hit_offsets=()
hit_lengths=()
for ((logical_row = 0; logical_row < ${#logical_lines[@]}; logical_row++)); do
  logical_line="${logical_lines[$logical_row]}"
  [ -n "$logical_line" ] || continue
  while IFS=$'\t' read -r offset token; do
    [ -n "$token" ] || continue
    token_length=${#token}
    line_suffix=""
    if [[ "$token" =~ :([0-9]+)$ ]]; then
      line_suffix=":${BASH_REMATCH[1]}"
      token="${token%"$line_suffix"}"
    fi
    case "$token" in
      /*)    candidates=("$token") ;;
      "~/"*) candidates=("$HOME/${token#\~/}") ;;
      *)
        candidates=()
        for base in "${bases[@]}"; do candidates+=("$base/$token"); done
        ;;
    esac
    file=""
    is_openable=0
    candidate_exists=0
    for candidate in "${candidates[@]}"; do
      if [ "$VERIFY" = off ]; then
        file="$candidate"
        [ -f "$candidate" ] && is_openable=1
        break
      fi
      [ -e "$candidate" ] && candidate_exists=1
      if [ -f "$candidate" ]; then
        file="$candidate"
        is_openable=1
        break
      fi
    done
    if [ -z "$file" ] && [ "$VERIFY" != off ] && [ "$candidate_exists" -eq 0 ]; then
      filename="${token##*/}"
      prefix="${logical_line:0:offset}"
      if [[ "$token" == */* && "$filename" =~ \.[[:alnum:]_-]+$ && ! "$prefix" =~ [[:alpha:]][[:alnum:].+-]*:$ ]]; then
        if [[ "$token" == /* || "$token" == "~/"* || "$token" == ./* || "$token" == ../* || -z "$gitroot" ]]; then
          file="${candidates[0]}"
        else
          file="$gitroot/$token"
        fi
      fi
    fi
    [ -n "$file" ] || continue
    if [ "$is_openable" -eq 1 ] && [ "$VERIFY" != off ]; then
      file="$(realpath "$file" 2>/dev/null)" || continue
    fi
    file+="$line_suffix"
    paths+=("$file")
    hit_lines+=("$logical_row")
    hit_offsets+=("$offset")
    hit_lengths+=("$token_length")
  done < <(printf '%s\n' "$logical_line" | HINT_OPEN_PATTERN="$pattern" HINT_OPEN_SPACED_PATTERN="$spaced_pattern" awk '
    function valid_start(pos, previous) {
      if (pos == 0) return 1
      previous = substr($0, pos, 1)
      return previous !~ /[[:alnum:]_.@\/-]/
    }
    BEGIN {
      pat = ENVIRON["HINT_OPEN_PATTERN"]
      spaced_pat = ENVIRON["HINT_OPEN_SPACED_PATTERN"]
    }
    {
      rest = $0
      offset = 0
      spaced_count = 0
      while (match(rest, spaced_pat)) {
        token = substr(rest, RSTART, RLENGTH)
        sub(/[.,;!?]+$/, "", token)
        token_start = offset + RSTART - 1
        if (length(token) && valid_start(token_start)) {
          spaced_count++
          spaced_start[spaced_count] = token_start
          spaced_end[spaced_count] = token_start + length(token)
          printf "%d\t%s\n", token_start, token
        }
        consumed = RSTART + RLENGTH - 1
        offset += consumed
        rest = substr(rest, consumed + 1)
      }

      rest = $0
      offset = 0
      while (match(rest, pat)) {
        token = substr(rest, RSTART, RLENGTH)
        sub(/[.,;!?]+$/, "", token)
        token_start = offset + RSTART - 1
        covered = 0
        for (i = 1; i <= spaced_count; i++) {
          if (token_start >= spaced_start[i] && token_start < spaced_end[i]) covered = 1
        }
        if (!covered && valid_start(token_start)) printf "%d\t%s\n", token_start, token
        consumed = RSTART + RLENGTH - 1
        offset += consumed
        rest = substr(rest, consumed + 1)
      }
    }')
done

if [ "${#paths[@]}" -eq 0 ]; then
  tmux display-message 'tmux-hint-open: no file paths in view'
  exit 0
fi

single_alphabet='abcdefghijklmnopqrstuvwxyz'
alphabet='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
single_count=${#single_alphabet}
multi_count=${#alphabet}
max_hints=$((single_count + multi_count + multi_count * multi_count))
declare -A open_targets=()
open_count=0
for target in "${paths[@]}"; do
  if [ -z "${open_targets[$target]:-}" ]; then
    open_targets[$target]=1
    open_count=$((open_count + 1))
  fi
done
if (( open_count > max_hints )); then
  tmux display-message "tmux-hint-open: too many file paths to hint ($open_count)"
  exit 0
fi

: > "$manifest"
declare -A occupied=() target_labels=()
hint_index=0
for ((i = 0; i < ${#paths[@]}; i++)); do
  target="${paths[$i]}"
  label="${target_labels[$target]:-}"
  if [ -z "$label" ]; then
    if (( hint_index < single_count )); then
      label="${single_alphabet:hint_index:1}"
    elif (( hint_index < single_count + multi_count )); then
      label=";${alphabet:hint_index-single_count:1}"
    else
      pair_index=$((hint_index - single_count - multi_count))
      pair_first=$((pair_index / multi_count))
      pair_second=$((pair_index % multi_count))
      label=",${alphabet:pair_first:1}${alphabet:pair_second:1}"
    fi
    target_labels[$target]="$label"
    hint_index=$((hint_index + 1))
  fi
  marker="$label"

  logical_row="${hit_lines[$i]}"
  offset="${hit_offsets[$i]}"
  length="${hit_lengths[$i]}"
  map_logical_offset "$logical_row" "$offset" || continue
  start_row="$mapped_row"
  start_col="$mapped_col"
  end_offset=$((offset + length))
  if map_logical_offset "$logical_row" "$end_offset"; then
    end_row="$mapped_row"
    end_col="$mapped_col"
  else
    end_row="$start_row"
    end_col="$start_col"
  fi
  marker_length=${#marker}
  placed=0

  if (( start_col >= marker_length )) && cell_span_blank "$start_row" "$((start_col - marker_length))" "$marker_length"; then
    marker_row="$start_row"; marker_col=$((start_col - marker_length)); placed=1
  elif (( end_row == start_row )) && cell_span_blank "$end_row" "$end_col" "$marker_length"; then
    marker_row="$end_row"; marker_col="$end_col"; placed=1
  elif (( start_col >= marker_length )) && cell_span_free "$start_row" "$((start_col - marker_length))" "$marker_length"; then
    marker_row="$start_row"; marker_col=$((start_col - marker_length)); placed=1
  elif (( end_row == start_row )) && cell_span_free "$end_row" "$end_col" "$marker_length"; then
    marker_row="$end_row"; marker_col="$end_col"; placed=1
  elif cell_span_free "$start_row" "$start_col" "$marker_length"; then
    marker_row="$start_row"; marker_col="$start_col"; placed=1
  fi
  [ "$placed" -eq 1 ] || continue

  for ((cell = 0; cell < marker_length; cell++)); do
    occupied["$marker_row:$((marker_col + cell))"]=1
  done
  printf '%s\t%s\t%s\t%s\n' "$label" "$marker_row" "$marker_col" "${paths[$i]}" >> "$manifest"
done

if [ ! -s "$manifest" ]; then
  tmux display-message 'tmux-hint-open: no room to display file hints'
  exit 0
fi

selection_file="$tmpdir/selection"
popup_command="$(quote "$SELF") --hints $(quote "$styled_file") $(quote "$manifest") $(quote "$pane") $(quote "$selection_file")"
tmux display-popup -B -E -t "$pane" -x P -y P -w "$pane_width" -h "$pane_height" "$popup_command"
if [[ -s "$selection_file" ]]; then
  IFS= read -r selected_file < "$selection_file"
  show_open_mode_menu "$pane" "$selected_file"
fi
