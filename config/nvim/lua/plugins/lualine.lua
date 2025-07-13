return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"takeshid/avante-status.nvim",
	},
	config = function()
		local lualine = require("lualine")
		local lsp_component = {
			function()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients == 0 then
					return "LSP Inactive"
				end
				local ft = vim.bo.filetype
				local buf_client_names = {}
				for _, client in pairs(clients) do
					if client.name ~= "copilot" and client.name ~= "null-ls" then
						table.insert(buf_client_names, client.name)
					end
				end
				-- This needs to be a string only table so we can use concat below
				local unique_client_names = {}
				for _, client_name_target in ipairs(buf_client_names) do
					local is_duplicate = false
					for _, client_name_compare in ipairs(unique_client_names) do
						if client_name_target == client_name_compare then
							is_duplicate = true
						end
					end
					if not is_duplicate then
						table.insert(unique_client_names, client_name_target)
					end
				end
				local client_names_str = table.concat(unique_client_names, ", ")
				local language_servers = string.format("%s", client_names_str)
                local icon = require("nvim-web-devicons").get_icon_by_filetype(ft)
				return icon .. " " .. language_servers
			end,
			color = { fg = "#FF8800" },
		}
		local project_root = {
			function()
				return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			end,
			icon = "",
			separator = "›",
		}
		local config = {
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = "",
				section_separators = { left = "", right = "" },
				globalstatus = true,
				refresh = {
					statusline = 500,
					tabline = 500,
					winbar = 500,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { project_root, "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					lsp_component,
					-- require('avante-status.lualine').chat_component,
					-- require('avante-status.lualine').suggestions_component,
					-- require('mcphub.extensions.lualine'),
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		}
		lualine.setup(config)
	end,
}
