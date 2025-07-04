return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000,    -- needs to be loaded in first
    config = function()
        require('tiny-inline-diagnostic').setup({
            -- preset = "powerline",
            transparent_bg = false,
            hi = {
                error = "DiagnosticError", -- Highlight group for error messages
                warn = "DiagnosticWarn",   -- Highlight group for warning messages
                info = "DiagnosticInfo",   -- Highlight group for informational messages
                hint = "DiagnosticHint",   -- Highlight group for hint or suggestion messages
                arrow = "NonText",         -- Highlight group for diagnostic arrows
                background = "NonText",
                mixing_color = "None",
            },
            options = {
                show_source = true,
                add_messages = true,
                multilines = {
                    enabled = true,
                    always_show = true,
                },
                overflow = {
                    mode = "wrap",
                    padding = 2,
                },
                virt_texts = {
                    priority = 2048,
                },
            },
            signs = {
                left = "",
                right = "",
                diag = "●",
                arrow = "    ",
                up_arrow = "    ",
                vertical = " │",
                vertical_end = " └",
            },
            blend = {
                factor = 0.2
            }
        })
        vim.diagnostic.config({ virtual_text = false })
    end
}
