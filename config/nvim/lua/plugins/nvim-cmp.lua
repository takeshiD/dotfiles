return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        local cmp = require("cmp")
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                -- ["<TAB>"] = cmp.mapping.select_next_item(),
                ["<C-j>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif vim.snippet.active({direction=1}) then
                        vim.schedule(function()
                            vim.snippet.jump(1)
                        end)
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, {"i", "s"}),
                ["<C-k>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif vim.snippet.active({direction=-1}) then
                        vim.schedule(function()
                            vim.snippet.jump(-1)
                        end)
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, {"i", "s"}),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources(
                {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "cmdline" },
                }
            ),
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            }
        })
    end
}
