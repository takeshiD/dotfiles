return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	enabled = true,
	keys = {
		{ mode = { "n" }, "<leader>dh", "<cmd>DiffviewFileHistory %<CR>" },
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
		},
	},
	config = function()
        local actions = require("diffview.actions")
		require("diffview").setup({
			file_panel = {
				listing_style = "tree", -- One of 'list' or 'tree'
				tree_options = { -- Only applies when listing_style is 'tree'
					flatten_dirs = true, -- Flatten dirs that only contain one single dir
					folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
				},
				win_config = { -- See |diffview-config-win_config|
					position = "left",
					width = 30,
					win_opts = {},
				},
			},
			keymaps = {
				view = {
					{
						"n",
						"<C-e>",
						actions.toggle_files,
						{ desc = "Toggle FilePanel" },
					},
				},
				file_panel = {
					{
						"n",
						"<C-e>",
						actions.toggle_files,
						{ desc = "Toggle FilePanel" },
					},
				},
			},
		})
	end,
}
