-- Color scheme is specified in init.lua
return {
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		-- opts = function() end,
	},
	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		opts = function()
			require("eldritch").setup({})
		end,
	},
	{
		"0xstepit/flow.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		opts = function()
			require("flow").setup({
				theme = {
					style = "dark",
					contrast = "high",
				},
			})
		end,
	},
	{
		"navarasu/onedark.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		opts = function()
			require("onedark").setup({
				style = "darker",
			})
		end,
	},
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		enabled = true,
		priority = 1000,
		opts = function()
			require("cyberdream").setup({
				variant = "dark",
				italic_comments = false,
				extensions = {
					telescope = true,
					gitsigns = true,
					blinkcmp = true,
					mini = true,
				},
			})
		end,
	},
	{
		"sainnhe/everforest",
		lazy = false,
		enabled = true,
		priority = 1000,
	},
	{
		"RRethy/base16-nvim",
		enabled = true,
		lazy = false,
		priority = 1000,
	},
	{
		"EdenEast/nightfox.nvim",
		enabled = true,
		lazy = false,
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true,
					inverse = {
						match_paren = true,
						visual = true,
						search = true,
					},
				},
			})
			local color = require("functions.color")
			local match_paren_hl = vim.api.nvim_get_hl(0, { name = "MatchParen" })
			local MatchParenBG = match_paren_hl.fg
			local MatchParenFG = match_paren_hl.fg
			if MatchParenFG == nil then
				MatchParenFG = tonumber("FFFFFF", 16) --- #FFFFFF is white
			end
			if MatchParenBG == nil then
				MatchParenBG = tonumber("FFFFFF", 16) --- #FFFFFF is white
			end
			local NormalBg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
			vim.api.nvim_set_hl(0, "MatchParen", {
				bg = color.composeColor(MatchParenBG, NormalBg, 0.7),
				fg = MatchParenFG,
				bold = true,
			})
		end,
	},
	{
		"uloco/bluloco.nvim",
		enabled = true,
		lazy = false,
		priority = 1000,
		dependencies = {
			"rktjmp/lush.nvim",
		},
		config = function()
			require("bluloco").setup({
				style = "dark",
				transparent = false,
				italics = true,
				rainbow_headings = true,
			})
		end,
	},
}
