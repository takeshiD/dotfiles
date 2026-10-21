return {
	{
		"kevinhwang91/nvim-hlslens",
		dependencies = {
			"haya14busa/vim-asterisk",
		},
		enabled = true,
		keys = {
			{
				mode = "n",
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				desc = "Next cadidate",
				noremap = true,
				silent = true,
			},
			{
				mode = "n",
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				desc = "Prev cadidate",
				noremap = true,
				silent = true,
			},
			{
				mode = "n",
				"*",
				[[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Match the word exactly on cursor",
				noremap = true,
				silent = true,
			},
			{
				mode = "n",
				"g*",
				[[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Match the word partialy on cursor",
				noremap = true,
				silent = true,
			},
		},
		opts = function()
			local maxRelIdx = 3
			require("hlslens").setup({
				override_lens = function(render, posList, nearest, idx, relIdx)
					local sfw = vim.v.searchforward == 1
					local indicator
					local absRelIdx = math.abs(relIdx)
					if 1 <= absRelIdx then
						local direction
						if sfw ~= (relIdx >= 1) then
							-- direction = "󰜷"
							direction = "N"
						else
							-- direction = "󰜮"
							direction = "n"
						end
						if absRelIdx <= maxRelIdx then
							indicator = ("%s"):format(direction:rep(absRelIdx))
						else
							indicator = ("%s+"):format(direction:rep(maxRelIdx))
						end
					else
						indicator = "󰜱"
					end

					local text, chunks
					local lnum, col = unpack(posList[idx])
					local cnt = #posList
					if nearest then
						if indicator ~= "" then
							text = ("❬%d/%d❭ %s "):format(idx, cnt, indicator)
						else
							text = ("❬%d/%d❭"):format(idx, cnt)
						end
						chunks = { { " " }, { text, "HlSearchLensNear" } }
					else
						text = ("❬%d/%d❭ %s "):format(idx, cnt, indicator)
						chunks = { { " " }, { text, "HlSearchLens" } }
					end
					render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
				end,
			})
			local function set_highlights()
				local color = require("functions.color")
				local incsearch_hl = vim.api.nvim_get_hl(0, { name = "IncSearch", link = false })
				vim.api.nvim_set_hl(0, "HlSearchLensNear", {
					fg = color.composeColor(incsearch_hl.fg, incsearch_hl.bg, 0.3),
					bg = color.composeColor(incsearch_hl.fg, incsearch_hl.bg, 0.8),
					bold = true,
				})
				local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
				vim.api.nvim_set_hl(0, "HlSearchLens", {
					fg = color.composeColor(incsearch_hl.fg, incsearch_hl.bg, 0.2),
					bg = color.composeColor(incsearch_hl.fg, incsearch_hl.bg, 0.4),
                    bold = false,
				})
			end
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = set_highlights,
			})

			set_highlights()
			local kopts = { noremap = true, silent = true }
			vim.keymap.set("n", "#", function()
				local current_word = vim.fn.expand("<cword>")
				vim.api.nvim_feedkeys(":%s/" .. current_word .. "//g", "n", false)
				-- :%s/word/CURSOR/g
				local ll = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
				vim.api.nvim_feedkeys(ll, "n", false)
				vim.opt.hlsearch = true
				require("hlslens").start()
			end, kopts)
		end,
	},
}
