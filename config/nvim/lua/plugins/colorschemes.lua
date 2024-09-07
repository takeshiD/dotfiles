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
        priority = 1000,
    },
    {
        "tinted-theming/base16-vim",
        lazy = false,
        priority = 1000,
        -- config = function()
        --     vim.cmd[[colorscheme base16-espresso]]
        -- end
    },
}
