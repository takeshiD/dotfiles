return {
	"neovim/nvim-lspconfig",
    enabled = false,
	-- tag = "v2.0.0",
	config = function()
		local lspconfig = require("lspconfig")
		lspconfig.teal_ls.setup({
			cmd = { "/home/tkcd/.luarocks/bin/teal-language-server" },
			filetypes = { "teal" },
			root_markers = { "tlconfig.lua" },
		})
	end,
}
