return {
	"ThePrimeagen/harpoon",
	enabled = true,
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = function()
		local harpoon = require("harpoon")
		-- REQUIRED
		harpoon:setup()
		-- REQUIRED
		vim.keymap.set("n", "ma", function()
            vim.notify("[hapoon] Add mark", vim.log.levels.INFO)
			harpoon:list():add()
		end)
		vim.keymap.set("n", "mm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, {desc = "Open hapoon quick menu"})
	end,
}
