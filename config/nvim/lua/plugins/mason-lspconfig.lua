return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "clangd",
                "ruff",
                "pylsp",
                "bashls",
                "cmake",
                "cssls",
                "html",
                "jsonls",
                "eslint",
                "marksman",
                "tailwindcss",
                "taplo",
                "vimls",
                "denols",
                "ts_ls",
            }
        })
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                if server_name == "tsserver" then
                    server_name = "ts_ls"
                end
                lspconfig[server_name].setup({
                    capabilities = capabilities
                })
            end,
            ["denols"] = function()
                lspconfig.denols.setup({
                    single_file_support = true,
                    -- root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "tsconfig.json", "package.json", ".git")
                })
            end,
            -- ["ts_ls"] = function()
            --     lspconfig.denols.setup({
            --         root_dir = lspconfig.util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git')
            --     })
            -- end,
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
