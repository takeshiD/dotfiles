---指定ディレクトリで Git を同期実行し、終了コードと標準出力・標準エラーを返す。
---@param cwd string Git を実行するディレクトリ
---@param args string[] Git のサブコマンドと引数
---@return vim.SystemCompleted result
local function git(cwd, args)
    return vim.system(vim.list_extend({ "git", "-C", cwd }, args), { text = true }):wait()
end

---通常バッファのファイル位置、または cwd からリポジトリのルートを取得する。
---取得に失敗した場合はエラーを通知する。
---@return string? root リポジトリの絶対パス。取得に失敗した場合は nil
local function repository()
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = vim.bo.buftype == "" and file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
    local result = git(cwd, { "rev-parse", "--show-toplevel" })
    if result.code ~= 0 then
        vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR, { title = "Diffview" })
        return
    end
    return vim.trim(result.stdout)
end

---未コミット差分を開き、unstaged（index → worktree）と staged（HEAD → index）を表示する。
---@param root string リポジトリの絶対パス
---@return nil
local function open_uncommit(root)
    require("diffview").open({ "-C=" .. root })
end

---origin/HEAD、main、master の順に元ブランチを探し、元ブランチ..HEAD の差分を開く。
---候補が存在しない場合はエラーを通知する。
---@param root string リポジトリの絶対パス
---@return nil
local function open_origin(root)
    for _, ref in ipairs({ "refs/remotes/origin/HEAD", "refs/heads/main", "refs/heads/master" }) do
        if git(root, { "rev-parse", "--verify", ref .. "^{commit}" }).code == 0 then
            require("diffview").open({ "-C=" .. root, ref .. "..HEAD" })
            return
        end
    end
    vim.notify(
        "元ブランチを判定できません（origin/HEAD、main、master がありません）",
        vim.log.levels.ERROR,
        {
            title = "Diffview",
        }
    )
end

---追跡済みファイルの staged／unstaged があれば未コミット差分、それ以外は元ブランチとの差分を開く。
---@return nil
local function open_auto()
    local root = repository()
    if not root then
        return
    end
    local result = git(root, { "status", "--porcelain", "--untracked-files=no" })
    if result.code ~= 0 then
        vim.notify(vim.trim(result.stderr), vim.log.levels.ERROR, { title = "Diffview" })
    elseif result.stdout ~= "" then
        open_uncommit(root)
    else
        open_origin(root)
    end
end

return {
    "dlyongemallo/diffview-plus.nvim",
    event = "VeryLazy",
    enabled = true,
    cmd = {
        "DiffviewOpen",
        "DiffviewToggle",
        "DiffviewFileHistory",
        "DiffviewDiffFiles",
        "DiffviewLog",
        "DiffViewUncommit",
        "DiffViewOrigin",
    },
    keys = {
        { mode = { "n" }, "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", desc = "Unstaged FileHistory" },
        {
            mode = { "n" },
            "<leader>df",
            ---現在のタブが Diffview なら閉じ、それ以外では Git の状態に応じた差分を開く。
            ---@type fun()
            function()
                if require("diffview.lib").get_current_view() then
                    vim.cmd("DiffviewClose")
                else
                    open_auto()
                end
            end,
            desc = "Diff uncommitted changes or origin branch",
        },
    },
    ---差分表示用の Ex コマンドを登録し、Diffview の表示とキーマップを設定する。
    ---@type fun()
    config = function()
        vim.api.nvim_create_user_command(
            "DiffViewUncommit",
            ---現在のリポジトリの未コミット差分を明示的に開く。
            ---@type fun()
            function()
                local root = repository()
                if root then
                    open_uncommit(root)
                end
            end,
            { desc = "Diff staged and unstaged changes" }
        )
        vim.api.nvim_create_user_command(
            "DiffViewOrigin",
            ---未コミット変更の有無に関係なく、元ブランチと HEAD のコミット間差分を開く。
            ---@type fun()
            function()
                local root = repository()
                if root then
                    open_origin(root)
                end
            end,
            { desc = "Diff origin branch against HEAD" }
        )
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
