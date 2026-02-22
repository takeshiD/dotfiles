return {
	"danielfalk/smart-open.nvim",
	enabled = false,
	branch = "0.2.x",
	dependencies = {
		"kkharji/sqlite.lua",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		require("telescope").load_extension("smart_open")
		vim.keymap.set("n", "<leader><leader>", function()
			require("telescope").extensions.smart_open.smart_open()
		end, { noremap = true, silent = true })
	end,
}
