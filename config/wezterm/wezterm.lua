-- wezterm API
local wezterm = require('wezterm')
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
config.enable_tab_bar = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "TITLE | RESIZE"

-- ============ Inner Appearance ===========
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- ============ Color and Font  ===========
config.color_scheme = 'Espresso'
config.window_background_opacity = 1
config.font = wezterm.font("HackGen Console NF", { weight = "Regular", stretch = "Normal" })
config.font_size = 14


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

-- ##### Only Windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    config.default_prog = { 'nu' }
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
    local function tab_title(tab_info)
        local title = tab_info.tab_title
        if title and #title > 0 then
            return " " .. title " "
        end
        return " " .. tab_info.active_pane.title .. " "
    end

    local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
    local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local background = "#808080"
        local foreground = "#cccccc"
        local edge_background = "none"
        if tab.is_active then
            background = "#ff7f50"
            foreground = "#ffffff"
        end
        local edge_foreground = background
        local title = tab_title(tab)
        title = wezterm.truncate_right(title, max_width - 2)
        return {
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_LEFT_ARROW },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Background = { Color = edge_background } },
            { Foreground = { Color = edge_foreground } },
            { Text = SOLID_RIGHT_ARROW },
        }
    end)
end

if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
    config.default_prog = { 'bash' }
    config.enable_tab_bar = false
    config.enable_wayland = true
end
-- ##### GPU
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == 'Vulkan' and gpu.device_type == 'IntegratedGpu' then
    config.webgpu_preferred_adapter = gpu
    config.front_end = 'WebGpu'
    break
  end
end
config.freetype_load_target = "Light"
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

return config
