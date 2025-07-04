return {
    'dnlhc/glance.nvim',
    cmd = 'Glance',
    keys = {
        { mode = { 'n' }, 'gd', '<CMD>Glance definitions<CR>', desc = "LSP Definitions"},
        { mode = { 'n' }, 'gr', '<CMD>Glance references<CR>' , desc = "LSP References"},
    },
    opts = function()
        require('glance').setup({
            detached = function(winid)
                return vim.api.nvim_win_get_width(winid) < 100
            end,
            preview_win_opts = {
                cursorline = true,
                number = true,
                wrap = true,
            },
            border = {
                enable = true,
                top_char = '―',
                bottom_char = '―',
            },
            list = {
                position = 'right', -- Position of the list window 'left'|'right'
                width = 0.33,       -- Width as percentage (0.1 to 0.5)
            },
            theme = {
                enable = true,     -- Generate colors based on current colorscheme
                mode = 'brighten', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
            },
        })
    end
}
