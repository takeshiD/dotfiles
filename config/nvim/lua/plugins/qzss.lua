return {
    "takeshiD/qzss.nvim",
    -- cmd = { "Qzss", "QzssOpen" },
    event = "VeryLazy",
    keys = {
        {
            mode = "n",
            "<leader>go",
            "<cmd>Qzss<cr>",
            desc = "Outline (qzss)",
        },
    },
    opts = {},
}
