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
-- keymap.set("n", "<Return><Return>", "<C-w>w", { desc = "BufferCyclic" })
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
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Formatting" })
vim.keymap.set("n", "g]", function()
	vim.diagnostic.jump({ count = 1, float = false })
end, { desc = "LSP Diagnostic Next" })
vim.keymap.set("n", "g[", function()
	vim.diagnostic.jump({ count = -1, float = false })
end, { desc = "LSP Diagnostic Prev" })

--############# Window resize submode ###############
-- <C-w>H, <C-w>J, <C-w>K, <C-w>L でサブモードに入り、H,J,K,Lで調整
local resize_steps = {
	H = { "<", 4 },
	L = { ">", 4 },
	J = { "+", 2 },
	K = { "-", 2 },
}
local function window_resize_mode()
	local exits = { [vim.keycode("<Esc>")] = true, [vim.keycode("<CR>")] = true, q = true }
	while true do
		vim.cmd.redraw()
		local ok, key = pcall(vim.fn.getcharstr)
		if not ok or key == nil or exits[key] then
			break
		end
		local step = resize_steps[key]
		if step ~= nil then
			local cmd, step_width = unpack(step)
			local cur_winnr = vim.fn.winnr()
			-- has_left
			if vim.fn.winnr("h") ~= cur_winnr then
				if cmd == ">" then
					cmd = "<"
				elseif cmd == "<" then
					cmd = ">"
				end
			end
			-- has_top
			if vim.fn.winnr("k") ~= cur_winnr then
				if cmd == "-" then
					cmd = "+"
				elseif cmd == "+" then
					cmd = "-"
				end
			end
			vim.cmd.wincmd({ args = { cmd }, count = step_width })
		else
			break
		end
	end
	vim.api.nvim_echo({}, false, {})
end

keymap.set("n", "<C-w>H", window_resize_mode, { desc = "Window Resize Mode" })
keymap.set("n", "<C-w>J", window_resize_mode, { desc = "Window Resize Mode" })
keymap.set("n", "<C-w>K", window_resize_mode, { desc = "Window Resize Mode" })
keymap.set("n", "<C-w>L", window_resize_mode, { desc = "Window Resize Mode" })
