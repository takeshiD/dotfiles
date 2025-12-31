return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/aerial.nvim",
    },
    keys = {
        { mode = { "n" }, "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>",     desc = "Telescope FileName" },
        { mode = { "n" }, "<leader>fr", "<cmd>lua require('telescope.builtin').live_grep()<CR>",      desc = "Telescope RipGrep" },
        { mode = { "n" }, "<leader>fj", "<cmd>lua require('telescope.builtin').jumplist()<CR>",       desc = "Telescope Jumplist" },
        { mode = { "n" }, "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>",        desc = "Telescope Buffers" },
        { mode = { "n" }, "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>",      desc = "Telescope Help" },
        { mode = { "n" }, "<leader>fl", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", desc = "Telescope LSP-Reference" },
        { mode = { "n" }, "<leader>fo", "<cmd>lua require('telescope').extensions.aerial.aerial()<CR>", desc = "Aerial OutlineView" },
    },
    config = function()
        require("telescope").load_extension("aerial")
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<leader>f"] = require("telescope.actions").close,
                    },
                    n = {
                        ["<leader>f"] = require("telescope.actions").close,
                    }
                },
            },
            extensions = {
                aerial = {
                    -- Set the width of the first two columns (the second
                    -- is relevant only when show_columns is set to 'both')
                    col1_width = 10,
                    col2_width = 30,
                    -- How to format the symbols
                    format_symbol = function(symbol_path, filetype)
                        if filetype == "json" or filetype == "yaml" then
                            return table.concat(symbol_path, ".")
                        else
                            return symbol_path[#symbol_path]
                        end
                    end,
                    -- Available modes: symbols, lines, both
                    show_columns = "both",
                }
            }
        })
    end,
}
