-- 自然言語で命令板・行検索を開く（TypeSafe jev API）。手元の開発版を読む
return {
	dir = "~/ex_prog/ex_lua/whachama.nvim",
	name = "whachama.nvim",
	lazy = true,
	-- cmd = "Whachama",
	enabled = false,
	opts = {},
	keys = {
		{
			"<leader>?",
			function()
				require("whachama").palette()
			end,
			mode = { "n", "x" },
			desc = "Semantic search",
		},
	},
}
