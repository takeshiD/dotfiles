return {
	"lewis6991/hover.nvim",
	keys = {
		{
			"U",
			function()
				require("hover").hover()
			end,
			mode = { "n" },
			desc = "LSP Diagnostics",
		},
	},
	config = function()
		require("hover").config({
			providers = {
				"hover.providers.diagnostic",
				"hover.providers.lsp",
                "plugins.hover_providers.simple",
			},
			preview_opts = { border = "single" },
			preview_window = true,
			title = true,
		})
	end,
}
