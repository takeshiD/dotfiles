return {
    "williamboman/mason.nvim",
    config = function()
        require("mason").setup({
            ui = {
                check_outdated_pakcages_on_open = false,
                border = "single"
            },
        })
    end
}
