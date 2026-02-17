return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	keys = {
		{
			"<leader>x",
			"<cmd>Trouble diagnostics_float_current_buf toggle<cr>",
			desc = "Diagnostics Current Buffer(Trouble)",
		},
		{
			"<leader>X",
			"<cmd>Trouble diagnostics_float_project toggle<cr>",
			desc = "Diagnostics Project(Trouble)",
		},
	},
	opts = {
		win = {
			type = "float",
			border = "rounded",
		},
		keys = {
			["<cr>"] = "jump_close",
			["q"] = "close",
		},
		modes = {
			diagnostics_float_current_buf = {
				mode = "diagnostics",
				title = " Diagnostics on Current Buffer",
				title_pos = "center",
				focus = true,
				auto_preview = true,
				keys = {
					["<cr>"] = "jump_close",
					["q"] = "close",
				},
				filter = {
					buf = 0,
				},
				win = {
					type = "float",
					border = "rounded",
					relative = "editor",
					size = {
						width = 0.345,
						height = 0.5,
					},
					position = {
						0.5,
						0.2,
					},
					zindx = 200,
				},
				preview = {
					type = "float",
					border = "rounded",
					relative = "editor",
					scratch = false,
					size = {
						width = 0.4,
						height = 0.5,
					},
					position = {
						0.5,
						0.8,
					},
					zindex = 199,
				},
			},
			diagnostics_float_project = {
				mode = "diagnostics",
				title = " Diagnostics on Project",
				title_pos = "center",
				focus = true,
				auto_preview = true,
				keys = {
					["<cr>"] = "jump_close",
					["q"] = "close",
				},
				win = {
					type = "float",
					border = "rounded",
					relative = "editor",
					size = {
						width = 0.345,
						height = 0.5,
					},
					position = {
						0.5,
						0.2,
					},
					zindx = 200,
				},
				preview = {
					type = "float",
					border = "rounded",
					relative = "editor",
					scratch = false,
					size = {
						width = 0.4,
						height = 0.5,
					},
					position = {
						0.5,
						0.8,
					},
					zindex = 199,
				},
			},
		},
	},
}
