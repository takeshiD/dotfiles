return {
    "monaqa/dial.nvim",
    -- enabled = false,
    keys = {
        { "<C-s>",  function() require('dial.map').manipulate('increment', 'normal') end,  mode = { "n" } },
        { "<C-x>",  function() require('dial.map').manipulate('decrement', 'normal') end,  mode = { "n" } },
        { "g<C-s>", function() require('dial.map').manipulate('increment', 'gnormal') end, mode = { "n" } },
        { "g<C-x>", function() require('dial.map').manipulate('decrement', 'gnormal') end, mode = { "n" } },
        { "<C-s>",  function() require('dial.map').manipulate('increment', 'visual') end,  mode = { "v" } },
        { "<C-s>",  function() require('dial.map').manipulate('decrement', 'visual') end,  mode = { "v" } },
        { "g<C-s>", function() require('dial.map').manipulate('increment', 'gvisual') end, mode = { "v" } },
        { "g<C-x>", function() require('dial.map').manipulate('decrement', 'gvisual') end, mode = { "v" } },
    },
    config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:register_group{
            default = {
                augend.integer.alias.decimal,
                augend.integer.alias.hex,
                augend.date.alias["%Y/%m/%d"],
                augend.date.alias["%m/%d"],
                augend.date.alias["%H:%M"],
                augend.constant.alias.ja_weekday_full,
                augend.constant.alias.ja_weekday,
                augend.constant.alias.bool,
            },
        }
        require("dial.config").augends:on_filetype {
            python = {
                augend.constant.new{
                    elements = {"True", "False"},
                    word = false,
                    cyclic = true,
                }
            },
            markdown = {
                augend.misc.alias.markdown_header,
            }
        }
    end
}
