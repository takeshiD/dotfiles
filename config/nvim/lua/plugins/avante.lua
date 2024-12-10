return {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            "takeshid/avante-status.nvim",
            dir = "d:/ex_prog/ex_neovim/develop/avante-status.nvim",
            dev = true,
        },
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
            },
        },
    },
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
    -- build = "make",
    opts = function()
        require("avante").setup({
            debug = false,
            provider = require("avante-status").get_chat_provider({
                "azure",
                "claude",
                "openai",
            }),
            auto_suggestions_provider = require("avante-status").get_suggestions_provider({
                "azure",
                "copilot",
                "claude",
                "openai",
            }),
            behaviour = {
                auto_suggestions = true,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = true,
                support_paste_from_clipboard = true,
            },
            windows = {
                position = "right",
                width = 40,
                sidebar_header = {
                    align = "center",
                    rounded = false,
                },
                ask = {
                    floating = true,
                    start_insert = true,
                    border = "rounded"
                }
            },
            -- providers-setting
            claude = {
                model = "claude-3-5-sonnet-20241022", -- $3/$15, maxtokens=8192
                -- model = "claude-3-5-haiku-20241022", -- $1/$5, maxtokens=8192
                max_tokens = 8000,
            },
            copilot = {
                model = "gpt-4o-2024-05-13",
                max_tokens = 4096,
            },
            openai = {
                model = "gpt-4o", -- $2.5/$10
                -- model = "gpt-4o-mini", -- $0.15/$0.60
                max_tokens = 4096,
            },
            azure = {
                endpoint = require("avante-status").getenv_if("AZURE_OPENAI_ENDPOINT", ""),
                deployment = require("avante-status").getenv_if("AZURE_OPENAI_DEPLOY", ""),
                api_version = "2024-06-01",
                max_tokens = 4096,
            },
        })
    end
}
