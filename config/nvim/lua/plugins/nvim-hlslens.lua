return {
	"kevinhwang91/nvim-hlslens",
	enabled = true,
	opts = function()
		require("hlslens").setup()
		local kopts = { noremap = true, silent = true }
		vim.api.nvim_set_keymap(
			"n",
			"n",
			[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts
		)
		vim.api.nvim_set_keymap(
			"n",
			"N",
			[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts
		)
		vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
		-- vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.keymap.set("n", "#", function()
			local current_word = vim.fn.expand("<cword>")
			vim.api.nvim_feedkeys(":%s/" .. current_word .. "//g", "n", false)
			-- :%s/word/CURSOR/g
			local ll = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
			vim.api.nvim_feedkeys(ll, "n", false)
			vim.opt.hlsearch = true
			require("hlslens").start()
		end, kopts)
		vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)
	end,
}
