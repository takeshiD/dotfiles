function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		-- If there is no current directory (e.g. over ssh), just show the buffer name
		return vim.api.nvim_buf_get_name(0)
	end
end

-- git の出力を { [ファイル名] = true } の表に変換する
local function parse_output(proc)
	local result = proc:wait()
	local ret = {}
	if result.code == 0 then
		for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
			-- 末尾のスラッシュを取り除く
			line = line:gsub("/$", "")
			ret[line] = true
		end
	end
	return ret
end

-- ディレクトリごとに gitignore 対象の一覧を保持する（初回参照時に取得）
local function new_git_status()
	return setmetatable({}, {
		__index = function(self, key)
			local ignore_proc = vim.system(
				{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
				{ cwd = key, text = true }
			)
			local ret = { ignored = parse_output(ignore_proc) }
			rawset(self, key, ret)
			return ret
		end,
	})
end
local git_status = new_git_status()

-- 再読み込み時に保持した一覧を破棄する
local refresh = require("oil.actions").refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
	git_status = new_git_status()
	orig_refresh(...)
end

return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "<C-e>", "<CMD>Oil<CR>", desc = "Open parent dir" },
	},
	opts = require("oil").setup({
		columns = {
			"icon",
			"permissions",
			"size",
			"mtime",
		},
		win_options = {
			signcolumn = "yes:2",
			winbar = "%!v:lua.get_oil_winbar()",
		},
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name, bufnr)
				local is_dotfile = vim.startswith(name, ".") and name ~= ".."
				local dir = require("oil").get_current_dir(bufnr)
				-- ローカルのディレクトリでない場合（ssh 経由など）はドットファイルのみ隠す
				if not dir then
					return is_dotfile
				end
				-- ドットファイルに加え、gitignore 対象のファイルも隠す
				return is_dotfile or git_status[dir].ignored[name] == true
			end,
		},
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-s>"] = { "actions.select", opts = { vertical = true } },
			["<C-v>"] = { "actions.select", opts = { horizontal = true } },
			["<C-t>"] = { "actions.select", opts = { tab = true } },
			["<C-p>"] = {
				callback = function()
					require("oil.actions").preview.callback({
						split = "botright",
					})
				end,
				desc = "Toggle Oil Preview",
				mode = "n",
			},
			["<C-e>"] = { "actions.close", mode = "n" },
			["<C-l>"] = "actions.refresh",
			["-"] = { "actions.parent", mode = "n" },
			["_"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["g."] = { "actions.toggle_hidden", mode = "n" },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
		},
		use_default_keymaps = false,
	}),
}
