return {
	"danielfalk/smart-open.nvim",
	enabled = false,
	dependencies = {
		"kkharji/sqlite.lua",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{
			mode = { "n" },
			"<leader><leader>",
			function()
				require("telescope").extensions.smart_open.smart_open({
					cwd_only = false,
					filename_first = true,
				})
			end,
			desc = "SmartOpen",
		},
	},
	config = function()
		require("telescope").load_extension("smart_open")
	end,
}
