return {
	"folke/snacks.nvim",
	enabled = true,
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		-- bigfile = { enabled = false },
		dashboard = {
			enabled = true,
			sections = {
				-- { section = "header" },
				{
					section = "terminal",
					cmd = "figlet -f basic 'Neovim'",
					hl = "header",
					height = 8,
					padding = 1,
					indent = 3,
				},
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
		indent = {
			enabled = true,
			animate = {
				enabled = false,
			},
		},
		picker = {
			enabled = true,
			matcher = {
				fuzzy = true, -- use fuzzy matching
				smartcase = true, -- use smartcase
				ignorecase = true, -- use ignorecase
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- support patterns like `file:line:col` and `file:line`
				-- the bonusses below, possibly require string concatenation and path normalization,
				-- so this can have a performance impact for large lists and increase memory usage
				cwd_bonus = true, -- give bonus for matching files in the cwd
				frecency = false, -- frecency bonus
				history_bonus = false, -- give more weight to chronological order
			},
		},
		input = { enabled = true },
		image = { enabled = false },
		explorer = { enabled = false },
	},
    -- stylua: ignore
	keys = {
		{"<leader><leader>", function() require('snacks').picker.smart() end, desc = "Smart Find Files"},
	},
}
