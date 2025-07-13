local keymap = vim.keymap
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

keymap.set('n', '<ESC><ESC>', ':noh<Return>')
keymap.set('n', 'j', 'gj', { desc = "Down" })
keymap.set('n', 'k', 'gk', { desc = "Up" })
keymap.set('n', 'gj', 'j', { desc = "Left" })
keymap.set('n', 'gk', 'k', { desc = "Right" })
keymap.set('n', '<Return><Return>', '<C-w>w', { desc = "BufferCyclic" })
keymap.set('n', '<C-p>', ':bprev<Return>')
keymap.set('n', '<C-n>', ':bnext<Return>')
keymap.set('n', '<C-w><C-w>', ':bdelete %<Return>')
keymap.set('n', 'L', '$')
keymap.set('n', 'H', '^')
keymap.set('v', 'L', '$')
keymap.set('v', 'H', '^')
keymap.set('i', 'jj', '<ESC>')


--############# LSP ###############
-- keymap.set('n', 'gf', function()
--     vim.lsp.buf.format({ async = true })
-- end, { desc = "LSP Formatting" }
-- )

--############# US-keyboard ###############
keymap.set('n', ';', ':')
keymap.set('n', ':', ';')
keymap.set('v', ';', ':')
keymap.set('v', ':', ';')

-- vim.keymap.set('n', '<C-w>,', '<C-w><', { noremap = true })
-- vim.keymap.set('n', '<C-w>.', '<C-w>>', { noremap = true })
-- vim.keymap.set('n', '<C-w>+', '<C-w>+', { noremap = true })
-- vim.keymap.set('n', '<C-w>-', '<C-w>-', { noremap = true })
