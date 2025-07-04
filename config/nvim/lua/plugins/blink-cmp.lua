return {
    "saghen/blink.cmp",
    version = "*",
    build = "cargo build --release",
    enabled = true,
    dependencies = {
        "onsails/lspkind.nvim",
        "nvim-tree/nvim-web-devicons",
        "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
        keymap = {
            preset = "default",
            ["<C-j>"] = { "show", "select_next", "fallback" },
            ["<C-k>"] = { "show", "select_prev", "fallback" },
            ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = { border = "single" },
            },
            trigger = {
                show_on_keyword = true,
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
            },
            menu = {
                auto_show = true,
                border = "single",
                draw = {
                    columns = { { "kind_icon", gap = 1, "kind" }, { "label", "label_description", gap = 1, }, { "source_name" } },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local icon = ctx.kind_icon
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        icon = dev_icon
                                    end
                                else
                                    icon = require("lspkind").symbolic(ctx.kind, {
                                        mode = "symbol",
                                    })
                                end
                                return icon .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                local hl = ctx.kind_hl
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end
                                return hl
                            end,
                        }
                    },
                    treesitter = { "lsp" },
                }
            }
        },
        sources = {
            default = { "avante", "lsp", "path", "snippets", "buffer" },
            providers = {
                avante = {
                    module = "blink-cmp-avante",
                    name = "Avante",
                }
            }
        },
        fuzzy = {
            implementation = "prefer_rust_with_warning",
        },
        signature = {
            enabled = true,
            window = { border = "single" },
        }
    },
    opts_extend = { "sources.default" },
}
