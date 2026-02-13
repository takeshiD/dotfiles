return {
	name = "colorscheme-loader",
	dir = vim.fn.stdpath("config") .. "/lua/pseudo-plugins/",
	enabled = true,
	lazy = false,
	priority = 1001,
	config = function()
		-- vim.cmd.colorscheme("onedark")
		-- vim.cmd.colorscheme("bluloco")
		vim.cmd.colorscheme("cyberdream")
		-- vim.cmd.colorscheme("carbonfox")
		-- vim.cmd.colorscheme("flow")
		-- vim.cmd.colorscheme("eldritch")
		-- vim.cmd.colorscheme("oxocarbon")
	end,
}
