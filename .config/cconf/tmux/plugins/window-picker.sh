#!/usr/bin/env bash
# Window picker for the tmux 'w' binding.
# Enter: switch to the selected window. Ctrl-K: kill the selected session
# and keep the picker open. Esc: quit.
TAB=$'\t'

while :; do
    current=$(tmux display-message -p '#{session_name}:#{window_index}')
    pos=$(tmux list-windows -a -F '#{session_name}:#{window_index}' |
          grep -nxF "$current" | cut -d: -f1)
    [ -n "$pos" ] || pos=1

    fmt="#{session_name}[#{window_index}]$TAB#{pane_current_path}(#{pane_current_command})$TAB#{session_name}:#{window_index}"
    out=$(tmux list-windows -a -F "$fmt" |
          fzf --delimiter='\t' --with-nth=1,2 --expect=ctrl-k --reverse \
              --header='Session  Index  Path (Ctrl-K kills session)' \
              --bind "load:pos($pos),change:first" \
              --preview 'tmux capture-pane -p -t {3} -S -50' \
              --preview-window=bottom:70%:follow)
    [ -z "$out" ] && exit 0   # Esc

    key=${out%%$'\n'*}
    IFS=$'\t' read -r _ _ target <<< "${out#*$'\n'}"
    session=${target%%:*}

    if [ "$key" = ctrl-k ] && [ -n "$session" ]; then
        printf 'Kill session %s? [y/N] ' "$session" > /dev/tty
        read -r answer < /dev/tty
        case "$answer" in
            [yY]|[yY][eE][sS]) tmux kill-session -t "$session" ;;
        esac
        # loop again: the picker reopens with the refreshed list
    elif [ -n "$target" ]; then
        # shortcut: switch after the popup closes, or the popup stays drawn on the new session
        tmux run-shell -C -b -d 0.3 "switch-client -t '$target'"
        exit 0
    fi
done
