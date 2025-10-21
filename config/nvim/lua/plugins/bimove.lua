return {
    "kamecha/bimove",
    config = function()
        vim.keymap.set({"n"}, "M", "<Plug>(bimove-enter)<Plug>(bimove)")
        vim.keymap.set({"n"}, "<Plug>(bimove)k", "<Plug>(bimove-high)<Plug>(bimove)")
        vim.keymap.set({"n"}, "<Plug>(bimove)j", "<Plug>(bimove-low)<Plug>(bimove)")
		vim.api.nvim_set_hl(0, "BimoveHigh", { link="Search" })
		vim.api.nvim_set_hl(0, "BimoveLow", { link="Visual" })
		vim.api.nvim_set_hl(0, "BimoveCursor", { link="Visual" })
    end
}
