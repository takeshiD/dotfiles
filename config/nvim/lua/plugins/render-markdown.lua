return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    ft = { "markdown", "Avente" },
    opts = {
        file_types = { "markdown", "Avente" },
    },
    keys = {
        -- { "<leader>t", "<cmd>RenderMarkdown toggle<CR>", mode = { "n" } },
    },
    config = function()
        local color = require("functions.color")
        local NormalBg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        local RenderMarkdownH1Fg = vim.api.nvim_get_hl(0, { name = "Constant" }).fg
        local RenderMarkdownH2Fg = vim.api.nvim_get_hl(0, { name = "String" }).fg
        local RenderMarkdownH3Fg = vim.api.nvim_get_hl(0, { name = "Function" }).fg
        local RenderMarkdownH4Fg = vim.api.nvim_get_hl(0, { name = "Keyword" }).fg
        local RenderMarkdownH5Fg = vim.api.nvim_get_hl(0, { name = "Character" }).fg
        local RenderMarkdownH6Fg = vim.api.nvim_get_hl(0, { name = "Macro" }).fg
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH1", { fg = RenderMarkdownH1Fg })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH2", { fg = RenderMarkdownH2Fg })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH3", { fg = RenderMarkdownH3Fg })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH4", { fg = RenderMarkdownH4Fg })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH5", { fg = RenderMarkdownH5Fg })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH6", { fg = RenderMarkdownH6Fg })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH1Bg",
            { fg = RenderMarkdownH1Fg, bg = color.composeColor(NormalBg, RenderMarkdownH1Fg, 0.8), bold = true, cterm = { bold = true } })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH2Bg",
            { fg = RenderMarkdownH2Fg, bg = color.composeColor(NormalBg, RenderMarkdownH2Fg, 0.8), bold = true, cterm = { bold = true } })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH3Bg",
            { fg = RenderMarkdownH3Fg, bg = color.composeColor(NormalBg, RenderMarkdownH3Fg, 0.8), bold = true, cterm = { bold = true } })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH4Bg",
            { fg = RenderMarkdownH4Fg, bg = color.composeColor(NormalBg, RenderMarkdownH4Fg, 0.8), bold = true, cterm = { bold = true } })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH5Bg",
            { fg = RenderMarkdownH5Fg, bg = color.composeColor(NormalBg, RenderMarkdownH5Fg, 0.8), bold = true, cterm = { bold = true } })
        vim.api.nvim_set_hl(0, "MyRenderMarkdownH6Bg",
            { fg = RenderMarkdownH6Fg, bg = color.composeColor(NormalBg, RenderMarkdownH6Fg, 0.8), bold = true, cterm = { bold = true } })
        require("render-markdown").setup({
            enabled = true,
            heading = {
                enabled = true,
                sign = false,
                position = "inline",
                icons = { "󰕱", "󰕱󰕱", "󰕱󰕱󰕱", "󰕱󰕱󰕱󰕱", "󰕱󰕱󰕱󰕱󰕱", "󰕱󰕱󰕱󰕱󰕱󰕱" },
                width = "full",
                left_margin = 0,
                left_pad = 0,
                right_pad = 0,
                min_width = 0,
                border = true,
                border_virtual = false,
                border_prefix = false,
                below = "▔",
                -- above = "▔",
                above = "",
                backgrounds = {
                    'MyRenderMarkdownH1Bg',
                    'MyRenderMarkdownH2Bg',
                    'MyRenderMarkdownH3Bg',
                    'MyRenderMarkdownH4Bg',
                    'MyRenderMarkdownH5Bg',
                    'MyRenderMarkdownH6Bg',
                },
                foregrounds = {
                    'MyRenderMarkdownH1',
                    'MyRenderMarkdownH2',
                    'MyRenderMarkdownH3',
                    'MyRenderMarkdownH4',
                    'MyRenderMarkdownH5',
                    'MyRenderMarkdownH6',
                },
            },
            checkbox = {
                enabled = true,
                position = "inline",
                unchecked = {
                    icon = "[ ]",
                    highlight = "RenderMarkdownUnchecked",
                },
                checked = {
                    icon = "[󰄬]",
                    highlight = "OkSign",
                },
                custom = {
                    pending = { raw = "[-]", rendered = "[]", highlight = "NonText" },
                }
            },
            code = {
                enabled = true,
                sign = true,
                style = 'full',
                position = 'right',
                width = 'block',
                min_width = 60,
                right_pad = 10,
                border = 'thick',
                above = '▄',
                below = '▀',
                highlight = 'RenderMarkdownCode',
                highlight_inline = 'RenderMarkdownCodeInline',
            }
        })
    end
}
