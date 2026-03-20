return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function(_, opts)
		require("bufferline").setup({
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				indicator = {
					style = "underline",
				},
				separator_style = "slant",
				show_tab_indicators = true,
				show_duplicate_prefix = true,
			},
		})
	end,
}
