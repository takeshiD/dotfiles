return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	lazy = false,
	version = false,
	build = ":TSUpdate",
	opts = function()
		local langs = {
			"bash",
			"c",
			"cpp",
			"lua",
			"vim",
			"rust",
			"markdown",
			"markdown_inline",
			"mermaid",
			"haskell",
			"http",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"css",
			"json",
			"make",
			"python",
			"scheme",
			"yaml",
			"toml",
			"nix",
			"astro",
		}
		require("nvim-treesitter").install(langs)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = langs,
			callback = function()
				vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
