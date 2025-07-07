-- Color scheme is specified in init.lua
return {
    {
       "scottmckendry/cyberdream.nvim",
        lazy = false,
        enabled = false,
        priority = 1000,
    },
    {
        "sainnhe/everforest",
        lazy = false,
        enabled = false,
        priority = 1000,
    },
    {
        "RRethy/base16-nvim",
        enabled = false,
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd[[colorscheme base16-espresso]]
        end
    },
    {
        "EdenEast/nightfox.nvim",
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd[[colorscheme terafox]]
            require('nightfox').setup({
                options = {
                    transparent = true,
                }
            })
        end
    },
}
