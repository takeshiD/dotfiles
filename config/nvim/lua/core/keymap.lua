---@param buf number
---@return number[]
local wins_for_buf = function(buf)
	---@type number[]
	local wins = {}
	for _, _win in ipairs(vim.api.nvim_list_wins()) do
		local _buf = vim.api.nvim_win_get_buf(_win)
		if _buf ~= nil and _buf == buf then
			table.insert(wins, _win)
		end
	end
	return wins
end
local keymap = vim.keymap
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

keymap.set("n", "<ESC><ESC>", ":noh<Return>")
keymap.set("n", "<Return><Return>", "<C-w>w", { desc = "BufferCyclic" })
keymap.set("n", "<C-p>", ":bprev<Return>")
keymap.set("n", "<C-n>", ":bnext<Return>")
keymap.set("n", "<C-w><C-w>", ":close!<cr>")
keymap.set("n", "<C-w><C-w>", function()
	local cur_buf = vim.api.nvim_get_current_buf()
	local wins = wins_for_buf(cur_buf)
	if #wins > 1 then
		local cur_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_close(cur_win, false)
	else
		vim.api.nvim_buf_delete(cur_buf, {})
	end
end)
keymap.set("n", "<leader>bd", ":bdelete<Return>")
keymap.set("i", "jj", "<ESC>")

--############# Motion      ###############
keymap.set("n", "j", "gj", { desc = "Down" })
keymap.set("n", "k", "gk", { desc = "Up" })
keymap.set("n", "gj", "j", { desc = "Left" })
keymap.set("n", "gk", "k", { desc = "Right" })

keymap.set("n", "L", "$")
keymap.set("n", "H", "^")
keymap.set("v", "L", "$")
keymap.set("v", "H", "^")

keymap.set("n", "J", "5gj", { desc = "Large Down" })
keymap.set("n", "K", "5gk", { desc = "Large Up" })
keymap.set("v", "J", "5gj", { desc = "Large Down" })
keymap.set("v", "K", "5gk", { desc = "Large Up" })

--############# US-keyboard ###############
keymap.set("n", ";", ":")
keymap.set("n", ":", ";")
keymap.set("v", ";", ":")
keymap.set("v", ":", ";")

--############# LSP-keyboard ###############
vim.keymap.set("n", "gf", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "LSP Formatting" })
vim.keymap.set("n", "g]", function()
	vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "LSP Diagnostic Next" })
vim.keymap.set("n", "g[", function()
	vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "LSP Diagnostic Prev" })
