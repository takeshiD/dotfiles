return {
	"lewis6991/hover.nvim",
	keys = {
		{
			"O",
			function()
				require("hover").hover()
			end,
			mode = { "n" },
			{ desc = "LSP Diagnostics" },
		},
	},
	config = function()
		require("hover").config({
			providers = {
				"hover.providers.diagnostic",
				"hover.providers.lsp",
			},
			preview_opts = { border = "single" },
			preview_window = true,
			title = true,
		})
	end,
}
