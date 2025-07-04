local M = {}

-- function M.setup_virtualtext_highlight()
--     local color = require("functions.color")
--     local NormalBG = vim.api.nvim_get_hl(0, { name = "Normal" })["bg"]
--     local VirtualErrorFG = vim.api.nvim_get_hl(0, { name = "DiagnosticError" })["fg"]
--     local VirtualWarnFG = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" })["fg"]
--     local VirtualInfoFG = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" })["fg"]
--     local VirtualHintFG = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" })["fg"]
--     vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
--         bg = color.composeColor(VirtualErrorFG, NormalBG, 0.7),
--         fg = VirtualErrorFG,
--     })
--     vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
--         bg = color.composeColor(VirtualWarnFG,NormalBG,  0.7),
--         fg = VirtualWarnFG,
--     })
--     vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
--         bg = color.composeColor(VirtualInfoFG,NormalBG,  0.7),
--         fg = VirtualInfoFG,
--     })
--     vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
--         bg = color.composeColor(VirtualHintFG, NormalBG, 0.7),
--         fg = VirtualHintFG,
--     })
-- end
--
function M.setup_lsp()
    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    --     vim.lsp.diagnostic.on_publish_diagnostics, {
    --         update_in_insert = false,
    --         rate_limiting = {
    --             max_updates_per_second = 2,
    --         },
    --     }
    -- )
    vim.diagnostic.config({
        -- update_in_insert = false,
        -- underline = true,
        -- severity_sort = true,
        -- virtual_text = {
        --     source = false,
        --     prefix = function(diagnostic, _, _)
        --         if diagnostic.severity == vim.diagnostic.severity.ERROR then
        --             return string.format(" ")
        --         elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        --             return string.format(" ")
        --         elseif diagnostic.severity == vim.diagnostic.severity.INFO then
        --             return string.format(" ")
        --         elseif diagnostic.severity == vim.diagnostic.severity.HINT then
        --             return string.format(" ")
        --         end
        --     end,
        --     suffix = "",
        --     virt_text_pos = "eol",
        --     hl_mode = "combine",
        -- },
        -- signs = {
        --     text = { "", "", "", "" },
        --     numhl = {
        --         "DiagnosticSignError",
        --         "DiagnosticSignWarn",
        --         "DiagnosticSignInfo",
        --         "DiagnosticSignHint",
        --     },
        --     linehl = {
        --         "DiagnosticSignError",
        --         "DiagnosticSignWarn",
        --         "DiagnosticSignInfo",
        --         "DiagnosticSignHint",
        --     },
        -- },
        -- float = {
        --     focusable = true,
        --     style = "minimal",
        --     border = "rounded",
        --     source = "always",
        --     header = "",
        --     prefix = "",
        -- },
    })
    vim.lsp.inlay_hint.enable(true, nil)
end

return M
