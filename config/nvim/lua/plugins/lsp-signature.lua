return {
	"ray-x/lsp_signature.nvim",
    enabled = false,
	event = "InsertEnter",
	opts = {},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
