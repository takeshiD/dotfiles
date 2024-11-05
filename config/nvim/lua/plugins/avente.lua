---環境変数envnameが存在する場合はtrue, しない場合はfalseを返す
---@param envname string
---@return boolean
local exist_envname = function(envname)
    return vim.fn.getenv(envname) ~= vim.NIL
end

---condがtrueの場合Tを返す condがfalseの場合Fを返す
---@param cond boolean
---@param T any
---@param F any
---@return any
local ternary = function(cond, T, F)
    if cond then return T else return F end
end

---述語predがtrueとなるlistの最初の要素を返す
---全ての要素がfalseの場合はnilを返す
---@generic T
---@param pred fun(item: T): boolean
---@param list T[]
---@return T | nil
local member_if = function(pred, list)
    for _, v in ipairs(list) do
        if pred(v) then
            return v
        end
    end
    return nil
end

---環境変数envnameが存在する場合は格納されている値を返す
---存在しない場合はFを返す
---@param envname string
---@param F string | nil
---@return string
local getenv_if = function(envname, F)
    F = F or nil
    return ternary(exist_envname(envname), vim.fn.getenv(envname), F)
end

local copilot_path = vim.fn.stdpath("data") .. "/avante/github-copilot.json"
local provider_apikey_map = {
    azure = "AZURE_OPENAI_API_KEY",
    claude = "ANTHROPIC_API_KEY",
    openai = "OPENAI_API_KEY",
}

---providersの中で最初に環境変数が設定されているproviderを返す
---先頭に設定されているproviderが優先されるためリストを並べ替えて優先度を設定する
---@param providers string[]
---@return string
local get_provider = function(providers)
    for _, provider in ipairs(providers) do
        local apikey_envname = provider_apikey_map[provider]
        provider = ternary(exist_envname(apikey_envname), provider, nil)
        if provider ~= nil then
            print("[LLM Provider] avante.nvim uses " .. string.upper(provider))
            return tostring(provider)
        end
    end
    error("The provider for which the api-key is set cannot be obtained.")
    return ""
end

return {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
        debug = false,
        provider = get_provider(
            {
                "azure",
                "claude",
                "openai",
                "gemini",
            }
        ),
        -- auto_suggestions_provider = "copilot",
        auto_suggestions_provider = get_provider(
            {
                "azure",
                "claude",
                "openai",
            }
        ),
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
            -- model = "claude-3-opus-20240229",  -- $15/$75, maxtokens=4096
            -- max_tokens = 4096,
            max_tokens = 8000,
        },
        copilot = {
            model = "gpt-4o-2024-05-13",
            -- model = "gpt-4o-mini",
            max_tokens = 4096,
        },
        openai = {
            model = "gpt-4o", -- $2.5/$10
            -- model = "gpt-4o-mini", -- $0.15/$0.60
            max_tokens = 4096,
        },
        azure = {
            endpoint = getenv_if("AZURE_OPENAI_ENDPOINT", ""),
            deployment = getenv_if("AZURE_OPENAI_DEPLOY", ""),
            api_version = "2024-06-01",
            max_tokens = 4096,
        },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- build = "make",
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
    },
}
