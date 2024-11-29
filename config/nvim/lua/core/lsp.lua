local color = require("functions.color")
local NormalBG = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
local VirtualErrorFG = vim.api.nvim_get_hl(0, { name = "ErrorSign" }).fg
local VirtualWarnFG = vim.api.nvim_get_hl(0, { name = "WarningSign" }).fg
local VirtualInfoFG = vim.api.nvim_get_hl(0, { name = "InfoSign" }).fg
local VirtualHintFG = vim.api.nvim_get_hl(0, { name = "HintSign" }).fg

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
    bg = color.composeColor(NormalBG, VirtualErrorFG, 0.7),
    fg = VirtualErrorFG,
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
    bg = color.composeColor(NormalBG, VirtualWarnFG, 0.7),
    fg = VirtualWarnFG,
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
    bg = color.composeColor(NormalBG, VirtualInfoFG, 0.7),
    fg = VirtualInfoFG,
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
    bg = color.composeColor(NormalBG, VirtualHintFG, 0.7),
    fg = VirtualHintFG,
})

vim.diagnostic.config({
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    virtual_text = {
        source = false,
        prefix = function(diagnostic, _, _)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
                return string.format(" ")
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                return string.format(" ")
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                return string.format(" ")
            elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                return string.format(" ")
            end
        end,
        suffix = "",
        virt_text_pos = "eol",
        hl_mode = "combine",
    },
    signs = {
        text = { "", "", "", "" },
        numhl = {
            "DiagnosticSignError",
            "DiagnosticSignWarn",
            "DiagnosticSignInfo",
            "DiagnosticSignHint",
        },
        linehl = {
            "DiagnosticSignError",
            "DiagnosticSignWarn",
            "DiagnosticSignInfo",
            "DiagnosticSignHint",
        },
    },
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

vim.lsp.inlay_hint.enable(true, nil)


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        update_in_insert = false,
        rate_limiting = {
            max_update_per_second = 2
        }
    }
)
