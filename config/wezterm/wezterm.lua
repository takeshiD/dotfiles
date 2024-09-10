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

-- ============ Color and Font  ===========
config.color_scheme = 'Espresso Libre'
config.window_background_opacity = 1
config.font = wezterm.font("HackGen Console NF", { weight = "Regular", stretch = "Normal" })
config.font_size = 12


-- #########################################
-- ######         Key Binding         ######
-- #########################################
config.keys = {
    { key = 'F11', mods = '',     action = wezterm.action.ToggleFullScreen },
    { key = '-',   mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
    { key = '=',   mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
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
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { 'powershell' }
    config.use_fancy_tab_bar = false
    config.enable_tab_bar = true
    config.keys = {
        {
            key = 'a',
            mods = 'CTRL',
            action = wezterm.action.ActivateKeyTable {
                name = 'operate_pane',
                timeout_milliseconds = 1000,
            },
        },
    }
    config.key_tables = {
        operate_pane = {
            { key = 'h', action = wezterm.action.ActivatePaneDirection 'Left' },
            { key = 'l', action = wezterm.action.ActivatePaneDirection 'Right' },
            { key = 'k', action = wezterm.action.ActivatePaneDirection 'Up' },
            { key = 'j', action = wezterm.action.ActivatePaneDirection 'Down' },
            { key = 'H', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
            { key = 'L', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
            { key = 'K', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
            { key = 'J', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
            {
                key = "v",
                action = wezterm.action.SplitPane {
                    direction = "Right",
                    size = { Percent = 50 },
                },
            },
            {
                key = "s",
                action = wezterm.action.SplitPane {
                    direction = "Down",
                    size = { Percent = 50 },
                }
            },
            { key = 'c', action = wezterm.action.SpawnTab "CurrentPaneDomain" },
            { key = 'n', action = wezterm.action.ActivateTabRelative(1) },
            { key = 'p', action = wezterm.action.ActivateTabRelative(-1) },
        },
    }
end
config.enable_wayland = true

return config
