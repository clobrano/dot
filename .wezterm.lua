-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
--config.color_scheme = 'Darcula (base16)'
--config.color_scheme = 'Chalk'
--config.color_scheme = 'Catppuccin Macchiato'
--config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = 'catppuccin-frappe'
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font = wezterm.font('Source Code Pro Medium', { italic = false })
config.font_size = 12

-- disable title bar
config.window_decorations = "NONE"
-- disable the tab bar with only one tab
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false


config.window_frame = {
  border_left_width = '0.2cell',
  border_right_width = '0.2cell',
  border_bottom_height = '0.1cell',
  border_top_height = '0.1cell',
  border_left_color = 'cyan',
  border_right_color = 'cyan',
  border_bottom_color = 'cyan',
  border_top_color = 'cyan',
}

-- and finally, return the configuration to wezterm
return config
