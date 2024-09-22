return {
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        ft = { "org" },
        config = function()
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = "*.org",
                command = "language en_US.utf8",
            })
            require("orgmode").setup({
                org_agenda_files = "~/notes/agenda/**/*",
                org_default_notes_file = "~/notes/org/inbox.org",
                org_startup_folded = "showeverything",
                -- org_agenda_skip_scheduled_if_done = true,
                win_split_mode = "float",
                win_border = "single",
                mappings = {
                    global = {
                        org_agenda = "<leader>a",
                        org_capture = "<leader>c",
                    },
                    org = {
                        org_todo = "<C-c>",
                    },
                },
                org_todo_keywords = { "TODO", "WAITING", "|", "DONE" },
                org_todo_keyword_faces = {
                    TODO    = ":foreground white :background red",
                    WAITING = ":foreground white :background darkmagenta",
                    DONE    = ":foreground white :background green",
                }
            })
        end,
    },
    {
        "nvim-orgmode/telescope-orgmode.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-orgmode/orgmode",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("orgmode")
            vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
            vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
            vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
        end,
    },
    {
        "akinsho/org-bullets.nvim",
        enabled = false,
        config = function()
            require("org-bullets").setup {
                concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
                symbols = {
                    list = "•",
                    headlines = { "◉", "○", "✸", "✿" },
                    checkboxes = {
                        half = { "", "@org.checkbox.halfchecked" },
                        done = { "✓", "@org.keyword.done" },
                        todo = { "˟", "@org.keyword.todo" },
                    },
                }
            }
        end
    }
}
