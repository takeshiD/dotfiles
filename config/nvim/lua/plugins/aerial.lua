return {
    'stevearc/aerial.nvim',
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    event = "VeryLazy",
    keys = {
        { "<C-f>", "<cmd>AerialToggle left<CR>", desc = "Aerial Toggle" },
        { "<leader>f", "<cmd>AerialToggle float<CR>", desc = "Aerial Toggle" },
    },
    config = function()
        require("aerial").setup({
            backends = {"lsp", "treesitter"},
            layout = {
                max_width = {50, 0.5},
                width = nil,
                min_width = 20,
                resize_to_content = true,
            },
            attach_mode = "global",
            float = {
                border = "rounded",
                relative = "win",
                max_height = 0.9,
                height = 0.5,
                min_height = {8, 0.3},
            },
        })
    end
}
