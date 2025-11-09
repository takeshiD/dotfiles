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
			-- vim.keymap.set("n", "gf", function()
			-- 	vim.lsp.buf.format({ bufnr = args.buf, id = client.id, async = true })
			-- end, { buffer = args.buf, desc = "LSP Formatting" })
		end
	end,
})

---@param lsp_name string
local function load_lsp_opts(lsp_name)
	vim.lsp.enable(lsp_name)
	local status, opts = pcall(require, "lsp." .. lsp_name)
	if status then
		vim.lsp.config(lsp_name, opts)
	else
		vim.notify(
			"[LSP] " .. lsp_name .. " is ensured but your config was not found. using nvim-lspconfig instead.",
			vim.log.levels.WARN
		)
	end
end

local ensure_installed = {
	"lua_ls",
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
	"taplo",
	"cmake",
	"clangd",
	-- "yamlls",
	"hls",
	"nrs_ls",
}
for _, lsp_name in pairs(ensure_installed) do
	load_lsp_opts(lsp_name)
end
