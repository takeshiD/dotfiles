return {
	"williamboman/mason-lspconfig.nvim",
	tag = "v1.32.0",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"clangd",
				"ruff",
				"pylsp",
				"pyright",
				"bashls",
				"cmake",
				"cssls",
				"html",
				"jsonls",
				"eslint",
				"markdown_oxide",
				"tailwindcss",
				"taplo",
				"vimls",
				"dprint",
				"ts_ls",
			},
		})
		local capabilities = require("blink.cmp").get_lsp_capabilities({
			textDocument = {
				completion = {
					completionItem = {
						snippetSupport = true,
					},
				},
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		})
		require("mason-lspconfig").setup_handlers({
			function(server_name)
				if server_name == "tsserver" then
					server_name = "ts_ls"
				end
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["tailwindcss"] = function()
				lspconfig.tailwindcss.setup({
					filetypes = {
						-- html
						"aspnetcorerazor",
						"astro",
						"astro-markdown",
						"blade",
						-- 'clojure',
						"django-html",
						"htmldjango",
						-- 'edge',
						"eelixir", -- vim ft
						"elixir",
						"ejs",
						"erb",
						"eruby", -- vim ft
						"gohtml",
						"gohtmltmpl",
						"haml",
						"handlebars",
						"hbs",
						"html",
						"htmlangular",
						"html-eex",
						"heex",
						"jade",
						"leaf",
						"liquid",
						-- 'markdown',
						"mdx",
						"mustache",
						"njk",
						"nunjucks",
						"php",
						"razor",
						"slim",
						"twig",
						-- css
						"css",
						"less",
						"postcss",
						"sass",
						"scss",
						"stylus",
						"sugarss",
						-- js
						"javascript",
						"javascriptreact",
						"reason",
						"rescript",
						"typescript",
						"typescriptreact",
						-- mixed
						-- 'vue',
						-- 'svelte',
						-- 'templ',
					},
				})
			end,
			["dprint"] = function()
				lspconfig.dprint.setup({
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"json",
						"jsonc",
						"markdown",
						-- 'python',
						"toml",
						-- 'rust',
						-- 'roslyn',
						-- 'graphql',
					},
				})
			end,
			["ts_ls"] = function()
				lspconfig.ts_ls.setup({
					single_file_support = false,
					root_dir = lspconfig.util.root_pattern("package.json"),
				})
			end,
			["denols"] = function()
				lspconfig.denols.setup({
					single_file_support = true,
					root_dir = lspconfig.util.root_pattern("deno.json"),
				})
			end,
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
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
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
								},
							},
						})
					end,
					settings = {
						Lua = {
							format = {
								enbale = true,
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
				})
			end,
			["pylsp"] = function()
				lspconfig.pylsp.setup({
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = { enabled = false },
								mccabe = { enabled = false },
								pyflakes = { enabled = false },
								pylint = { enabled = false },
								yapf = { enabled = false },
								autopep8 = { enabled = false },
								black = { enabled = false },
								rope_completion = { enabled = false },
								-- mypyとruffのみ使用, 型チェックはpyright
								mypy = { enabled = false },
								ruff = { enabled = true },
							},
						},
					},
				})
			end,
			rust_analyzer = function()
				lspconfig.rust_analyzer.setup({
					settings = {
						["rust-analyzer"] = {
							check = {
								command = "clippy",
							},
						},
					},
				})
			end,
			nil_ls = function()
				lspconfig.nil_ls.setup({
					settings = {
						["nil"] = {
							formatting = {
								command = { "nixfmt" },
							},
						},
					},
				})
			end,
		})
	end,
}
