return {
	"folke/snacks.nvim",
	enabled = true,
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		-- bigfile = { enabled = false },
		dashboard = {
			enabled = true,
			sections = {
				-- { section = "header" },
				{
					section = "terminal",
					cmd = "figlet -f basic 'UNSAFE'",
					hl = "header",
					height = 8,
					padding = 1,
					indent = 3,
				},
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{ section = "startup" },
			},
			preset = {
				header = [[
        \
         \
            _~^~^~_
        \) /  o o  \ (/
          '_   -   _'
          / '-----' \
                ]],
			},
		},
		indent = {
			enabled = true,
			animate = {
				enabled = false,
			},
		},
		picker = {
			enabled = true,
			ui_select = true,
			matcher = {
				fuzzy = true, -- use fuzzy matching
				smartcase = true, -- use smartcase
				ignorecase = true, -- use ignorecase
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- support patterns like `file:line:col` and `file:line`
				-- the bonusses below, possibly require string concatenation and path normalization,
				-- so this can have a performance impact for large lists and increase memory usage
				cwd_bonus = true, -- give bonus for matching files in the cwd
				frecency = false, -- frecency bonus
				history_bonus = false, -- give more weight to chronological order
			},
		},
		-- alternate toggleterm
		-- ここに置いた設定は lazygit など snacks が開く全ての端末に効くので、
		-- jk のような文字の割り当てはシェル端末側(<C-t> の呼び出し)にだけ付ける
		terminal = {
			win = {
				position = "float",
				border = "single",
			},
		},
		-- lazygit では <Esc> を多用するので、snacks 端末既定の「<Esc> 2回で通常モード」を無効化する
		lazygit = {
			win = {
				keys = {
					term_normal = false,
				},
			},
		},
		input = { enabled = true },
		image = { enabled = true },
		explorer = { enabled = false },
		bigfile = { enabled = true },
	},
	keys = {
		{
			"<leader><leader>",
			function()
				require("snacks").picker.smart({
					cwd = require("snacks").git.get_root() or vim.fn.getcwd(),
					hidden = true,
					ignored = true,
				})
			end,
			desc = "SmartFinder",
		},
		{
			"<leader>fr",
			function()
				require("snacks").picker.grep({
					cwd = require("snacks").git.get_root() or vim.fn.getcwd(),
					hidden = true,
					ignored = true,
				})
			end,
			desc = "RipGrep",
		},
		{
			"<leader>fj",
			function()
				require("snacks").picker.jumps()
			end,
			desc = "Jumplist",
		},
		{
			"<leader>fb",
			function()
				require("snacks").picker.buffers()
			end,
			desc = "BufferList",
		},
		{
			"<C-t>",
			function()
				require("snacks").terminal.toggle(nil, {
					win = {
						keys = {
							term_normal_jk = {
								"jk",
								function()
									vim.cmd.stopinsert()
								end,
								mode = "t",
								desc = "Escape term mode",
							},
						},
					},
				})
			end,
			mode = { "n", "i", "t" },
			desc = "Terminal Toggle",
		},
		{
			"<leader>gg",
			function()
				require("snacks").lazygit()
			end,
			mode = { "n" },
			desc = "LazyGit",
		},
	},
}
