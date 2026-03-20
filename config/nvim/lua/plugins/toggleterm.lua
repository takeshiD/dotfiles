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
	end,
}
