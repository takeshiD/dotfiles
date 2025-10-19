return {
	"aaronik/treewalker.nvim",
	keys = {
		{ "<C-l>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "Right move" },
		{ "<C-h>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, desc = "Left move" },
	},
	config = function()
		vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>Treewalker Right<cr>")
		vim.keymap.set({ "n", "v" }, "<C-h>", "<cmd>Treewalker Left<cr>")
	end,
}
