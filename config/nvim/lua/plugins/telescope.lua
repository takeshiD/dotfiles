return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    keys = {
        { mode = {"n"}, "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>" },
        { mode = {"n"}, "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>" },
        { mode = {"n"}, "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>" },
        { mode = {"n"}, "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>" },
    }
}
