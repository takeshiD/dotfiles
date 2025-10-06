return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                return
            end
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
                    -- "lua",
                    -- "${3rd}/luv/library"
				},
			},
		})
	end,
	settings = {
		Lua = {
			completion = {
				enable = false,
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
			format = { -- use stylua via nil-ls
				enbale = false,
				defaultConfig = {
					indent_style = "space",
					indent_size = 4,
				},
			},
            diagnostics = { -- use typua
                enable = true,
                -- disable = {
                --     "assign-type-mismatch",
                --     "param-type-mismatch",
                --     "return-type-mismatch",
                --     "undefined-field",
                -- }
                globals = {
                    "vim"
                }
            }
		},
	},
}
