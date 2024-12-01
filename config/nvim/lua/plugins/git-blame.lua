return {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
        enabled = true,
        message_template = " <author> '<summary>' : <date>",
        date_format = "%r (%Y-%m-%d %H:%M:%S)",
        message_when_not_commited = " Not Commited Yet",
        virtual_text_column = 60,
        display_virtual_text = 1,
    },
}
