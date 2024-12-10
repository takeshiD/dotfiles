vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("core.keymap")
    end,
})

vim.api.nvim_create_autocmd({"LspAttach"}, {
    pattern = "*",
    once = true,
    callback = function()
        require("core.lsp").setup()
    end,
})
