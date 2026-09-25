local list_win, output_win

-- overseer は浮動ウィンドウに居る間はタスクの端末バッファ生成を保留し、通常ウィンドウへ
-- 移った時(WinEnter)に作る。浮動パネルを出したまま OverseerRun すると出力が空のままに
-- なるため、未生成の端末があれば一瞬だけ通常ウィンドウへ移って生成させる
local function flush_pending_terminals()
	if not (list_win and vim.api.nvim_win_is_valid(list_win)) then
		return
	end
	if vim.api.nvim_get_current_win() ~= list_win then
		return
	end
	-- 端末化されるとbuftypeが"terminal"になる。端末を使わない戦略のバッファは
	-- modifiable=falseで作られるので、それも除外する
	local pending = false
	for _, task in ipairs(require("overseer").list_tasks({})) do
		local buf = task:get_bufnr()
		if buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "nofile" and vim.bo[buf].modifiable then
			pending = true
			break
		end
	end
	if not pending then
		return
	end
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			vim.api.nvim_set_current_win(win)
			vim.api.nvim_set_current_win(list_win)
			return
		end
	end
end

local function close_float()
	for _, win in ipairs({ list_win, output_win }) do
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	list_win, output_win = nil, nil
end

-- 浮動ウィンドウを縦分割し、左にタスク一覧、右にカーソル下のタスク出力を表示する
local function taskpanel_float()
	local overseer = require("overseer")
	local TaskView = require("overseer.task_view")

	if list_win and vim.api.nvim_win_is_valid(list_win) then
		close_float()
		return
	end

	-- 分割ウィンドウで既に開いていれば閉じてから浮動ウィンドウに載せ替える
	overseer.close()

	local total_width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.7)
	local col = math.floor((vim.o.columns - total_width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)
	local list_width = math.floor(total_width * 0.35)
	local output_width = total_width - list_width - 4 -- 枠線 2 本分(左右各 2 桁)を除く

	local function open_float(width, col_offset, title)
		local buf = vim.api.nvim_create_buf(false, true)
		vim.bo[buf].bufhidden = "wipe"
		return vim.api.nvim_open_win(buf, false, {
			relative = "editor",
			width = width,
			height = height,
			col = col + col_offset,
			row = row,
			style = "minimal",
			border = "rounded",
			title = title,
			title_pos = "center",
		})
	end

	output_win = open_float(output_width, list_width + 2, " Output ")
	list_win = open_float(list_width, 0, " Tasks ")

	-- direction を "bottom" のままにすると出力用の分割ウィンドウが余分に作られるため
	-- "right" を指定して一覧のみを浮動ウィンドウに載せる
	overseer.open({ winid = list_win, enter = true, direction = "right" })

	-- overseer.open は設定の max_width に合わせて幅を縮めるので元の大きさに戻す
	vim.api.nvim_win_set_width(list_win, list_width)
	vim.api.nvim_win_set_height(list_win, height)

	-- 一覧のカーソル移動に追従してタスク出力を表示する。一覧が閉じると一緒に閉じる
	TaskView.new(output_win, {
		close_on_list_close = true,
		select = function(_, tasks, task_under_cursor)
			return task_under_cursor or tasks[1]
		end,
	})
end

return {
	"stevearc/overseer.nvim",
	keys = {
		{ "<C-B>", "<CMD>OverseerRun<CR>", desc = "Overseer Run" },
		{ "<leader>r", taskpanel_float, desc = "Overseer Toggle" },
	},
	---@module 'overseer'
	---@type overseer.SetupOpts
	opts = {},
	config = function(_, opts)
		require("overseer").setup(opts)
		vim.api.nvim_create_autocmd("User", {
			pattern = "OverseerListUpdate",
			desc = "浮動パネル表示中に起動したタスクの端末バッファを生成する",
			nested = true, -- ウィンドウ移動で WinEnter を発火させるために必要
			callback = flush_pending_terminals,
		})
	end,
}
