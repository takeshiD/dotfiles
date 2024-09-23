return {
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        ft = { "org" },
        config = function()
            require("orgmode").setup({
                -- Path
                org_agenda_files = {"~/notes/agenda/**/*", "~/notes/inbox.org" },
                org_default_notes_file = "~/notes/inbox.org",
                -- org_archive_location = "~/notes/archive/archive.org",
                -- Todos
                org_todo_keywords = { "TODO", "WAITING", "|", "DONE" },
                org_todo_keyword_faces = {
                    TODO    = ":foreground white :background red",
                    WAITING = ":foreground white :background darkmagenta",
                    DONE    = ":foreground white :background green",
                },
                -- Look & Feel
                org_startup_folded = "showeverything",
                win_split_mode = "float",
                win_border = "single",
                org_hide_leading_stars = true,
                -- org_hide_emphasis_markers = true,
                org_ellipsis = " ",
                org_log_done = "time",
                org_log_repeat = "time",
                org_log_into_drawer = "LOGBOOK",
                org_startup_indented = false,
                calendar_week_start_day = 0,
                -- Agenda settings
                org_deadline_warning_days = 14,
                org_agenda_span = "week",
                -- Keymapping
                mappings = {
                    global = {
                        org_agenda = "<leader>a",
                        org_capture = "<leader>c",
                    },
                    org = {
                        org_todo = "<C-c>",
                    },
                },
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
