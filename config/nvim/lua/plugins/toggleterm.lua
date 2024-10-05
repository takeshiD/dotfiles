return {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    keys = {
        { mode = {'n'}, desc = 'ToggleTerm default vertical', '<C-t>', '<CMD>ToggleTerm<CR>' },
        { mode = {'n'}, desc = 'ToggleTerm Vertical', '<leader>tv', '<CMD>ToggleTerm size=60 direction=vertical<CR>' },
        { mode = {'n'}, desc = 'ToggleTerm Horizontal', '<leader>ts', '<CMD>ToggleTerm size=10 direction=horizontal<CR>' },
        { mode = {'n'}, desc = 'ToggleTerm Float', '<leader>tf', '<CMD>ToggleTerm direction=float<CR>' },
    },
    config = function()
        vim.api.nvim_create_autocmd('TermOpen', {
            pattern = 'term://*',
            callback = function()
                local opts = { buffer = 0 }
                vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)
                vim.keymap.set('t', '<C-w>h', '<CMD>wincmd h<CR>', opts)
                vim.keymap.set('t', '<C-w>j', '<CMD>wincmd j<CR>', opts)
                vim.keymap.set('t', '<C-w>k', '<CMD>wincmd k<CR>', opts)
                vim.keymap.set('t', '<C-w>l', '<CMD>wincmd l<CR>', opts)
                vim.keymap.set('t', '<C-t>', '<CMD>ToggleTerm<CR>', opts)
            end
        })
        require("toggleterm").setup({
            shell = "nu",
            direction = "vertical",
            size = 60,
            float_opts = {
                border = 'single',
                title_pos = 'left',
            },
        })
    end
}
