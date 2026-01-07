local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- config.default_domain = "WSL:Arch"
config.hide_tab_bar_if_only_one_tab = true
config.use_ime = true
config.font_size = 12
config.font = wezterm.font("HackGen Console NF", { weight = "Regular" })
config.window_close_confirmation = "AlwaysPrompt"
config.enable_scroll_bar = true
config.initial_rows = 36
config.initial_cols = 120
config.default_cursor_style = "BlinkingUnderline"
config.enable_kitty_graphics = true
return config
