return {
    "nfrid/markdown-togglecheck",
    dependencies = { 'nfrid/treesitter-utils' },
    ft = {"markdown"},
    keys = {
        { "tt", ":lua require('markdown-togglecheck').toggle()<CR>", desc = "toggle checkbox"},
    }
}
