return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.tsserver.setup {}
        lspconfig.eslint.setup {}
        lspconfig.tailwindcss.setup {}
        lspconfig.ruff.setup {}
        lspconfig.lua_ls.setup({
            on_init = function(client)
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                    return
                end
                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        version = "LuaJIT",
                        pathStrict = true,
                        path = { "?.lua", "?/init.lua" },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME
                        }
                    }
                })
            end,
            settings = {
                Lua = {
                    format = {
                        enbale = true,
                        defaultConfig = {
                            indent_style = "space",
                            indent_size = 4,
                        }
                    },
                    completion = {
                        enable = true,
                        autoRequire = true,
                        displayContext = true,
                    },
                    hint = {
                        enable = true,
                        arrayIndex = "Auto",
                        paramName = "All",
                        paramType = true,
                    },
                }
            }
        })
        lspconfig.rust_analyzer.setup({
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            on_attach = function(client, bufnr)
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
        })
    end
}
