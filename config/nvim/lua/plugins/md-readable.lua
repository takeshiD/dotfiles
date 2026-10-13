return {
	-- "takeshid/md-readable.nvim",
	-- branch = "feat/readable-implementation",
	dir = "~/ex_prog/ex_lua/md-readable.nvim",
	name = "md-readable.nvim",
	enabled = true,
	keys = {
		{ "<leader>mm", "<CMD>MdReadable<CR>", ft = "markdown", desc = "Readable" },
		{ "<leader>mv", "<CMD>MdReadable vert<CR>", ft = "markdown", desc = "Writer Mode" },
	},
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		{ "nvim-mini/mini.icons" },
	},
	opts = {
		-- 読書bufferのキーマップ。既定値に対してキー単位で上書き・追加・無効化する
		keymaps = {
			["<leader>mm"] = { mode = "n", "actions.close", desc = "Close Buffer" },
			["go"] = { mode = "n", "actions.toggle_nav", desc = "Toggle Navigation" },
			["g?"] = { mode = "n", "actions.show_help", desc = "Show Help" },
		},
		links = { enable = true }, -- false: リンクの強調表示と種別記号を出さない
		table = { enable = true }, -- false: 表を整形せずMarkdownのまま表示
		focus = { enable = true }, -- 読書表示を開いた時点でFocusを有効にする
		minimap = {
			enable = false,
			width = 14,
			mode = "braille",
			git = false,
			diagnostic = false,
		},
		images = { enable = true },
		mermaid = {
			enable = false,
			command = "mmdc",
			no_sandbox = true,
		},
		code = {
			theme = "github-dark",
			label = "right",
			icons = "mini",
		},
	},
}
