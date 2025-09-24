return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	enabled = true,
	keys = {
		{ mode = { "n" }, "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", desc = "Unstaged FileHistory" },
		{
			mode = { "n" },
			"<leader>df",
			function()
				if next(require("diffview.lib").views) == nil then
					vim.cmd("DiffviewOpen HEAD~1")
				else
					vim.cmd("DiffviewClose")
				end
			end,
			desc = "Diff Previous Commit to HEAD",
		},
	},
	config = function()
		local actions = require("diffview.actions")
		require("diffview").setup({
			keymaps = {
				view = {
					{ "n", "<C-e>", actions.toggle_files, { desc = "Toggle FilePanel" } },
				},
				file_panel = {
					{ "n", "<C-e>", actions.toggle_files, { desc = "Toggle FilePanel" } },
				},
			},
		})
	end,
}
