return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        {
            -- "takeshid/avante-status.nvim",
            dir = vim.fn.stdpath("data") .. "/develop/avante-status.nvim",
            dev = true,
        },
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
        local avante_chat_component = {
            function()
                local chat = require("avante-status").chat_provider
                local msg = chat.name
                return msg
            end,
            icon = require("avante-status").chat_provider.icon,
            color = { fg = require("avante-status").chat_provider.fg}
        }
        local avante_suggestions_component = {
            function()
                local suggestions = require("avante-status").suggestions_provider
                local msg = suggestions.name
                return msg
            end,
            icon = require("avante-status").suggestions_provider.icon,
            color = { fg = require("avante-status").suggestions_provider.fg }
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
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'fileformat', 'filetype', lsp_component, avante_chat_component, avante_suggestions_component },
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
