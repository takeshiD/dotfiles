return {
	cmd = { "typua", "lsp" },
	filetypes = { "lua" },
	root_markers = { ".git", ".typua.toml" },
	settings = {
		typua = {
			runtime = {
				version = "luajit",
				path = { "*.lua", "*/init.lua" },
			},
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                }
            }
		},
	},
}
