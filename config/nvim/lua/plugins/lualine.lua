return {
    "nvim-lualine/lualine.nvim",
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
        local avante_chat_component = {
            function()
                local avante_status = require("avante-status")
                local chat = avante_status.current_chat_provider
                -- local msg_chat = "%#" .. chat.highlight .. "#" .. chat.icon .. " " .. chat.name .. "%#StatusLine#"
                local msg_chat = chat.icon .. " " .. chat.name
                return msg_chat
            end,
            color = require("avante-status").current_chat_provider.highlight
        }
        local avante_suggestions_component = {
            function()
                local avante_status = require("avante-status")
                local suggest = avante_status.current_suggestions_provider
                -- local msg_suggest = "%#" .. suggest.highlight .. "#" .. suggest.icon .. " " .. suggest.name .. "%#StatusLine#"
                local msg_suggest = suggest.icon .. " " .. suggest.name
                return msg_suggest
            end,
            color = require("avante-status").current_suggestions_provider.highlight
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
                lualine_x = { 'encoding', 'fileformat', 'filetype', lsp_component, avante_chat_component, avante_suggestions_component},
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
