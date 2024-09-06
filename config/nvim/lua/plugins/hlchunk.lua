return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("hlchunk").setup({
            chunk = {
                enable = true,
                use_treesitter = true,
                duration = 100,
                delay = 100,
            },
            indent = {
                enable = true,
                chars = {
                    "│",
                    "¦",
                    "┆",
                    "┊",
                }
            }
        })
    end
}
