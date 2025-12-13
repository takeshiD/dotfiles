return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		-- bigfile = { enabled = false },
		-- dashboard = { enabled = true },
		-- explorer = { enabled = true },
		indent = {
			enabled = true,
			animate = {
				enabled = false,
			},
		},
		input = { enabled = true },
		picker = {
			enabled = true,
		},
		image = { enabled = true },
		-- quickfile = { enabled = true },
		-- scope = { enabled = true },
		-- statuscolumn = { enabled = true },
		-- words = { enabled = true },
	},
    -- stylua: ignore
	keys = {
		{"<leader><leader>", function() require('snacks').picker.smart() end, desc = "Smart Find Files"},
	},
}
