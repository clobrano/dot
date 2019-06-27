# switch panes
bind-key -n M-h select-pane -L
bind-key -n M-j select-pane -D
bind-key -n M-k select-pane -U
bind-key -n M-l select-pane -R

# Switch windows
bind -n M-b previous-window
bind -n M-n next-window

# Kill split
bind -n M-x kill-pane

bind-key -n M-o display-panes \; split-window -v -c "#{pane_current_path}"
bind-key -n M-e display-panes \; split-window -h -c "#{pane_current_path}"
bind-key -n M-x kill-pane
unbind-key -n C-a

unbind-key -n C-b
unbind-key -n C-o

# Fast select windows
bind-key -n M-0 select-window -t 0
bind-key -n M-1 select-window -t 1
bind-key -n M-2 select-window -t 2
bind-key -n M-3 select-window -t 3
bind-key -n M-4 select-window -t 4
bind-key -n M-5 select-window -t 5
bind-key -n M-6 select-window -t 6

set -g prefix F12
set -g prefix2 F12

# resize pane
bind-key -n M-J resize-pane -D
bind-key -n M-K resize-pane -U
bind-key -n M-H resize-pane -L
bind-key -n M-L resize-pane -R

# re-enumerate windows
bind-key -n M-r movew -r
