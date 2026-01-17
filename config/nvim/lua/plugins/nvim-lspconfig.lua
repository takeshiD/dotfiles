return {
	"neovim/nvim-lspconfig",
	lazy = false,
    dependencies = {
        "saghen/blink.cmp"
    },
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities({
			textDocument = {
				completion = {
					completionItem = {
						snippetSupport = true,
					},
				},
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		})
	end,
}
