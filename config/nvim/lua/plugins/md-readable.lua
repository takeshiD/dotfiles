return {
	"takeshid/md-readable.nvim",
	branch = "feat/readable-implementation",
	-- dir = "~/ex_prog/ex_lua/md-readable.nvim",
	-- name = "md-readable.nvim",
	lazy = true,
	keys = {
		{ "<leader>mm", "<CMD>MdReadable<CR>", ft = "markdown", desc = "Readable" },
	},
	opts = {},
}
