return {
	name = "colorscheme-loader",
	dir = vim.fn.stdpath("config") .. "/lua/pseudo-plugins/",
	enabled = true,
	lazy = false,
	priority = 1001,
	config = function()
		vim.cmd.colorscheme("cyberdream")
		-- vim.cmd.colorscheme("carbonfox")
	end,
}
