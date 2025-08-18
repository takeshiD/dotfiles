return {
	"nvim-treesitter/nvim-treesitter",
	enabled = true,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
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
				"latex",
				"make",
				"python",
				"scheme",
				"yaml",
				"toml",
				"nix",
			},
			ignore_install = {
				"org",
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
				disable = { "yaml", "nix" },
			},
		})
	end,
}
