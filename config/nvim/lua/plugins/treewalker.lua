return {
	"aaronik/treewalker.nvim",
	keys = {
		{ "<C-l>", "<cmd>Treewalker Right<cr>", mode = { "n", "v" }, desc = "Treewaler Right" },
		{ "<C-h>", "<cmd>Treewalker Left<cr>", mode = { "n", "v" }, desc = "Treewalker Left" },
		-- { "<C-[>", "<cmd>Treewalker SwapUp<cr>", mode = { "n" }, desc = "Treewalker SwapUp" },
		-- { "<C-]>", "<cmd>Treewalker SwapDown<cr>", mode = { "n" }, desc = "Treewalker SwapDown" },
		-- { "<C-,>", "<cmd>Treewalker SwapLeft<cr>", mode = { "n" }, desc = "Treewalker SwapLeft" },
		-- { "<C-.>", "<cmd>Treewalker SwapRight<cr>", mode = { "n" }, desc = "Treewalker SwapRight" },
	},
    opts = {
        highlight = false,
    }
}
