return {
    "smjonas/inc-rename.nvim",
    keys = {
        { "gn", function() return ":IncRename " .. vim.fn.expand("<cword>") end, desc = "LSP Rename", mode = { "n" }, expr = true}
    },
    dependencies = {
        "stevearc/dressing.nvim"
    },
    config = function()
        require("inc_rename").setup({
            input_buffer_type = "dressing"
        })
    end,
}
