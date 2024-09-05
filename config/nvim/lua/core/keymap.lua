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
keymap.set('i', 'jj', '<ESC>')

--############# LSP ###############
keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format()<cr>')
keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<cr>')
