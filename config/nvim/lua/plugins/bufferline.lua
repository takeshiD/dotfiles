local colors = {
    fg = vim.api.nvim_get_hl(0, { name = "IncSearch" }).fg,
    bg = vim.api.nvim_get_hl(0, { name = "IncSearch" }).bg,
}

return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- lazy = false,
    event = "VeryLazy",
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            indicator = {
                style = "underline",
            },
            separator_style = "slant",
        },
        highlights = {
        }
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
    end
}
