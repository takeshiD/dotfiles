--- 種別→アイコンの表に、折りたたみ時のアイコン(<種別>Collapsed)を補う。
--- 明示的に <種別>Collapsed が書かれていればそちらを優先する。
---@param icon_map table<string, string>
---@param symbol string
---@return table<string, string>
local function _icon_with_collapsed(icon_map, symbol)
    local result = vim.deepcopy(icon_map)
    for kind, icon in pairs(icon_map) do
        if not kind:match("Collapsed$") and result[kind .. "Collapsed"] == nil then
            result[kind .. "Collapsed"] = icon .. " " .. symbol
        end
    end
    return result
end

--- aerial の icons 設定を生成する。
--- 値が表のもの(ファイル種別ごとの設定)はそれぞれに補い、
--- 値が文字列のもの(全ファイル種別共通の設定)はまとめて補う。
---@param args { opts?: { collapse_symbol?: string }, icons: table<string, string|table<string, string>> }
---@return table<string, string|table<string, string>>
local function icons_with_collapsed(args)
    local symbol = (args.opts or {}).collapse_symbol or "↙"
    local common = {}
    local result = {}
    for key, value in pairs(args.icons) do
        if type(value) == "table" then
            result[key] = _icon_with_collapsed(value, symbol)
        else
            common[key] = value
        end
    end
    return vim.tbl_extend("error", result, _icon_with_collapsed(common, symbol))
end

return {
    {
        "stevearc/aerial.nvim",
        enabled = true,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        keys = {
            {
                mode = { "n" },
                "go",
                "<CMD>AerialToggle float<CR>",
                desc = "Outline",
            },
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
                close_on_select = true,
                float = {
                    border = "rounded",
                    relative = "editor",
                    -- max_height = 0.9,
                    -- height = 0.5,
                    -- min_height = { 8, 0.3 },
                },
                nav = {
                    preview = true,
                    autojump = true,
                },
                -- keymaps = {
                --     ["go"] = "actions.close",
                -- },
                -- nerd_font = "mini.icons",
                icons = icons_with_collapsed({
                    opts = {
                        collapse_symbol = "↙",
                    },
                    icons = {
                        python = {
                            Class = "class",
                            Function = "def",
                            Method = "def",
                        },
                        lua = {
                            Function = "fn",
                            Method = "fn",
                        },
                        rust = {
                            Class = "impl",
                            Struct = "struct",
                            Enum = "enum",
                            Function = "fn",
                            Module = "mod",
                            Method = "fn",
                            Interface = "trait",
                        },
                        -- c = {},
                        -- cpp = {},
                        typescript = {
                            Class = "class",
                            Function = "fn",
                            Method = "fn",
                            Interface = "interface",
                        },
                        markdown = {
                            -- Header
                            Interface = "#",
                        },
                        yaml = {
                            Class = "{}",
                            Enum = "[]",
                            Module = "-",
                        },
                        json = {
                            Class = "{}",
                        },
                    },
                }),
            })
        end,
    },
}
