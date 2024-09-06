vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "rounded",
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = "rounded",
        focusable = false,
    }
)

--@param fg number foreground color
--@param bg number background color
--@param alpha number between 0.0 to 1.0. if aplha is out of range, this would be rounded between 0.0 to 1.0.
--@return number # colorcode mixed alpha
local bit = require("bit")
local band = bit.band
local rshift = bit.rshift
local lshift = bit.lshift
local function composeColor(fg, bg, alpha)
    if (type(fg) ~= "number") or (fg % 1 .. "" ~= "0") then
        error("fg is not integer")
    end
    if not (0 <= fg and fg <= 0xffffff) then
        error("fg is out of range between #000000 to #FFFFFF")
    end
    if (type(bg) ~= "number") or (bg % 1 .. "" ~= "0") then
        error("bg is not integer")
    end
    if not (0 <= bg and bg <= 0xffffff) then
        error("bg is out of range between #000000 to #FFFFFF")
    end
    if type(alpha) ~= "number" then
        error("alpha is not number or integer, must be number or integer")
    end
    if not (0 <= alpha and alpha <= 1) then
        error("alpha is out of range between 0.0 to 1.0")
    end
    local fg_r = band(rshift(fg, 16), 0xFF)
    local fg_g = band(rshift(fg, 8), 0xFF)
    local fg_b = band(rshift(fg, 0), 0xFF)
    local bg_r = band(rshift(bg, 16), 0xFF)
    local bg_g = band(rshift(bg, 8), 0xFF)
    local bg_b = band(rshift(bg, 0), 0xFF)
    local r = math.floor(fg_r * alpha + bg_r * (1 - alpha))
    local g = math.floor(fg_g * alpha + bg_g * (1 - alpha))
    local b = math.floor(fg_b * alpha + bg_b * (1 - alpha))
    local compose = (lshift(r, 16) + lshift(g, 8) + lshift(b, 0))
    return compose
end

--@param dec integer expression colorcode by decimal
--@return string colorcode by triplex
local function dec2triplex(dec)
    if type(dec) ~= "number" then
        error("dec is not number")
    end
    if not (0 <= dec and dec <= 0xffffff) then
        error(string.format("dec out of range between #000000 to #FFFFFF. Got dec = #%06x", dec))
    end
    return ("#%06x"):format(dec)
end

local NormalBG = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
local VirtualErrorFG = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg
local VirtualWarnFG = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg
local VirtualInfoFG = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg
local VirtualHintFG = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", {
    bg = dec2triplex(composeColor(NormalBG, VirtualErrorFG, 0.7)),
    fg = dec2triplex(VirtualErrorFG)
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", {
    bg = dec2triplex(composeColor(NormalBG, VirtualWarnFG, 0.7)),
    fg = dec2triplex(VirtualWarnFG)
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", {
    bg = dec2triplex(composeColor(NormalBG, VirtualInfoFG, 0.7)),
    fg = dec2triplex(VirtualInfoFG)
})
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", {
    bg = dec2triplex(composeColor(NormalBG, VirtualHintFG, 0.7)),
    fg = dec2triplex(VirtualHintFG)
})

vim.diagnostic.config({
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    virtual_text = {
        source = false,
        prefix = function(diagnostic, i, total)
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
        hl_mode = "replace",
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
