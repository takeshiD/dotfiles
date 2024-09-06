return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local lspconfig = require("lspconfig")
        require("mason").setup()
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                if server_name == "tsserver" then
                    server_name = "ts_ls"
                end
                lspconfig[server_name].setup({})
            end,
            ["lua_ls"] = function()
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
            end,
        })
    end
}
