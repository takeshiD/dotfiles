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
        require("render-markdown").setup({
            enabled = true,
            checkbox = {
                enabled = true,
                position = "inline",
                unchecked = {
                    icon = "󰄱 ",
                    highlight = "RenderMarkdownUnchecked",
                },
                checked = {
                    icon = "󰄵 ",
                    highlight = "OkSign",
                },
                custom = {
                    pending = { raw = "[-]", rendered = " ", highlight = "NonText" },
                }
            }
        })
    end
}
