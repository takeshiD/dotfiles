
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
		require("telescope").load_extension("aerial")

		-- ───────────────────────────────────────────────────────────────
		-- 問題2: 折りたたみ時に種別アイコンを保つ(+ 折りたたみマーカー)
		-- ───────────────────────────────────────────────────────────────
		-- "" にすると折りたたみマーカーを消して種別アイコンだけにできる(桁ズレなし)
		local collapse_marker = "▸ "

		-- kind -> icon のマップに <Kind>Collapsed を生成して足す。
		-- 既存の "アイコン + ラベル" 形式(例: "󰅪 Array")をそのまま流用するので
		-- 展開時とアイコン/ラベルが揃う。言語別サブテーブルにも同じ処理を当てる。
		local function add_collapsed(tbl)
			for kind, icon in pairs(tbl) do
				if type(icon) == "string" and not kind:match("Collapsed$") then
					tbl[kind .. "Collapsed"] = collapse_marker .. icon
				end
			end
		end

		local icons = {
			Array = "󰅪 Array",
			Boolean = "󰨙 Bool",
			Class = "󰆧 Class",
			Constant = "󰏿 Constant",
			Constructor = " Constructor",
			Enum = " Enum ",
			EnumMember = " EnumMember",
			Event = " Event ",
			Field = " Field",
			File = "󰈙 File",
			Function = "󰊕 Fn",
			Interface = " Interface",
			Key = "󰌋 Key",
			Method = "󰊕 Method",
			Module = " Module",
			Namespace = "󰦮 Namespace",
			Null = "󰟢 Null",
			Number = "󰎠 Number",
			Object = " Object",
			Operator = "󰆕 Operator",
			Package = " Package",
			Property = " Property",
			String = " String",
			Struct = "󰆼 Struct",
			TypeParameter = "󰗴 TypeParam",
			Variable = "󰀫 Variable",
			-- <Kind>Collapsed が未定義のときの汎用フォールバック
			Collapsed = " ",
			-- Function/Method は post_parse_symbol で名前側に "[vis ]fn " を前置する。
			-- アイコン文字は空にして "{kw} fn name" の順序にし、行頭の "{kw} fn" だけを
			-- 末尾の decoration provider で着色する(名前は素の色)。
			rust = {
				Class = "impl",
				Struct = "struct",
				Enum = "enum",
				Function = "",
				Module = "mod",
				Method = "",
				Interface = "trait",
			},
			cpp = {
				Function = "",
				Method = "",
			},
			typescript = {
				Class = "class",
				Function = "",
				Method = "",
				Interface = "interface",
			},
			-- tsx ファイルの filetype は typescriptreact
			typescriptreact = {
				Class = "class",
				Function = "",
				Method = "",
				Interface = "interface",
			},
			python = {
				Class = "class",
				Function = "def",
				Method = "def",
			},
			markdown = {
				Interface = "Header",
			},
			yaml = {
				Class = " ",
				Enum = " ",
			},
		}

		-- 基底 + 言語別サブテーブルそれぞれに <Kind>Collapsed を生成
		add_collapsed(icons)
		for _, sub in pairs(icons) do
			if type(sub) == "table" then
				add_collapsed(sub)
			end
		end

		-- ───────────────────────────────────────────────────────────────
		-- 問題1: 言語ごとに public/private/protected を判定して scope に入れる
		-- ───────────────────────────────────────────────────────────────
		local get_text = vim.treesitter.get_node_text

		local function rust_scope(node, bufnr)
			local t = node:type()
			if t == "impl_item" or t == "function_signature_item" then
				return nil -- impl ブロック / trait のメソッド宣言は固有の可視性を持たない
			end
			for child in node:iter_children() do
				if child:type() == "visibility_modifier" then
					local txt = get_text(child, bufnr)
					if txt == "pub" then
						return "public"
					end
					return "protected" -- pub(crate) / pub(super) / pub(in ...)
				end
			end
			return "private"
		end

		local function cpp_scope(node, bufnr)
			local cur = node
			while cur do
				local parent = cur:parent()
				if not parent then
					return nil
				end
				if parent:type() == "field_declaration_list" then
					local gp = parent:parent()
					local scope = (gp and gp:type() == "struct_specifier") and "public" or "private"
					local _, _, target = cur:start()
					for child in parent:iter_children() do
						local _, _, b = child:start()
						if b == target then
							break
						end
						if child:type() == "access_specifier" then
							scope = get_text(child, bufnr):match("%a+") or scope
						end
					end
					return scope
				end
				cur = parent
			end
			return nil -- フリー関数 / 名前空間直下: マーカーなし
		end

		local function ts_scope(node, bufnr)
			local t = node:type()
			if t == "method_definition" or t == "public_field_definition" then
				local name = node:field("name")[1]
				if name and name:type() == "private_property_identifier" then
					return "private" -- #private フィールド/メソッド
				end
				for child in node:iter_children() do
					if child:type() == "accessibility_modifier" then
						return get_text(child, bufnr) -- public / private / protected
					end
				end
				return "public" -- TS のメンバはデフォルト public
			end
			-- トップレベル宣言: export されていれば public、なければ module-private
			local n = node
			for _ = 1, 3 do
				local p = n:parent()
				if not p then
					break
				end
				local pt = p:type()
				if pt == "export_statement" then
					return "public"
				end
				if pt == "program" or pt == "statement_block" or pt == "class_body" then
					break
				end
				n = p
			end
			return "private"
		end

		local scope_by_lang = {
			rust = rust_scope,
			cpp = cpp_scope,
			typescript = ts_scope,
			tsx = ts_scope,
		}

		-- 関数/メソッドが public(=export/pub/public) のとき名前に前置する言語別キーワード
		local pub_keyword = {
			rust = "pub",
			cpp = "public",
			typescript = "export",
			tsx = "export",
		}

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
			icons = icons,

			post_parse_symbol = function(bufnr, item, ctx)
				if ctx.backend_name ~= "treesitter" or not ctx.match then
					return true
				end
				local fn = scope_by_lang[ctx.lang]
				if not fn then
					return true
				end
				local node = (ctx.match.symbol or ctx.match.type or {}).node
				if node then
					local ok, scope = pcall(fn, node, bufnr)
					if ok and scope then
						item.scope = scope
					end
				end
				-- 関数/メソッドの行頭に "[vis ]fn " を付与(言語別)。
				-- アイコンは空にしてあるので "pub fn name" の順序で表示される。
				-- public のときだけ pub/export/public を付け、それ以外は "fn name"。
				local kw = pub_keyword[ctx.lang]
				if kw and (item.kind == "Function" or item.kind == "Method") then
					local prefix = (item.scope == "public") and (kw .. " ") or ""
					item.name = prefix .. "fn " .. item.name
				end
				return true
			end,

			-- 可視性で着色する。public/export = Special、protected = 黄、private = DiagnosticInfo。
			-- 関数/メソッドは行頭の "{kw} fn" だけを末尾の decoration provider で着色し、
			-- 関数名は素の色のままにする(ここでは常に通常色 = Aerial<Kind> を返す)。
			-- それ以外の kind はアイコン側を scope で着色する。
			-- 名前側で nil を返すと aerial 内蔵が AerialProtected/AerialPrivate を
			-- 名前に当ててしまう(highlight.lua:57)ので、通常色にしたい場合は
			-- Aerial<Kind> を明示的に返して内蔵着色を抑止する。
			get_highlight = function(symbol, is_icon)
				local s = symbol.scope
				local is_fn = symbol.kind == "Function" or symbol.kind == "Method"
				if is_fn then
					if is_icon then
						return -- アイコンは空。"{kw} fn" は decoration provider で着色
					end
					return "Aerial" .. symbol.kind -- 名前は常に通常色
				end
				if is_icon then
					if s == "public" then
						return "AerialPublicIcon"
					elseif s == "protected" then
						return "AerialProtectedIcon"
					elseif s == "private" then
						return "AerialPrivateIcon"
					end
					return
				end
				if s == "private" or s == "protected" then
					return "Aerial" .. symbol.kind -- 名前は通常色に(内蔵着色を抑止)
				end
			end,
		})
		-- ───────────────────────────────────────────────────────────────
		-- 可視性の色(カラースキーム変更時に再適用 / aerial デフォルトの後勝ち)
		-- ───────────────────────────────────────────────────────────────
		local function set_aerial_vis_hl()
			local hl = vim.api.nvim_set_hl
			-- public/export = Special、protected = 黄、private = DiagnosticInfo。
			-- Icon 系は非関数 kind のアイコン用、無印は関数/メソッドの名前用。
			hl(0, "AerialPublic", { link = "Special" })
			hl(0, "AerialProtected", { link = "DiagnosticWarn" })
			hl(0, "AerialPrivate", { link = "DiagnosticInfo" })
			hl(0, "AerialPublicIcon", { link = "Special" })
			hl(0, "AerialProtectedIcon", { link = "DiagnosticWarn" })
			hl(0, "AerialPrivateIcon", { link = "DiagnosticInfo" })
		end
		set_aerial_vis_hl()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_aerial_vis_hl })

		-- ───────────────────────────────────────────────────────────────
		-- 関数行の先頭 "{kw} fn"(export/pub/public) だけを着色する。
		-- aerial は icon|name の2ブロックしか色分けできないため、aerial 行の
		-- 名前側に前置した "export fn" 等のキーワード部分のみを decoration provider で
		-- 高優先度に上書き着色する(関数名は素の色のまま)。public のときだけ "{kw} fn"
		-- が付くので、非 export の "fn name" は何も着色されない。
		local kw_ns = vim.api.nvim_create_namespace("aerial_vis_keyword")
		local keywords = { "export", "pub", "public" } -- public 系のキーワード
		vim.api.nvim_set_decoration_provider(kw_ns, {
			on_win = function(_, _, bufnr)
				return vim.bo[bufnr].filetype == "aerial"
			end,
			on_line = function(_, _, bufnr, row)
				local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
				if not line then
					return
				end
				for _, kw in ipairs(keywords) do
					-- "{kw} fn " を前方の空白/折りたたみマーカーの後に探す
					local sidx = line:find(kw .. " fn ", 1, true)
					if sidx then
						vim.api.nvim_buf_set_extmark(bufnr, kw_ns, row, sidx - 1, {
							end_col = sidx - 1 + #kw + 3, -- "{kw} fn" まで(末尾の空白は含めない)
							hl_group = "AerialPublic",
							hl_mode = "combine",
							priority = 20000,
							ephemeral = true,
						})
						return
					end
				end
			end,
		})
	end,
}
