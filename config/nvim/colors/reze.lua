local p = {
	bg = "#100808",
	fg = "#DAC8BF",
	teal = "#0696A1",
	red = "#D62520",
	darkred = "#6B1111",
	purple = "#624984",
}

vim.g.colors_name = "reze"

-- Base
vim.api.nvim_set_hl(0, "Normal", { bg = p.bg, fg = p.fg })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#181012" })
vim.api.nvim_set_hl(0, "LineNr", { fg = p.darkred })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = p.red })

-- Text
vim.api.nvim_set_hl(0, "Comment", { fg = p.purple, italic = true })
vim.api.nvim_set_hl(0, "Constant", { fg = p.darkred })
vim.api.nvim_set_hl(0, "String", { fg = p.purple })
vim.api.nvim_set_hl(0, "Function", { fg = p.teal })
vim.api.nvim_set_hl(0, "Keyword", { fg = p.red })
vim.api.nvim_set_hl(0, "Operator", { fg = p.fg })
vim.api.nvim_set_hl(0, "Identifier", { fg = "#E9DED7" })

-- Diagnostics
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = p.red })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = p.darkred })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = p.teal })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = p.purple })
