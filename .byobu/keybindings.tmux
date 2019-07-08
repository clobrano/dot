unbind-key -n C-a
unbind-key -n C-b
unbind-key -n C-o

# pane switch
bind-key -n M-h select-pane -L
bind-key -n M-j select-pane -D
bind-key -n M-k select-pane -U
bind-key -n M-l select-pane -R

# pane resize
bind-key -n M-J resize-pane -D
bind-key -n M-K resize-pane -U
bind-key -n M-H resize-pane -L
bind-key -n M-L resize-pane -R

# prefix primary to F12
set -g prefix F12
# prefix secondary to F12
set -g prefix2 F12

# split hOrizontal
bind-key -n M-o display-panes \; split-window -v -c "#{pane_current_path}"
# split vErtical
bind-key -n M-e display-panes \; split-window -h -c "#{pane_current_path}"
# split kill
bind-key -n M-x kill-pane
#bind -n M-x kill-pane duplicated?

# windows select
bind-key -n M-0 select-window -t 0
bind-key -n M-1 select-window -t 1
bind-key -n M-2 select-window -t 2
bind-key -n M-3 select-window -t 3
bind-key -n M-4 select-window -t 4
bind-key -n M-5 select-window -t 5
bind-key -n M-6 select-window -t 6
bind-key -n M-7 select-window -t 7
bind-key -n M-8 select-window -t 8
bind-key -n M-9 select-window -t 9

# window switch
bind -n M-b previous-window
bind -n M-n next-window

# windows re-enumerate
bind-key -n M-r movew -r
