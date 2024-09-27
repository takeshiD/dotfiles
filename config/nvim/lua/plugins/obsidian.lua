return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    event = {
        "BufReadPre ~/vaults/**/*.md",
        "BufNewFile ~/vaults/**/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
    },
    init = function()
        vim.opt.conceallevel = 1
    end,
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/vaults/personal",
            },
            {
                name = "work",
                path = "~/vaults/work",
            },
        },
        daily_notes = {
            folder = "daily",
            date_format = "%Y-%m-%d",
            default_tags = { "daily" },
            template = nil,
        },
        ui = {
            enable = true,
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        mappings = {
            ["<leader>of"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            ["<leader>oc"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
            ["<CR>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            },
        },
    },
}
