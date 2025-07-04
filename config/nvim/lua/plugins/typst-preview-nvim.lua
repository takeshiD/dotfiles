return {
	"chomosuke/typst-preview.nvim",
	lazy = false,
	ft = "typst",
	version = "1.*",
	opts = function()
        require('typst-preview').setup({
            port = 9090,
        })
    end
}
