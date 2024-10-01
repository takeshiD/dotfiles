return {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    ft = { "markdown" },
    keys = {
        { "<leader>t", "<cmd>RenderMarkdown toggle<CR>", mode = { "n" } },
    },
    config = function()
        -- local color = require("functions.color")
        -- local NormalBG = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        -- local RenderMarkdownH1Fg = vim.api.nvim_get_hl(0, { name = "OkSign" }).fg
        -- local RenderMarkdownH2Fg = vim.api.nvim_get_hl(0, { name = "ErrorSign" }).fg
        -- local RenderMarkdownH3Fg = vim.api.nvim_get_hl(0, { name = "WarningSign" }).fg
        -- local RenderMarkdownH4Fg = vim.api.nvim_get_hl(0, { name = "InfoSign" }).fg
        -- local RenderMarkdownH5Fg = vim.api.nvim_get_hl(0, { name = "HintSign" }).fg
        -- local RenderMarkdownH6Fg = vim.api.nvim_get_hl(0, { name = "HintSign" }).fg
        -- print(RenderMarkdownH1Fg)
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = RenderMarkdownH1Fg })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = RenderMarkdownH2Fg })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = RenderMarkdownH3Fg })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = RenderMarkdownH4Fg })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = RenderMarkdownH5Fg })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = RenderMarkdownH6Fg })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = color.composeColor(NormalBG, RenderMarkdownH1Fg, 0.8) })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = color.composeColor(NormalBG, RenderMarkdownH2Fg, 0.8) })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = color.composeColor(NormalBG, RenderMarkdownH3Fg, 0.8) })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = color.composeColor(NormalBG, RenderMarkdownH4Fg, 0.8) })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = color.composeColor(NormalBG, RenderMarkdownH5Fg, 0.8) })
        -- vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = color.composeColor(NormalBG, RenderMarkdownH6Fg, 0.8) })
        require("render-markdown").setup({
            enabled = true,
            heading = {
                enabled = true,
                sign = false,
                position = "overlay",
                icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
                width = "full",
                left_margin = 0,
                left_pad = 0,
                right_pad = 0,
                min_width = 0,
                border = false,
                border_virtual = false,
                border_prefix = false,
                below = "▀",
                above = "▄",
                backgrounds = {
                    'RenderMarkdownH1Bg',
                    'RenderMarkdownH2Bg',
                    'RenderMarkdownH3Bg',
                    'RenderMarkdownH4Bg',
                    'RenderMarkdownH5Bg',
                    'RenderMarkdownH6Bg',
                },
                foregrounds = {
                    'RenderMarkdownH1',
                    'RenderMarkdownH2',
                    'RenderMarkdownH3',
                    'RenderMarkdownH4',
                    'RenderMarkdownH5',
                    'RenderMarkdownH6',
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
            }
        })
    end
}
