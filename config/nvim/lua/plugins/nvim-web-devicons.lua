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
                },
                ["elv"] = {
                    icon = "󰘧",
                    color = "#008700",
                    cterm_color = "28",
                    name = "elvish"
                },
                ["tl"] = {
                    icon = "",
                    color = "#0099a4",
                    cterm_color = "39",
                    name = "teal"
                },
                ["nrs"] = {
                    icon = "",
                    color = "#9c4221",
                    cterm_color = "124",
                    name = "nrs"
                },
                ["mbt"] = {
                    icon = "󱩡",
                    color = "#b92482",
                    cterm_color = "126",
                    name = "moonbit",
                }
            }
        })
    end
}
