vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("core.keymap")
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    pattern = "*",
    callback = function()
        require("core.lsp")
    end
})

-- local view_group = vim.api.nvim_create_augroup('ViewSettings', { clear = true })
--
-- vim.api.nvim_create_autocmd('BufWritePost', {
--     group = view_group,
--     callback = function()
--         local bufname = vim.fn.expand('%')
--         local buftype = vim.bo.buftype
--         if bufname ~= '' and buftype:match('nofile') == nil then
--             vim.defer_fn(function()
--                 vim.cmd('mkview')
--             end, 100)
--         end
--     end
-- })
--
-- vim.api.nvim_create_autocmd('BufRead', {
--     group = view_group,
--     callback = function()
--         local bufname = vim.fn.expand('%')
--         local buftype = vim.bo.buftype
--         if bufname ~= '' and buftype:match('nofile') == nil then
--             vim.defer_fn(function()
--                 vim.cmd('silent! loadview')
--             end, 100)
--         end
--     end
-- })
-- vim.opt.viewoptions:remove('options')
