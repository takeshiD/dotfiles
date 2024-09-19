return {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    ft = {"markdown"},
    keys = {
        {"<leader>t", "<cmd>RenderMarkdown toggle<CR>", mode = {"n"}},
    },
    config = function()
        require("render-markdown").setup({
            enabled = true,
            checkbox = {
                enabled = true,
                position = "inline",
                unchecked = {
                    icon = "󰄱 ",
                    highlight = "HintSign",
                },
                checked = {
                    icon = "󰄲 ",
                    highlight = "OkSign",
                }
            }
        })
    end
}
