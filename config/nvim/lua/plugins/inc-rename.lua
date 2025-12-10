return {
	"smjonas/inc-rename.nvim",
    lazy = false,
	dependencies = {
		-- "stevearc/dressing.nvim",
		"folke/snacks.nvim",
	},
	config = function()
		require("inc_rename").setup({
			-- input_buffer_type = "dressing",
			input_buffer_type = "snacks",
		})
		vim.keymap.set("n", "gn", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { expr = true })
	end,
}
