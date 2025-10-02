return {
	"stevearc/aerial.nvim",
	enabled = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	keys = {
		{ mode = { "n" }, "go", "<cmd>AerialToggle float<CR>", desc = "LSP Outline" },
	},
	config = function()
		require("aerial").setup({
			backends = { "treesitter", "lsp", "markdown" },
			layout = {
				max_width = { 100, 0.5 },
				-- width = nil,
				min_width = 50,
				resize_to_content = true,
			},
			highlight_on_hover = true,
			-- attach_mode = "window",
			autojump = true,
			show_guides = true,
			float = {
				border = "rounded",
				relative = "editor",
				-- max_height = 0.9,
				-- height = 0.5,
				-- min_height = { 8, 0.3 },
			},
			keymaps = {
				["go"] = "actions.close",
			},
			nerd_font = "mini.icons",
			filter_kind = {
				"Array",
				"Boolean",
				"Class",
				"Constant",
				"Constructor",
				"Enum",
				"EnumMember",
				"Event",
				"Field",
				"File",
				"Function",
				"Interface",
				"Key",
				"Method",
				"Module",
				"Namespace",
				"Null",
				"Number",
				"Object",
				"Operator",
				"Package",
				"Property",
				"String",
				"Struct",
				"TypeParameter",
				"Variable",
			},
			icons = {
				Array = "󰅪 Array",
				Boolean = "󰨙 Bool",
				Class = "󰆧 Class",
				Constant = "󰏿 Constant",
				Constructor = " Constructor",
				Enum = " Enum ",
				EnumMember = " EnumMember",
				Event = " Event ",
				Field = " Field",
				File = "󰈙 File",
				Function = "󰊕 Fn",
				Interface = " Interface",
				Key = "󰌋 Key",
				Method = "󰊕 Method",
				Module = " Module",
				Namespace = "󰦮 Namespace",
				Null = "󰟢 Null",
				Number = "󰎠 Number",
				Object = " Object",
				Operator = "󰆕 Operator",
				Package = " Package",
				Property = " Property",
				String = " String",
				Struct = "󰆼 Struct",
				TypeParameter = "󰗴 TypeParam",
				Variable = "󰀫 Variable",
				Collapsed = " ",
				-- Rustのシンボル表示をカスタマイズ
				rust = {
					Class = "impl", -- implブロックを示すラベルを"impl"に
					Struct = "struct", -- 構造体を示すラベルを"struct"に
					Function = "fn", -- 関数（トップレベル）を"fn"に
                    Module = "mod",
					Method = "fn", -- メソッド（impl内）も"fn"に
					Interface = "trait", -- トレイトを示すラベルを"trait"に（必要に応じて）
				},
				-- TypeScriptのシンボル表示をカスタマイズ
				typescript = {
					Class = "class", -- クラスを"class"に
					Function = "function", -- 関数を"function"に
					Method = "function", -- メソッドも"function"に
					Interface = "interface", -- インタフェースを"interface"に
					-- 他にEnumやVariable等必要なら指定可能
				},
				-- Pythonのシンボル表示をカスタマイズ
				python = {
					Class = "class", -- クラスを"class"に
					Function = "def", -- 関数（およびメソッド）を"def"に
					Method = "def",
				},
			},
		})
	end,
}
