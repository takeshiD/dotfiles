return {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	config = function()
		local toggleterm = require("toggleterm")
		------------------------------------------
		-- Configuration bash on FloatingWindow --
		------------------------------------------
		toggleterm.setup({
			shell = vim.o.shell,
			direction = "float",
			size = 60,
			float_opts = {
				border = "single",
				title_pos = "left",
			},
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true })
			end,
			open_mapping = [[<C-t>]],
			insert_mapping = true,
			terminal_mapping = true,
			start_in_insert = true,
			auto_scroll = true,
		})
		---------------------------------------------
		-- Configuration Lazygit on FloatingWindow --
		---------------------------------------------
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			display_name = "LazyGit",
			dir = "git_dir",
			direction = "float",
			float_opts = {
				border = "double",
			},
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			on_close = function(term)
				vim.cmd("startinsert!")
			end,
		})
		function _lazygit_toggle()
			lazygit:toggle()
		end
		vim.api.nvim_set_keymap(
			"n",
			"<leader>g",
			"<cmd>lua _lazygit_toggle()<CR>",
			{ noremap = true, silent = true, desc = "Toggle LazyGit on floating" }
		)
	end,
}
