return {
	cmd = { "tsrs", "--lsp", "-stdio" }, -- or the absolute path to target/release/tsrs
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}
