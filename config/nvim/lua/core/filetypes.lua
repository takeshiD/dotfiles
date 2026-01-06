vim.filetype.add({
    extension = {
        nrs = "nrs",
        mbt = "moonbit",
        mdx = "mdx",
    }
})
vim.treesitter.language.register("markdown", "mdx")
