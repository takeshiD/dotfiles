return {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    enabled = true,
    priority = 1020, -- needs to be loaded in first
    opts = {
        enabled = true,
        message_template = " <author> '<summary>' : <date>",
        date_format = "%r (%Y-%m-%d %H:%M:%S)",
        message_when_not_commited = " Not Commited Yet",
        display_virtual_text = 1,
    },
}
