return {
    "takeshid/avante-status.nvim",
    enabled = false,
    event = "VeryLazy",
    dir = vim.fn.stdpath("data") .. "/develop/avante-status.nvim",
    fallback = true,
    config = function()
        require('avante-status').setup()
    end
}
