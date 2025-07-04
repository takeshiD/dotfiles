return {
    "dhruvasagar/vim-table-mode",
    enabled = true,
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "org",
            callback = function()
                vim.g.table_mode_corner = "+"
                vim.g.table_mode_header_fillchar = "-"
            end
        })
    end,
    keys = {
        {'tm', ':TableModeToggle<CR>', desc = 'ToggleTableMode'},
        {'tr', ':TableModeRealign<CR>', desc = 'TableRealign'}
    }
}
