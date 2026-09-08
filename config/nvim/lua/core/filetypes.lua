vim.filetype.add({
	extension = {
		nrs = "nrs",
		mbt = "moonbit",
		mdx = "mdx",
	},
	pattern = {
		[".*/%.codex/rules/.*%.rules"] = "starlark",
	},
})
vim.treesitter.language.register("markdown", "mdx")

-- starlark filetype for codex rules
vim.filetype.add({
	pattern = {
		[".*/%.codex/rules/.*%.rules"] = "starlark",
	},
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "starlark",
	callback = function(args)
		vim.treesitter.start(args.buf, "starlark")
	end,
})
