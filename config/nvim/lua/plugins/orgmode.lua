return {
    {
        "nvim-orgmode/orgmode",
        event = false,
        ft = { "org" },
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "org",
                callback = function()
                    vim.keymap.set('i', '<S-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
                        silent = true,
                        buffer = true,
                    })
                end,
            })
            require("orgmode").setup({
                -- Keymapping
                mappings = {
                    -- org_return_uses_meta_return = true,
                    global = {
                        org_agenda = "<leader>oa",
                        org_capture = "<leader>oc",
                    },
                    agenda = {
                        org_agenda_later = "h",
                        org_agenda_earlier = "l",
                    },
                    org = {
                        org_todo = "<C-t>",
                        org_todo_prev = "<C-T>",
                        org_refile = false,
                        org_toggle_checkbox = "<C-c>",
                        org_insert_link = "<leader>l",
                        org_store_link = "<leader>u",
                        org_set_tags_command = "<leader>t",
                        org_archive_subtree = "<leader>a",
                        org_toggle_archive_tag = "<leader>A",
                        org_cycle = "<TAB>",
                        org_global_cycle = "<S-TAB>",
                        org_do_promote = "<C-h>",
                        org_do_demote = "<C-l>",
                        org_promote_subtree = "<C-H>",
                        org_demote_subtree = "<C-L>",
                        org_move_subtree_up = "<C-k>",
                        org_move_subtree_down = "<C-j>",
                        org_deadline = "<leader>d",
                        org_schedule = "<leader>s",
                        org_set_effort = "<leader>e",
                        org_time_stamp = "<leader>.",
                        org_toggle_timestamp_type = "<leader>,",
                        org_priority = "<leader>p",
                        org_clock_in = "<leader>xi",
                        org_clock_out = "<leader>xo",
                        org_clock_cancel = "<leader>xq",
                        org_clock_goto = "<leader>xj",
                        org_show_help = "<leader>?",
                    },
                },
                -- Path
                org_agenda_files = { "~/notes/agenda/**/*", "~/notes/inbox.org" },
                org_default_notes_file = "~/notes/inbox.org",
                org_archive_location = "~/notes/archive.org",
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
                org_id_prefix = "org",
                org_id_method = "org",
                org_id_link_to_org_use_id = true,
                org_time_stamp_rounding_minutes = 1,
                org_blank_before_new_entry = {
                    heading = false,
                    plain_list_item = false,
                },
                -- Agenda settings
                org_deadline_warning_days = 14,
                org_agenda_span = "week",
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
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("headlines").setup({
                markdown = {
                    headline_highlights = false,
                },
            })
        end
    }
}
