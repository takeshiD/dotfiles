local keymap = vim.keymap
keymap.set('n', '<ESC><ESC>', ':noh<Return>')
keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')
keymap.set('n', 'gj', 'j')
keymap.set('n', 'gk', 'k')
keymap.set('n', '<Return><Return>', '<C-w>w')
keymap.set('n', '<C-p>', ':bprev<Return>')
keymap.set('n', '<C-n>', ':bnext<Return>')
keymap.set('n', '<C-w><C-w>', ':bdelete %<Return>')
keymap.set('n', 'L', '$')
keymap.set('n', 'H', '^')
keymap.set('v', 'L', '$')
keymap.set('v', 'H', '^')
keymap.set('i', 'jj', '<ESC>')

-- unset indent/remove-indent when intert-mode
-- keymap.del("i", "<C-d>")
-- keymap.del("i", "<C-t>")

--############# LSP ###############
keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>')
keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<cr>')
keymap.set('n', '<leader>d', '<cmd>Lspsaga peek_definition<cr>')
keymap.set('n', 'gd', '<cmd>Lspsaga goto_definition<cr>')
keymap.set('n', 'gr', '<cmd>Lspsaga lsp_finder<cr>')
keymap.set('n', 'ga', '<cmd>Lspsaga code_action<cr>')
keymap.set('n', 'go', '<cmd>Lspsaga outline<cr>')
keymap.set('n', 'gn', '<cmd>Lspsaga rename<cr>')
keymap.set('n', 'ge', '<cmd>Lspsaga show_line_diagnostics<cr>')

--############# US-keyboard ###############
keymap.set('n', ';', ':')
keymap.set('n', ':', ';')
keymap.set('v', ';', ':')
keymap.set('v', ':', ';')
