require("vim.lsp.log").set_format_func(vim.inspect)
-- vim.api.nvim_create_user_command("LspHealth", "checkhealth vim.lsp", { desc = "LSP Health Check" })
vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, {
	desc = "Nvim LSP log.",
})
vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, {
	desc = "Nvim LSP checkhealth.",
})

-- vim.lsp.set_log_level("debug")
vim.lsp.inlay_hint.enable()
-- vim.lsp.codelens.enable()
-- vim.lsp.completion.enable()
-- vim.lsp.semantic_tokens.enable()
-- vim.lsp.document_color.enable()
-- vim.lsp.inline_completion.enable()
-- vim.lsp.linked_editing_range.enable()
vim.diagnostic.config({
	virtual_lines = false,
	virtual_text = false,
	signs = {
		priority = 100,
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
})

-- augroup for this config file
-- local augroup = vim.api.nvim_create_augroup("lsp/init.lua", {})

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = augroup,
-- 	callback = function(args)
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
-- 		if client:supports_method("textDocument/formatting") then
-- 		end
-- 	end,
-- })

local ensure_installed = {
	"rust_analyzer",
	"bacon_ls",
	"pylsp",
	-- "pyright",
	-- "pyrefly",
	-- "ty",
	"zuban",
	"ruff",
	"lua_ls",
	"luau_lsp",
	-- "typua",
	"markdown_oxide",
	"ts_ls",
	"eslint",
	"astro",
	"cssls",
	"html",
	"jsonls",
	"bashls",
	"nil_ls",
	"nixd",
	"taplo",
	"cmake",
	"clangd",
	"yamlls",
	"hls",
	"csharp_ls",
}
for _, lsp_name in pairs(ensure_installed) do
	vim.lsp.enable(lsp_name)
end
