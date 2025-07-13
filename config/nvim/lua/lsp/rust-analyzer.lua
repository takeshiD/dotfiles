return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy"
            }
        }
	},
}
