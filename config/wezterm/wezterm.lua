-- Pull in the wezterm API
local wezterm = require 'wezterm'
wezterm.on('window-focus-changed', function(window, pane)
  wezterm.log_info(
    'the focus state of ',
    window:window_id(),
    ' changed to ',
    window:is_focused()
  )
end)
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Tokyo Night Storm'
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.font = wezterm.font("HackGen Console NF", {weight="Regular", stretch="Normal"})
config.font_size = 16
config.enable_tab_bar = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
-- config.window_frame = {
--   border_left_width     = '0.5cell',
--   border_right_width    = '0.5cell',
--   border_bottom_height  = '0.25cell',
--   border_top_height     = '0.25cell',

--   border_left_color     = 'yellow',
--   border_right_color    = 'yellow',
--   border_bottom_color   = 'yellow',
--   border_top_color      = 'yellow',
-- }
config.window_close_confirmation = 'NeverPrompt'
config.keys = {  
    {    
        key = 'F11',
        mods = '',
        action = wezterm.action.ToggleFullScreen,
    }
}
config.automatically_reload_config = true
wezterm.on('window-config-reloaded', function(window, pane)
    wezterm.log_info 'the config was reloaded for this window!'
end)
config.use_ime = true
config.exit_behavior = 'CloseOnCleanExit'
config.window_background_opacity = 0.9
config.window_decorations = "TITLE | RESIZE"
config.audible_bell = "SystemBeep"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}
config.enable_wayland = false

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local zoomed = ''
  if tab.active_pane.is_zoomed then
    zoomed = '[Z] '
  end

  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end)

-- and finally, return the configuration to wezterm
return config
