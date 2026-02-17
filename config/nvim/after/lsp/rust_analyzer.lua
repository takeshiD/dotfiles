return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
            checkOnSave = true,
			check = {
				command = "check",
				-- command = "clippy",
                workspace = true,
			},
		},
	},
}
