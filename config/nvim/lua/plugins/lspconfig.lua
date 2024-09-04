return {
    "neovim/nvim-lspconfig",
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.rust_analyzer.setup{}
        lspconfig.tsserver.setup{}
        lspconfig.eslint.setup{}
        lspconfig.tailwindcss.setup{}
        lspconfig.ruff.setup{}
        lspconfig.lua_ls.setup({
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    pathStrict = true,
                    path = {"?.lua", "?/init.lua"},
                },
                workspace = {
                    library = vim.list_extend(
                        vim.api.nvim_get_runtime_file("lua", true), 
                        {
                            "${3rd}/luv/library",
                            "${3rd}/busted/library",
                            "${3rd}/luassert/library",
                        }
                    ),
                    checkThirdParty = "Disable",
                },
            }
        })
    end
}
