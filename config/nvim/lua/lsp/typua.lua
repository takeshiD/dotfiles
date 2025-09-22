return {
	cmd = { "typua", "lsp" },
	filetypes = { "lua" },
	root_markers = { ".git", ".typua.toml" },
	settings = {
		Lua = {
			runtime = {
				version = "luajit",
				path = { "*.lua", "*/init.lua" },
			},
		},
	},
}
