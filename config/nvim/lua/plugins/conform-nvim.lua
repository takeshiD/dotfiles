return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			markdown = { "injected" },
			lua = { "stylua" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
		},
	},
}
