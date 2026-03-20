return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- use latest release, remove to use latest commit
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false, -- this will be removed in the next major release
		workspaces = {
			{
				name = "notes",
				path = "~/vaults/notes",
			},
		},
		---@type obsidian.config.DailyNotesOpts
		daily_notes = {
			enabled = true,
			folder = "daily",
			date_format = "YYYY-MM-DD",
			alias_format = nil,
			default_tags = nil,
			workdays_only = false,
		},
	},
	keys = {
		{ "<leader>oo", ":Obsidian<cr>", mode = { "n" }, desc = "Obsidian Entry" },
		{ "<leader>od", ":Obsidian dailies -300 0<cr>", mode = { "n" }, desc = "Obsidian Entry" },
	},
}
