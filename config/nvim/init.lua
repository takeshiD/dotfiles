require("core.options")
require("core.lazy")
vim.cmd.colorscheme("cyberdream")
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("core.keymap")
        require("core.lsp")
    end,
})
