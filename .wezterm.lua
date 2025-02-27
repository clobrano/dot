-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = wezterm.config_builder()


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
}

config.window_padding = { left = 20, right = 5, top = 15, bottom = 5, }
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
skip_close_confirmation_for_processes_named = { 'flatpak-spawn' }

return config
