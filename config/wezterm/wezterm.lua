-- wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Logger
wezterm.on('window-focus-changed', function(window, pane)
  wezterm.log_info(
    'the focus state of ',
    window:window_id(),
    ' changed to ',
    window:is_focused()
  )
end)

-- #########################################
-- ######        Look and Feel        ######
-- #########################################
-- ============ Outer Appearance ===========
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.enable_tab_bar = false
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = "TITLE | RESIZE"

-- ============ Inner Appearance ===========
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

-- ============ Color and Font  ===========
-- config.color_scheme = 'Tokyo Night Storm'
config.color_scheme = 'Espresso Libre'
config.window_background_opacity = 1
config.font = wezterm.font("HackGen Console NF", {weight="Regular", stretch="Normal"})
config.font_size = 16


-- #########################################
-- ######         Key Binding         ######
-- #########################################
config.keys = {  
    { key = 'F11',  mods = '',      action = wezterm.action.ToggleFullScreen},
    { key = 'v',    mods = 'CTRL',  action = wezterm.action.PasteFrom 'Clipboard'},
    { key = '-',    mods = 'CTRL',  action = wezterm.action.DecreaseFontSize},
    { key = '=',    mods = 'CTRL',  action = wezterm.action.IncreaseFontSize},
}


-- #########################################
-- ######             MISC            ######
-- #########################################
config.automatically_reload_config = true
wezterm.on('window-config-reloaded', function(window, pane)
    wezterm.log_info 'the config was reloaded for this window!'
end)
config.use_ime = true
config.exit_behavior = 'CloseOnCleanExit'
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}
config.enable_wayland = false



return config
