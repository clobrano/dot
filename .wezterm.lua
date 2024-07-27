-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}


-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_frame = {
  font_size=12,
  --inactive_titlebar_bg = '#353535',
  active_titlebar_bg = '#2b2b2b',
  --inactive_titlebar_fg = '#cccccc',
  --active_titlebar_fg = '#ffffff',
  --inactive_titlebar_border_bottom = '#2b2042',
  --active_titlebar_border_bottom = '#2b2042',
  --button_fg = '#300',
  --button_bg = '#0f0',
  --button_hover_fg = '#0f0',
  --button_hover_bg = '#0f0',
}

config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#575757',
  },
}

-- This is where you actually apply your config choices
config.color_scheme = 'catppuccin-frappe'

-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font('Source Code Pro Medium', { italic = false, weight = 'Bold' })
config.font_size = 11

-- disable title bar
--config.window_decorations = "INTEGRATED_BUTTONS | NONE"
config.window_decorations = "NONE"

-- disable the tab bar with only one tab
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.hide_mouse_cursor_when_typing = false

config.window_padding = { left = 20, right = 5, top = 15, bottom = 5, }

--config.window_frame = {
  --border_left_width = '0.2cell',
  --border_right_width = '0.2cell',
  --border_bottom_height = '0.1cell',
  --border_top_height = '0.1cell',
  --border_left_color = 'cyan',
  --border_right_color = 'cyan',
  --border_bottom_color = 'cyan',
  --border_top_color = 'cyan',
--}

-- and finally, return the configuration to wezterm
return config
