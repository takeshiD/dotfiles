vim.api.nvim_create_user_command("LspHealth", "checkhealth vim.lsp", { desc = "LSP Health Check" })
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
			vim.keymap.set("n", "gf", function()
				vim.lsp.buf.format({ bufnr = args.buf, id = client.id, async = true })
			end, { buffer = args.buf, desc = "LSP Formatting" })
		end
	end,
})

vim.lsp.config("*", {
	root_markers = { ".git" },
	capabilities = require("blink.cmp").get_lsp_capabilities({
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
	}),
})

---@param lsp_name string
local function load_lsp_opts(lsp_name)
	local opts = require("lsp." .. lsp_name)
	vim.lsp.config(lsp_name, opts)
	vim.lsp.enable(lsp_name)
end
local ensure_installed = {
	"lua_ls",
	"rust-analyzer",
	"pylsp",
	"pyright",
	-- "ty",
	"ruff",
	"markdown-oxide",
	"ts_ls",
	"eslint",
	"dprint",
	"tailwindcss",
	"css_ls",
	"html_ls",
	"bash_ls",
	"nil_ls",
	"taplo",
	"cmake",
	"clangd",
	"yaml_ls",
	"hls",
}

for _, lsp_name in pairs(ensure_installed) do
	load_lsp_opts(lsp_name)
end
