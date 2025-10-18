return {
	"haya14busa/vim-edgemotion",
	enaled = true,
	config = function()
		vim.keymap.set({ "n" }, "<C-j>", function()
			return "m`" .. vim.fn["edgemotion#move"](1)
		end, { silent = true, expr = true })
		vim.keymap.set({ "o", "x" }, "<C-j>", function()
			return vim.fn["edgemotion#move"](1)
		end, { silent = true, expr = true })
		vim.keymap.set({ "n" }, "<C-k>", function()
			return "m`" .. vim.fn["edgemotion#move"](0)
		end, { silent = true, expr = true })
		vim.keymap.set({ "o", "x" }, "<C-k>", function()
			return vim.fn["edgemotion#move"](0)
		end, { silent = true, expr = true })
	end,
}
