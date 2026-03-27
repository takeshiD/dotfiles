return {
	"lewis6991/hover.nvim",
	dependencies = {
		-- {
		-- 	dir = "~/ex_prog/ex_lua/hover-git.nvim",
		-- },
        "takeshid/hover-git.nvim"
	},
	keys = {
		{
			"U",
			function()
				require("hover").open()
			end,
			mode = { "n" },
			desc = "Hover Open",
		},
		{
			"gu",
			function()
				require("hover").enter()
			end,
			mode = { "n" },
			desc = "Hover Enter",
		},
	},
	config = function()
		require("hover").config({
			providers = {
				"hover.providers.diagnostic",
				"hover.providers.lsp",
				"hover.providers.gh",
                "hover-git"
				-- "plugins.hover_providers.simple", -- sample provider
			},
			preview_opts = { border = "single" },
			preview_window = true,
			title = true,
		})
	end,
}
