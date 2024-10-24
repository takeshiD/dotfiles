return {
    'sindrets/diffview.nvim',
    enabled = true,
    keys = {
        { mode = {"n"}, "<leader>hd", "<cmd>DiffviewOpen HEAD~1<CR>"},
        { mode = {"n"}, "<leader>hf", "<cmd>DiffviewFileHistory %<CR>"},
    },
    config = function()
        require('diffview').setup({})
    end
}
