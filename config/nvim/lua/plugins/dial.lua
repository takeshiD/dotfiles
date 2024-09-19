return {
    "monaqa/dial.nvim",
    -- enabled = false,
    keys = {
        {"<C-a>", function() require('dial.map').manipulate('increment', 'normal') end, mode = {"n"}},
        {"<C-x>", function() require('dial.map').manipulate('decrement', 'normal') end, mode = {"n"}},
        {"<C-a>", function() require('dial.map').manipulate('increment', 'visual') end, mode = {"v"}},
        {"<C-x>", function() require('dial.map').manipulate('decrement', 'visual') end, mode = {"v"}},
    },
}
