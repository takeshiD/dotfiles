return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
            checkOnSave = true,
            diagnostics = {
                enable = true,
            },
			check = {
				-- command = "check",
				command = "clippy",
                workspace = true,
			},
            lens = {
                enable = true,
            }
		},
	},
}
