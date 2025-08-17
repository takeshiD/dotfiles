-- Color scheme is specified in init.lua
return {
	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		enabled = false,
		priority = 1000,
	},
	{
		"sainnhe/everforest",
		lazy = false,
		enabled = false,
		priority = 1000,
	},
	{
		"RRethy/base16-nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme base16-espresso]])
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		enabled = true,
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme carbonfox]])
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
		enabled = false,
		lazy = false,
		priority = 1000,
		dependencies = {
			"rktjmp/lush.nvim",
		},
		config = function()
			vim.cmd([[colorscheme bluloco]])
			require("bluloco").setup({
				style = "dark",
				transparent = true,
			})
		end,
	},
}
