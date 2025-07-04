return {
    "nvimtools/none-ls.nvim",
    enabled = true,
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
            }
        })
    end
}
