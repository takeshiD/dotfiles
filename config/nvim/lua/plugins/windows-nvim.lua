return {
	"anuvyklack/windows.nvim",
    enabled = true,
    lazy = false,
	dependencies = {
		"anuvyklack/middleclass",
		"anuvyklack/animation.nvim",
	},
    keys = {
        {"<C-w>z", "<cmd>WindowsMaximize<cr>", mode = {"n"}, desc = "Window Maximize"},
        {"<C-w>_", "<cmd>WindowsMaximizeVertically<cr>", mode = {"n"}, desc = "Window Maximize Vertical"},
        {"<C-w>|", "<cmd>WindowsMaximizeHorizontally<cr>", mode = {"n"}, desc = "Window Maximize Horizontal"},
        {"<C-w>=", "<cmd>WindowsEqualize<cr>", mode = {"n"}, desc = "Window Equalize"},
        {"<C-w>t", "<cmd>WindowsToggleAutowidth<cr>", mode = {"n"}, desc = "Window Toggle Autowidth"},
    },
	config = function()
		vim.o.winwidth = 10     -- Minimum current window width
        vim.o.winminwidth = 10  -- Minimum window width other than current window
		vim.o.equalalways = false
		require("windows").setup({
            autowidth = {
                enable = true,
                winwidth = 0.5,
                filetype = {
                    help = 2,
                },
            },
            animation = {
                enable = true,
                duration = 200,
                fps = 30,
                easing = "in_out_quad"
            }
        })
	end,
}
