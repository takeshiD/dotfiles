return {
    "nvim-lualine/lualine.nvim",
    event = 'VeryLazy',
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "takeshid/avante-status.nvim",
    },
    config = function()
        local lualine = require("lualine")
        local lsp_component = {
            function()
                local msg = ""
                local ft = vim.bo.filetype
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if next(clients) == nil then
                    return msg
                end
                for _, client in ipairs(clients) do
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, ft) ~= -1 then
                        return client.name
                    end
                end
                return msg
            end,
            icon = " ",
            color = { fg = "#FF8800" },
        }
        local project_root = {
            function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
            end,
            icon = "",
            separator = '›',
        }
        local config = {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = '',
                section_separators = { left = '', right = '' },
                globalstatus = true,
                refresh = {
                    statusline = 500,
                    tabline = 500,
                    winbar = 500,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { project_root, 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = {
                    'encoding',
                    'fileformat',
                    'filetype',
                    lsp_component,
                    -- require('avante-status.lualine').chat_component,
                    -- require('avante-status.lualine').suggestions_component,
                    -- require('mcphub.extensions.lualine'),
                },
                lualine_y = { 'progress', },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
        }
        lualine.setup(config)
    end,
}
