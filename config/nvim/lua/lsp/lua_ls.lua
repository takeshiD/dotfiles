return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
			return
		end
		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				pathStrict = true,
				path = { "?.lua", "?/init.lua" },
			},
			workspace = {
				checkThirdParty = "Disable",
				library = {
					vim.env.VIMRUNTIME,
                    "lua",
                    "${3rd}/luv/library"
				},
			},
		})
	end,
	settings = {
		Lua = {
			format = {
				enbale = false,
				defaultConfig = {
					indent_style = "space",
					indent_size = 4,
				},
			},
			completion = {
				enable = true,
				autoRequire = true,
				displayContext = true,
			},
			hint = {
				enable = true,
				arrayIndex = "Auto",
				paramName = "All",
				paramType = true,
				setType = true,
			},
		},
	},
}
