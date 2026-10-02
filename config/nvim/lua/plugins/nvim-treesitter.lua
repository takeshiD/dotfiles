local ensure_install_langs = {
	"astro",
	"bash",
	"c",
	"cmake",
	"cpp",
	"css",
	"css",
	"haskell",
	"http",
	"javascript",
	"json",
	"lua",
	"make",
	"markdown",
	"markdown_inline",
	"mermaid",
	"nix",
	"python",
	"rust",
	"scheme",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"xml",
	"yaml",
	"zsh",
    "dockerfile",
}
return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	branch = "main",
	lazy = false,
	version = false,
	build = ":TSUpdate",
	opts = function()
		require("nvim-treesitter").install(ensure_install_langs)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = ensure_install_langs,
			callback = function()
				vim.treesitter.start()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
