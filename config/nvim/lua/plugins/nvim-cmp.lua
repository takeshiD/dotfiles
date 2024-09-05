return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "neovim/nvim-lspconfig",
    },
    opts = function(_, opts)
        local cmp = require('cmp')
        -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
        --     ["<Tab>"] = cmp.mapping(function(fallback)
        --         if cmp.visible() then
        --             cmp.select_next_item()
        --         elseif vim.snippet.active({direction = 1}) then
        --             vim.schedule(function()
        --                 vim.snippet.jump(1)
        --             end)
        --         end
        --     end, {"i", "s"})
        -- })
        cmp.setup()
    end,
}
