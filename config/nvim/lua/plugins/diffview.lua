return {
	-- "sindrets/diffview.nvim",
	"dlyongemallo/diffview-plus.nvim",
	event = "VeryLazy",
	enabled = true,
	cmd = {
		"DiffviewOpen",
		"DiffviewToggle",
		"DiffviewFileHistory",
		"DiffviewDiffFiles",
		"DiffviewLog",
	},
	keys = {
		{ mode = { "n" }, "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", desc = "Unstaged FileHistory" },
		{
			mode = { "n" },
			"<leader>df",
			function()
				if next(require("diffview.lib").views) == nil then
					vim.cmd("DiffviewOpen main..HEAD")
				else
					vim.cmd("DiffviewClose")
				end
			end,
			desc = "Diff Previous Commit to HEAD",
		},
	},
	config = function()
		vim.opt.fillchars:append({ diff = "╱" })
		vim.api.nvim_set_hl(0, "DiffDelete", {
			fg = "#555555",
			bg = "#202020",
		})
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
			default_args = {
				DiffViewOpen = { "--imply-local" },
			},
			view = {
				default = { winbar_info = false },
				merge_tool = { winbar_info = false },
				file_history = { winbar_info = false },
			},
			file_panel = {
				show_branch_name = true,
				always_show_sections = true,
			},
		})
	end,
}
