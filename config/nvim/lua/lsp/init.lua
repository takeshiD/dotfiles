require("vim.lsp.log").set_format_func(vim.inspect)
vim.api.nvim_create_user_command("LspHealth", "checkhealth vim.lsp", { desc = "LSP Health Check" })
vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd(string.format("tabnew %s", vim.lsp.get_log_path()))
end, {
	desc = "Opens the Nvim LSP client log.",
})

vim.lsp.inlay_hint.enable()
vim.diagnostic.config({
	virtual_text = true,
})

-- augroup for this config file
local augroup = vim.api.nvim_create_augroup("lsp/init.lua", {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/formatting") then
		end
	end,
})

local ensure_installed = {
	-- "lua_ls",
	"rust_analyzer",
	"pylsp",
	"pyright",
	-- "ty",
	"typua",
	"ruff",
	"markdown_oxide",
	"ts_ls",
	"eslint",
	-- "dprint",
	"tailwindcss",
	"cssls",
	"html",
	"jsonls",
	"bashls",
	"nil_ls",
	"nixd",
	"taplo",
	"cmake",
	"clangd",
	-- "yamlls",
	"hls",
}
for _, lsp_name in pairs(ensure_installed) do
	vim.lsp.enable(lsp_name)
end
