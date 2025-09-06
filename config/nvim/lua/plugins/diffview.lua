return {
    'sindrets/diffview.nvim',
    event = "VeryLazy",
    enabled = true,
    keys = {
        { mode = {"n"}, "<leader>hf", "<cmd>DiffviewFileHistory %<CR>"},
        { mode = {"n"}, "<leader>hd", function()
            if next(require("diffview.lib").views) == nil then
                vim.cmd("DiffviewOpen")
            else
                vim.cmd("DiffviewClose")
            end
        end
        },
    },
    config = function()
        require('diffview').setup()
    end
}
