return {
	"delphinus/md-render.nvim",
	version = "*",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", version = "*" }, -- optional: file type icons in code blocks
		{ "delphinus/budoux.lua", version = "*" }, -- optional: CJK phrase-level line breaking
	},
	keys = {
		{ "<leader>mp", "<CMD>MdRender float<CR>", desc = "Markdown float" },
		{ "<leader>mt", "<CMD>MdRender toggle<CR>", desc = "Markdown toggle" },
		{ "<leader>mv", "<CMD>vert MdRenderSplit<CR>", desc = "Markdown split" },
	},
}
