return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local color = require("functions.color")
		local NormalBG = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
		local ChunkHighlight1FG = vim.api.nvim_get_hl(0, { name = "PreProc" }).fg
		local ChunkHighlight1 = { fg = color.composeColor(ChunkHighlight1FG, NormalBG, 0) }
		local IndentHighlight1FG = vim.api.nvim_get_hl(0, { name = "Constant" }).fg
		local IndentHighlight2FG = vim.api.nvim_get_hl(0, { name = "String" }).fg
		local IndentHighlight3FG = vim.api.nvim_get_hl(0, { name = "Function" }).fg
		local IndentHighlight4FG = vim.api.nvim_get_hl(0, { name = "Keyword" }).fg
		local IndentHighlight5FG = vim.api.nvim_get_hl(0, { name = "String" }).fg
		local IndentHighlight6FG = vim.api.nvim_get_hl(0, { name = "PreProc" }).fg
		local IndentHighlight1 = { fg = color.composeColor(IndentHighlight1FG, NormalBG, 0.7) }
		local IndentHighlight2 = { fg = color.composeColor(IndentHighlight2FG, NormalBG, 0.7) }
		local IndentHighlight3 = { fg = color.composeColor(IndentHighlight3FG, NormalBG, 0.7) }
		local IndentHighlight4 = { fg = color.composeColor(IndentHighlight4FG, NormalBG, 0.7) }
		local IndentHighlight5 = { fg = color.composeColor(IndentHighlight5FG, NormalBG, 0.7) }
		local IndentHighlight6 = { fg = color.composeColor(IndentHighlight6FG, NormalBG, 0.7) }
		require("hlchunk").setup({
			chunk = {
				enable = true,
				use_treesitter = true,
				duration = 100,
				delay = 100,
				style = {
					ChunkHighlight1,
				},
			},
			indent = {
				enable = true,
				use_treesitter = false,
				chars = {
					"│",
					-- "¦",
					-- "┆",
					-- "┊",
				},
				style = {
					IndentHighlight1,
					IndentHighlight2,
					IndentHighlight3,
					IndentHighlight4,
					IndentHighlight5,
					IndentHighlight6,
				},
                exclude_filetypes = {"nix"}
			},
		})
	end,
}
