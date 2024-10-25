return {
    'nvim-tree/nvim-web-devicons',
    config = function()
        require('nvim-web-devicons').setup({
            override_by_extension = {
                ["toml"] = {
                    icon = "󰗴",
                    color = "#9c4221",
                    cterm_color = "124",
                    name = "Toml"
                }
            }
        })
    end
}
