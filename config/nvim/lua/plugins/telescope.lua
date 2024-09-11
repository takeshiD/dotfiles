return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    keys = {
        {"<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>"},
        {"<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>"},
        {"<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>"},
        {"<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>"},
    }
}
