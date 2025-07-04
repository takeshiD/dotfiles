return {
    "lewis6991/hover.nvim",
    -- commit="140c4d0ae9397b76baa46b87c574f5377de09309",
    keys = {
        {"K", function() require("hover").hover() end, mode={"n"}, {desc = "LSP Diagnostics"}}
    },
    config = function()
        require("hover").setup({
            init = function()
                require('hover.providers.lsp')
                -- require('hover.providers.gh')
                -- require('hover.providers.gh_user')
                -- require('hover.providers.jira')
                -- require('hover.providers.dap')
                -- require('hover.providers.fold_preview')
                require('hover.providers.diagnostic')
                -- require('hover.providers.man')
                -- require('hover.providers.dictionary')
            end,
            preview_opts = {border = "single"},
            preview_window = true,
            title = true,
        })
    end,
}
