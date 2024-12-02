return {
    "takeshid/avante-status.nvim",
    enabled = false,
    lazy = false,
    -- event = "VeryLazy",
    -- dir = vim.fn.stdpath("data") .. "/develop/avante-status.nvim",
    fallback = false,
    config = function()
        require('avante-status').setup()
    end
}
