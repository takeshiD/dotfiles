return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local lualine = require("lualine")
        local lsp_component = {
            function()
                local msg = "No Active LSP"
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
        -- local llm_chat_component = {
        --     function()
        --         -- local msg = require("avante-status").provider.chat
        --         local msg = "󰛄 Claude"
        --         return msg
        --     end,
        --     color = { fg = "#CCCCCC" },
        -- }
        -- local llm_suggestion_component = 
        --     function()
        --         -- local msg = require("avante-status").provider.suggestions
        --         local msg = current_provider.suggestions
        --         return msg
        --     end,
        -- }
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
                lualine_x = { 'encoding', 'fileformat', 'filetype', lsp_component, llm_chat_component },
                lualine_y = { 'progress' },
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
