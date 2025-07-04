-- 環境に応じたビルドコマンドを設定する関数
local build_ = function()
	if vim.fn.has("win32") == 1 then
		return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
	else
		return "make"
	end
end

return {
	"yetone/avante.nvim",
	enabled = false,
	event = "VeryLazy",
	lazy = false,
	version = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua",
		{
			"takeshid/avante-status.nvim",
			-- dir = vim.fn.stdpath('data') .. '/develop/avante-status.nvim',
			-- dev = true,
			-- branch = 'feature',
			name = "avante-status.nvim",
			opts = {
				providers_map = {
					-- override default provider
					["claude-haiku"] = {
						type = "envvar",
						value = "ANTHROPIC_API_KEY",
						icon = "󰉁",
						highlight = "AvanteIconClaude",
						fg = "#ffd700",
						name = "Haiku",
					},
					claude = {
						name = "Sonnet",
					},
					openai = {
						name = "gpt-4o",
					},
					-- add custom provider
					phi4 = {
						type = "endpoint",
						value = "http://127.0.0.1:11434/v1/chat/completions",
						icon = "🦙",
						fg = "#ffffff",
						name = "Ollama/phi4",
						model = "phi4",
					},
					o1 = {
						type = "envvar",
						value = "OPENAI_API_KEY",
						icon = "󱗃",
						fg = "#76a89c",
						name = "o1",
					},
					["o1-mini"] = {
						type = "envvar",
						value = "OPENAI_API_KEY",
						icon = "󱢴",
						fg = "#f0ce18",
						name = "o1-mini",
					},
					["o3-mini"] = {
						type = "envvar",
						value = "OPENAI_API_KEY",
						icon = "󱑷",
						fg = "#57cdf5",
						name = "o3-mini",
					},
					["o4-mini"] = {
						type = "envvar",
						value = "OPENAI_API_KEY",
						icon = "󱑷",
						fg = "#a757a8",
						name = "o4-mini",
					},
					["gpt-4.1"] = {
						type = "envvar",
						value = "OPENAI_API_KEY",
						icon = "󱑷",
						fg = "#57cdf5",
						name = "gpt-4.1",
					},
					["gpt-4.1-mini"] = {
						type = "envvar",
						value = "OPENAI_API_KEY",
						icon = "󱑷",
						fg = "#ffd700",
						name = "gpt-4.1-mini",
					},
				},
			},
		},
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
	},
	build = build_(),
	opts = function()
		return {
			debug = false,
			provider = require("avante-status").get_chat_provider({
				"gpt-4.1",
				"claude",
				"o4-mini",
				"openai",
				"o3-mini",
				"azure",
			}),
			auto_suggestions_provider = require("avante-status").get_suggestions_provider({
				"gpt-4.1-mini",
				"claude-haiku",
				"azure",
				"copilot",
			}),
			cursor_applying_provider = "claude",
			behaviour = {
				auto_suggestions = true,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = true,
				support_paste_from_clipboard = true,
				enable_cursor_planning_mode = true,
				enable_claude_text_editor_tool_mode = true,
			},
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				return hub:get_active_servers_prompt()
			end,
			disabled_tools = {
				"rag_search",
				-- "list_files",
				-- "search_files",
				-- "search_keyword",
				-- "read_file_toplevel_symbol",
				-- "read_file",
				-- "create_file",
				-- "rename_file",
				-- "delete_file",
				-- "create_dir",
				-- "rename_dir",
				-- "delete_dir",
				-- "web_search",
				-- "view",
				-- "replace_in_file",
				-- "str_replace",
				-- "fetch",
			},
			custom_tools = function()
				return {
					require("mcphub.extensions.avante").mcp_tool(),
				}
			end,
			rag_service = {
				enabled = false,
				provider = "openai",
				host_mount = os.getenv("HOME"),
				llm_model = "gpt-4o",
				embed_model = "text-embedding-3-large",
				endpoint = "https://api.openai.com/v1",
				runner = "docker",
			},
			windows = {
				position = "right",
				width = 40,
				sidebar_header = {
					align = "center",
					rounded = false,
				},
				ask = {
					floating = true,
					start_insert = true,
					border = "rounded",
				},
			},
			claude = {
				model = "claude-3-7-sonnet-20250219",
				max_tokens = 64000,
			},
			["claude-haiku"] = {
				model = "claude-3-5-haiku-20241022",
				max_tokens = 8000,
			},
			copilot = {
				model = "gpt-4o-2024-05-13",
				max_tokens = 4096,
			},
			openai = {
				model = "gpt-4o",
				max_completion_tokens = 16384,
			},
			azure = {
				endpoint = require("avante-status").getenv_if("AZURE_OPENAI_ENDPOINT", ""),
				deployment = require("avante-status").getenv_if("AZURE_OPENAI_DEPLOY", ""),
				api_version = "2024-06-01",
				max_tokens = 4096,
			},
			providers = {
				phi4 = {
					__inherited_from = "openai",
					api_key_name = "",
					endpoint = "http://127.0.0.1:11434/v1",
					model = "phi4",
				},
				["o3-mini"] = {
					__inherited_from = "openai",
					endpoint = "https://api.openai.com/v1",
					model = "o3-mini",
					max_completion_tokens = 100000,
					reasoning_effort = "medium",
				},
				["o4-mini"] = {
					__inherited_from = "openai",
					endpoint = "https://api.openai.com/v1",
					model = "o4-mini",
					max_completion_tokens = 100000,
					reasoning_effort = "medium",
					disable_tools = { "python" },
				},
				["gpt-4.1"] = {
					__inherited_from = "openai",
					endpoint = "https://api.openai.com/v1",
					model = "gpt-4.1",
					max_completion_tokens = 32768,
				},
				["gpt-4.1-mini"] = {
					__inherited_from = "openai",
					endpoint = "https://api.openai.com/v1",
					model = "gpt-4.1-mini",
					max_completion_tokens = 32768,
				},
			},
		}
	end,
}
