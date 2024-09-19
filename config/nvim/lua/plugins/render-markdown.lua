return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    keys = {
        {"<C-t>", "<cmd>RenderMarkdown toggle<CR>", mode = {"n"}},
    },
    config = function()
        require("render-markdown").setup({
            enabled = true,
            checkbox = {
                enabled = true,
                position = "inline",
                unchecked = {
                    icon = "⬜ ",
                    highlight = "RenderMarkdownUnchecked",
                },
                checked = {
                    icon = "✅ ",
                    highlight = "RenderMarkdownChecked",
                }
            }
        })
    end
}
