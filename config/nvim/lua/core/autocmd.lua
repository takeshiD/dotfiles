vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("core.keymap")
    end,
})

-- vim.api.nvim_create_autocmd({"LspAttach"}, {
--     pattern = "*",
--     callback = function()
--         require("core.lsp").setup_lsp()
--     end,
-- })

-- ############## Folding ####################
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        local bufname = vim.fn.expand('%')
        local buftype = vim.bo.buftype
        if bufname ~= '' and not string.match(buftype, 'nofile') then
            vim.cmd('mkview')
        end
    end
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function()
        local bufname = vim.fn.expand('%')
        local buftype = vim.bo.buftype
        if bufname ~= '' and not string.match(buftype, 'nofile') then
            vim.cmd('silent! loadview')
        end
    end
})
