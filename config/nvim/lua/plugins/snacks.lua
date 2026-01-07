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
		image = { enabled = false },
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
