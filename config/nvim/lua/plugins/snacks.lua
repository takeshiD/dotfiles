--=======================================================
-- jev (TypeSafe) 連携
--   curl で https://api.typesafe.ai/v1/systemone を叩き、
--   自然言語の問いで候補を確率順に並べ替える。
--   認証は環境変数 TYPESAFE_API_KEY を使う。
--
--   使い方
--     <leader>jf  行検索(一覧): 打った文に合う行が確率順に一覧に並ぶ。Enter で移動。
--                 <a-j> で普通の曖昧一致に切り替え。
--     <leader>j/  行検索(逐次): / のように打つと、該当行がバッファ上で光り、
--                 先頭候補へ画面が追従する。<c-n>/<c-p> で候補を巡回、Enter で確定、
--                 <esc> で元の位置へ戻る。確定後は ]j / [j で巡回できる。
--     <leader>?   命令板: 「さっき触ったファイル」などと打つと該当する
--                 キー割り当て・picker が確率順に並ぶ。Enter で実行。
--=======================================================
local jev = {
	endpoint = "https://api.typesafe.ai/v1/systemone",
	model = "jev-latest",
	max_options = 255, -- choice の選択肢上限（API の仕様）
	max_requests = 8, -- 一度に投げる要求数の上限（255 件 × 8）
	min_prob = 0.01, -- 一覧に残す確率の下限（命令板などの既定）
	min_keep = 10, -- 下限未満でも残す上位件数（同上）
	-- 行検索（一覧・逐次）の閾値。70% 以下は含めない。min_keep を 0 にすると下限未満は一切残さない。
	-- jev.lines({ min_prob = 0.5 }) のように呼び出し時にも上書きできる
	line_search = { min_prob = 0.5, min_keep = 0 },
	max_marks = 20, -- 逐次検索でバッファ上に印を付ける最大件数
	debounce = 100, -- 入力が止まってから送るまでの待ち（ミリ秒）
	timeout = 60, -- 秒
}

-----------------------------------------------------------
-- API 呼び出し
-----------------------------------------------------------

---@param body table 送信する JSON 本体
---@param cb fun(res: table?, err: string?)
function jev.request(body, cb)
	local key = os.getenv("TYPESAFE_API_KEY") -- picker の finder は fast event 内で動くため vim.env は使えない
	if not key or key == "" then
		return cb(nil, "環境変数 TYPESAFE_API_KEY が設定されていません")
	end
	body.model = body.model or jev.model
	vim.system({
		"curl",
		"-sS",
		"--max-time",
		tostring(jev.timeout),
		"-X",
		"POST",
		jev.endpoint,
		"-H",
		"Authorization: Bearer " .. key,
		"-H",
		"Content-Type: application/json",
		"-d",
		"@-",
	}, { stdin = vim.json.encode(body), text = true }, function(out)
		vim.schedule(function()
			if out.code ~= 0 then
				return cb(
					nil,
					("curl が失敗しました (終了コード %d)\n%s"):format(out.code, out.stderr or "")
				)
			end
			local ok, res = pcall(vim.json.decode, out.stdout)
			if not ok or type(res) ~= "table" then
				return cb(nil, "応答を JSON として読めませんでした\n" .. tostring(out.stdout))
			end
			if not res.answers then
				return cb(nil, "API がエラーを返しました\n" .. tostring(out.stdout))
			end
			cb(res)
		end)
	end)
end

--- 複数の要求を同時に投げ、全部そろったら cb を呼ぶ
---@param bodies table[]
---@param cb fun(results: (table|nil)[])
function jev.request_all(bodies, cb)
	local results, pending = {}, #bodies
	if pending == 0 then
		return cb(results)
	end
	for i, body in ipairs(bodies) do
		jev.request(body, function(res, err)
			results[i] = res
			if err then
				Snacks.notify.error(err, { title = "jev" })
			end
			pending = pending - 1
			if pending == 0 then
				cb(results)
			end
		end)
	end
end

-----------------------------------------------------------
-- 採点: 候補を 255 件ずつに分けて choice で問い、item.prob に確率を書き込む
--   確率は塊ごとの分布なので、塊をまたいだ比較は目安になる
-----------------------------------------------------------

---@alias jev.Build fun(chunk: table[], ids: string[]): { state: any, question: table }

---@param items table[]
---@param build jev.Build
---@param cb fun(items: table[]) 採点済みの items（同じテーブル）
function jev.score(items, build, cb)
	local chunks = {}
	for i = 1, #items, jev.max_options do
		chunks[#chunks + 1] = vim.list_slice(items, i, i + jev.max_options - 1)
	end
	if #chunks > jev.max_requests then
		Snacks.notify.warn(
			("候補が多いため先頭 %d 件のみ jev に送ります"):format(jev.max_options * jev.max_requests),
			{ title = "jev" }
		)
		chunks = vim.list_slice(chunks, 1, jev.max_requests)
	end
	local bodies, id_lists = {}, {}
	for ci, chunk in ipairs(chunks) do
		local ids = {}
		for j = 1, #chunk do
			ids[j] = ("c%03d"):format(j)
		end
		local b = build(chunk, ids)
		bodies[ci] = { state = b.state, questions = { q = b.question } }
		id_lists[ci] = ids
	end
	jev.request_all(bodies, function(results)
		for _, item in ipairs(items) do
			item.prob = nil
		end
		for ci, res in pairs(results) do
			local probs = res.answers.q and res.answers.q.probabilities or {}
			for j, item in ipairs(chunks[ci]) do
				item.prob = probs[id_lists[ci][j]] or 0
			end
		end
		cb(items)
	end)
end

--- picker の finder（コルーチン）の中で jev.score の完了を待つ版
---@async
---@param items table[]
---@param build jev.Build
function jev.score_async(items, build)
	local async =
		assert(require("snacks.picker.util.async").running(), "非同期の finder の中でのみ使えます")
	local done = false
	jev.score(items, build, function()
		done = true
		async:resume()
	end)
	while not done do
		async:suspend()
	end
	return items
end

---@class jev.RankOpts
---@field min_prob? number この値以下の確率は落とす（既定 jev.min_prob）
---@field min_keep? number 下限未満でも残す上位件数（既定 jev.min_keep）

--- 候補を確率順に返す。min_prob 以下は落とすが、上位 min_keep 件は残す
---@param items table[]
---@param opts? jev.RankOpts
function jev.ranked(items, opts)
	opts = opts or {}
	local min_prob = opts.min_prob or jev.min_prob
	local min_keep = opts.min_keep or jev.min_keep
	local ret = vim.list_slice(items)
	table.sort(ret, function(a, b)
		return (a.prob or 0) > (b.prob or 0)
	end)
	for i = #ret, min_keep + 1, -1 do
		if (ret[i].prob or 0) <= min_prob then
			ret[i] = nil
		end
	end
	return ret
end

--- 行検索用の閾値: 呼び出し時の指定 > jev.line_search の設定 > 全体の既定
---@param opts? jev.RankOpts
---@return jev.RankOpts
function jev.lines_rank_opts(opts)
	return vim.tbl_extend("keep", opts or {}, jev.line_search or {})
end

---@param prob number
local function pct(prob)
	return ("%5.1f%%"):format(prob * 100)
end

-----------------------------------------------------------
-- 行検索の共通部: バッファの行を「問いに合う行はどれか」で採点する
-----------------------------------------------------------

--- バッファの空行以外を候補にする
---@param buf integer
---@return { lnum: integer, text: string }[]
function jev.buffer_candidates(buf)
	local ret = {}
	for l, text in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		if text:match("%S") then
			ret[#ret + 1] = { lnum = l, text = text }
		end
	end
	return ret
end

--- 行候補用の問いを組み立てる。行に番号を振った文書を state にし、番号を選択肢にする
---@param query string
---@return jev.Build
function jev.build_lines(query)
	return function(chunk, ids)
		local doc, criteria = {}, {}
		for j, item in ipairs(chunk) do
			doc[j] = ids[j] .. "| " .. item.text
			criteria[ids[j]] = vim.NIL
		end
		return {
			state = table.concat(doc, "\n"),
			question = {
				type = "choice",
				instructions = ('Which line of the document best matches or answers: "%s"?'):format(query),
				criteria = criteria,
			},
		}
	end
end

--- 自然言語の問いでバッファの行を探し、確率順の一覧を cb に渡す
---@param buf integer
---@param query string
---@param cb fun(matches: { lnum: integer, text: string, prob: number }[])
---@param opts? jev.RankOpts
function jev.search_lines(buf, query, cb, opts)
	jev.score(jev.buffer_candidates(buf), jev.build_lines(query), function(items)
		cb(jev.ranked(items, jev.lines_rank_opts(opts)))
	end)
end

-----------------------------------------------------------
-- picker 共通: 検索欄の文を jev に送る型
-----------------------------------------------------------

--- 曖昧一致 ⇔ jev を切り替える picker 内の動作。入力中の文は引き継ぐ
---@param picker snacks.Picker
local function toggle_jev(picker)
	local text = picker.input:get()
	picker.opts.live = not picker.opts.live
	if picker.opts.live then
		picker.input:set("", text)
	else
		picker.input:set(text, "")
	end
	picker:find({ refresh = true })
end

--- 「検索欄の文で jev に並べ替えさせる」picker の共通設定
---@param opts snacks.picker.Config
local function jev_picker_opts(opts)
	return vim.tbl_deep_extend("force", {
		supports_live = true,
		matcher = { sort_empty = false }, -- 未入力時は finder が流した順（jev なら確率順）を保つ
		toggles = { live = "jev" },
		icons = { ui = { live = "" } },
		actions = { toggle_jev = toggle_jev },
		win = {
			input = { keys = { ["<a-j>"] = { "toggle_jev", mode = { "n", "i" }, desc = "曖昧一致 ⇔ jev" } } },
		},
	}, opts)
end

--- 確率を先頭に付けて元の書式で描く
---@param format snacks.picker.format
local function with_prob(format)
	return function(item, picker)
		local ret = format(item, picker)
		if item.prob then
			table.insert(ret, 1, { " " })
			table.insert(ret, 1, { pct(item.prob), item.prob >= 0.5 and "DiagnosticOk" or "Number" })
		end
		return ret
	end
end

--- lines 書式の行番号を実際の行番号にし、確率を前置した版
---@param item snacks.picker.Item
local function format_line(item)
	local ret = {} ---@type snacks.picker.Highlight[]
	local prefix = ""
	if item.prob then
		prefix = pct(item.prob) .. " "
		ret[#ret + 1] = { pct(item.prob), item.prob >= 0.5 and "DiagnosticOk" or "Number" }
		ret[#ret + 1] = { " " }
	end
	local width = #tostring(vim.api.nvim_buf_line_count(item.buf))
	local lnum = Snacks.picker.util.align(tostring(item.pos[1]), width, { align = "right" })
	ret[#ret + 1] = { lnum, "LineNr" }
	ret[#ret + 1] = { "  " }
	ret[#ret + 1] = { item.text }
	local offset = #prefix + #lnum + 2
	for _, extmark in ipairs(item.highlights or {}) do
		extmark = vim.deepcopy(extmark)
		if type(extmark[1]) ~= "string" then
			extmark.col = extmark.col + offset
			if extmark.end_col then
				extmark.end_col = extmark.end_col + offset
			end
		end
		ret[#ret + 1] = extmark
	end
	return ret
end

-----------------------------------------------------------
-- 1. 行検索(一覧): 自然言語の問いに合う行を確率順に一覧へ
-----------------------------------------------------------
---@param opts? jev.RankOpts
function jev.lines(opts)
	local rank_opts = jev.lines_rank_opts(opts)
	Snacks.picker.pick(
		"lines",
		jev_picker_opts({
			title = "行検索",
			live = true,
			finder = function(opts, ctx)
				local items = require("snacks.picker.source.lines").lines(opts, ctx)
				local search = ctx.filter.search
				if not ctx.picker.opts.live or search == "" then
					return items
				end
				---@async
				return function(cb)
					require("snacks.picker.util.async").sleep(jev.debounce)
					local candidates = vim.tbl_filter(function(item)
						return item.text:match("%S") ~= nil
					end, items)
					jev.score_async(candidates, jev.build_lines(search))
					for _, item in ipairs(jev.ranked(candidates, rank_opts)) do
						cb(item)
					end
				end
			end,
			format = format_line,
		})
	)
end

-----------------------------------------------------------
-- 2. 行検索(逐次): / のように打ちながら、該当行をバッファ上に示す
-----------------------------------------------------------
local incsearch_ns = vim.api.nvim_create_namespace("jev_incsearch")
vim.api.nvim_set_hl(0, "JevMatch", { link = "Search", default = true })
vim.api.nvim_set_hl(0, "JevMatchCurrent", { link = "CurSearch", default = true })
vim.api.nvim_set_hl(0, "JevMatchProb", { link = "Number", default = true })

--- バッファ上の印・巡回キー・自動命令を片付ける
---@param buf integer
function jev.clear_marks(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf, incsearch_ns, 0, -1)
	pcall(vim.api.nvim_clear_autocmds, { group = "jev_incsearch_" .. buf })
	for _, lhs in ipairs({ "]j", "[j" }) do
		pcall(vim.keymap.del, "n", lhs, { buffer = buf })
	end
end

---@param opts? jev.RankOpts
function jev.incsearch(opts)
	local buf, win = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
	local view = vim.fn.winsaveview()
	local matches, index, seq = {}, 0, 0 ---@type { lnum: integer, prob: number }[], integer, integer
	jev.clear_marks(buf)

	-- 上位候補に印を付け、現在の候補だけ色を変える
	local function render()
		vim.api.nvim_buf_clear_namespace(buf, incsearch_ns, 0, -1)
		for i, m in ipairs(matches) do
			if i > jev.max_marks then
				break
			end
			vim.api.nvim_buf_set_extmark(buf, incsearch_ns, m.lnum - 1, 0, {
				line_hl_group = i == index and "JevMatchCurrent" or "JevMatch",
				virt_text = { { " " .. pct(m.prob), "JevMatchProb" } },
				virt_text_pos = "eol",
				priority = i == index and 200 or 100,
			})
		end
	end

	-- i 番目の候補へ画面を寄せる（入力窓は開いたまま）
	local function focus(i)
		if #matches == 0 then
			index = 0
			return render()
		end
		index = ((i - 1) % #matches) + 1
		local m = matches[index]
		if vim.api.nvim_win_is_valid(win) then
			local col = (vim.api.nvim_buf_get_lines(buf, m.lnum - 1, m.lnum, false)[1] or ""):find("%S") or 1
			vim.api.nvim_win_set_cursor(win, { m.lnum, col - 1 })
			vim.api.nvim_win_call(win, function()
				vim.cmd("normal! zz")
			end)
		end
		render()
	end

	local function restore()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_call(win, function()
				vim.fn.winrestview(view)
			end)
		end
	end

	-- 入力が止まってから送る。古い応答は捨てる
	local function on_change(text)
		seq = seq + 1
		local my = seq
		if vim.trim(text) == "" then
			matches = {}
			focus(0)
			return restore()
		end
		vim.defer_fn(function()
			if my ~= seq then
				return
			end
			jev.search_lines(buf, vim.trim(text), function(found)
				if my ~= seq then
					return
				end
				matches = found
				if #matches == 0 then
					focus(0) -- 閾値を超える行がなければ印を消して元の表示に戻す
					return restore()
				end
				focus(1)
			end, opts)
		end, jev.debounce)
	end

	local input = Snacks.input({
		prompt = "jev /",
		win = {
			keys = {
				jev_next = {
					"<c-n>",
					function()
						focus(index + 1)
					end,
					mode = { "i", "n" },
					desc = "next",
				},
				jev_prev = {
					"<c-p>",
					function()
						focus(index - 1)
					end,
					mode = { "i", "n" },
					desc = "prev",
				},
			},
		},
	}, function(value)
		seq = seq + 1 -- 飛んでいる要求は無効にする
		if value == nil or #matches == 0 then
			jev.clear_marks(buf)
			return restore()
		end
		-- 確定: 元の位置を jumplist に積んでから候補へ
		local target = matches[index]
		restore()
		vim.cmd("normal! m'")
		focus(index)
		-- 確定後も印を残し、]j / [j で巡回できるようにする。編集や離脱で片付ける
		local group = vim.api.nvim_create_augroup("jev_incsearch_" .. buf, { clear = true })
		vim.api.nvim_create_autocmd({ "TextChanged", "InsertEnter", "BufLeave" }, {
			group = group,
			buffer = buf,
			once = true,
			callback = function()
				jev.clear_marks(buf)
			end,
		})
		vim.keymap.set("n", "]j", function()
			focus(index + 1)
		end, { buffer = buf, desc = "jev semantic search next candidate" })
		vim.keymap.set("n", "[j", function()
			focus(index - 1)
		end, { buffer = buf, desc = "jev semantic search previous candidate" })
		Snacks.notify.info(
			("%d 行目 (%s) — 候補 %d 件、]j / [j で巡回"):format(
				target.lnum,
				vim.trim(pct(target.prob)),
				#matches
			),
			{ title = "jev" }
		)
	end)

	input:on({ "TextChangedI", "TextChanged" }, function()
		if input:valid() then
			on_change(input:text())
		end
	end, { buf = true })
end

-----------------------------------------------------------
-- 3. 命令板: 打った文に合う「キー割り当て」「picker」を jev が選ぶ
-----------------------------------------------------------
---@param buf integer 元のバッファ（局所の割り当てを拾う）
local function palette_items(buf)
	local items, seen = {}, {}
	local maps = vim.api.nvim_buf_get_keymap(buf, "n")
	vim.list_extend(maps, vim.api.nvim_get_keymap("n"))
	for _, m in ipairs(maps) do
		local desc = m.desc and vim.trim(m.desc) or ""
		local lhs = m.lhs:gsub(vim.pesc(vim.g.mapleader or "\\"), "<leader>")
		if desc ~= "" and not desc:find("^which%-key") and not m.lhs:find("<Plug>") and not seen[lhs] then
			seen[lhs] = true
			items[#items + 1] = {
				kind = "key",
				lhs = m.lhs,
				label = desc,
				hint = lhs,
				text = desc .. " " .. lhs,
			}
		end
	end
	local sources = vim.tbl_keys(Snacks.picker.config.get().sources or {})
	table.sort(sources)
	for _, name in ipairs(sources) do
		items[#items + 1] = {
			kind = "picker",
			name = name,
			label = name:gsub("_", " "),
			hint = "picker",
			text = name .. " picker",
		}
	end
	return items
end

function jev.palette()
	Snacks.picker.pick(jev_picker_opts({
		title = "Ah yes!",
		live = true,
		layout = { preset = "vscode" },
		finder = function(_, ctx)
			local items = palette_items(ctx.filter.current_buf)
			local search = ctx.filter.search
			if not ctx.picker.opts.live or search == "" then
				return items
			end
			-- 非同期関数の中は fast event なので、バッファ情報はここで取っておく
			local context = {
				filetype = vim.bo[ctx.filter.current_buf].filetype,
				file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ctx.filter.current_buf), ":t"),
			}
			---@async
			return function(cb)
				require("snacks.picker.util.async").sleep(jev.debounce)
				jev.score_async(items, function(chunk, ids)
					local criteria = {}
					for j, item in ipairs(chunk) do
						criteria[ids[j]] = item.kind == "key" and item.label
							or ("open the snacks picker: " .. item.name)
					end
					return {
						state = { request = search, filetype = context.filetype, file = context.file },
						question = {
							type = "choice",
							instructions = "Which editor command best fulfils the user's request in `request`?",
							criteria = criteria,
						},
					}
				end)
				for _, item in ipairs(jev.ranked(items)) do
					cb(item)
				end
			end
		end,
		format = with_prob(function(item)
			return {
				{ item.label },
				{ "  " },
				{ item.hint, "SnacksPickerComment" },
			}
		end),
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			vim.schedule(function()
				if item.kind == "key" then
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(item.lhs, true, false, true), "m", false)
				else
					Snacks.picker.pick(item.name)
				end
			end)
		end,
	}))
end

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
		{
			"<leader>?",
			function()
				jev.palette()
			end,
			desc = "Ah yes",
		},
		{
			"<leader>jf",
			function()
				jev.lines()
			end,
			desc = "jev: 行検索(一覧)",
		},
		{
			"<leader>j/",
			function()
				jev.incsearch()
			end,
			desc = "jev: 行検索(逐次)",
		},
	},
}
