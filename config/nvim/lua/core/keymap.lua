local keymap = vim.keymap
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

keymap.set("n", "<ESC><ESC>", ":noh<Return>")
keymap.set("n", "j", "gj", { desc = "Down" })
keymap.set("n", "k", "gk", { desc = "Up" })
keymap.set("n", "gj", "j", { desc = "Left" })
keymap.set("n", "gk", "k", { desc = "Right" })
keymap.set("n", "<Return><Return>", "<C-w>w", { desc = "BufferCyclic" })
keymap.set("n", "<C-p>", ":bprev<Return>")
keymap.set("n", "<C-n>", ":bnext<Return>")
keymap.set("n", "<C-w><C-w>", ":bdelete %<Return>")
keymap.set("n", "L", "$")
keymap.set("n", "H", "^")
keymap.set("v", "L", "$")
keymap.set("v", "H", "^")
keymap.set("i", "jj", "<ESC>")

--############# US-keyboard ###############
keymap.set("n", ";", ":")
keymap.set("n", ":", ";")
keymap.set("v", ";", ":")
keymap.set("v", ":", ";")

--############# LSP-keyboard ###############
-- vim.keymap.set("n", "K", '<cmd>lua vim.lsp.buf.hover()<CR>')         -- Defined plugins/hover.lua
-- vim.keymap.set("n", "gr", '<cmd>lua vim.lsp.buf.references()<CR>')   -- Defined plugins/glance.lua
-- vim.keymap.set("n", "gd", '<cmd>lua vim.lsp.buf.definition()<CR>')   -- Defined plugins/glance.lua
-- vim.keymap.set("n", "gn", '<cmd>lua vim.lsp.buf.rename()<CR>')       -- Defined plugins/inc-rename.lua
-- vim.keymap.set("n", "ga", '<cmd>lua vim.lsp.buf.code_action()<CR>')  -- Defined plugins/actions-preview.lua
vim.keymap.set("n", "gf", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "LSP Formatting" })
vim.keymap.set("n", "g]", function()
	vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "LSP Diagnostic Next" })
vim.keymap.set("n", "g[", function()
	vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "LSP Diagnostic Prev" })
