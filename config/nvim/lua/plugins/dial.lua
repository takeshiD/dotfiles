return {
    "monaqa/dial.nvim",
    enabled = false,
    -- config = function()
    --     local augend = require("dial.augend")
    --     require("dial.config").augends:register_group{
    --         default = {
    --             augend.integer.alias.decimal,
    --             augend.integer.alias.hex,
    --             augend.date.alias["%Y/%m/%d"],
    --         },
    --     }
    -- end,
    --
    keys = {
        {"<C-a>", ":lua require('dial.map').inc_normal()<CR>", mode = {"n"}},
        {"<C-x>", ":lua require('dial.map').dec_normal()<CR>", mode = {"n"}},
        {"<C-a>", ":lua require('dial.map').inc_visual()<CR>", mode = {"v"}},
        {"<C-x>", ":lua require('dial.map').dec_visual()<CR>", mode = {"v"}},
    }
}
