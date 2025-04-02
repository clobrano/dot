-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- Spawn the right tmux shell in login mode
config.default_prog = { '/usr/bin/zsh' }

-- This is where you actually apply your config choices
config.color_scheme = 'catppuccin-frappe'

-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font('Source Code Pro Medium', { italic = false, weight = 'Bold' })
config.font_size = 10.5

-- disable title bar
--config.window_decorations = "INTEGRATED_BUTTONS | NONE"
config.window_decorations = "NONE"

-- disable the tab bar with only one tab
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.hide_mouse_cursor_when_typing = false

config.window_frame = {
  font_size=12,
  active_titlebar_bg = '#2b2b2b',
  border_left_width = '0.2cell',
  border_right_width = '0.2cell',
  border_bottom_height = '0.1cell',
  border_top_height = '0.1cell',
  border_left_color = 'pink',
  border_right_color = 'pink',
  border_bottom_color = 'pink',
  border_top_color = 'pink',
  inactive_titlebar_bg = '#353535',
  inactive_titlebar_fg = '#cccccc',
  active_titlebar_fg = '#ffffff',
  inactive_titlebar_border_bottom = '#2b2042',
  active_titlebar_border_bottom = '#2b2042',
  button_fg = '#cccccc',
  button_bg = '#2b2042',
  button_hover_fg = '#ffffff',
  button_hover_bg = '#3b3052',
}

config.window_padding = { left = 10, right = 10, top = 5, bottom = 5, }
config.initial_cols = 234
config.initial_rows = 55

--config.background = {
  --{
    --source = {
      --File = '/home/clobrano/Me/Notes/3-Resources/Wallpaper/WallpaperDog-6865.jpg'
    --},
    --hsb = { brightness = 0.02 }
  --}
--}
-- skip close confirmation
config.skip_close_confirmation_for_processes_named = { 'flatpak-spawn' }

return config
