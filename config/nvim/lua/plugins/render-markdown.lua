return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("render-markdown").setup({
            enabled = true,
            checkbox = {
                enabled = true,
                position = "inline",
                unchecked = {
                    icon = "󰄱 ",
                    highlight = "RenderMarkdownChecked",
                },
                checked = {
                    icon = "󰱒 ",
                    highlight = "RenderMarkdownChecked",
                }
            }
        })
    end
}
