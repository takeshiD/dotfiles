return {
	-- cmd = { "pylsp" },
	-- filetypes = { "python" },
	-- root_markers = {
	-- 	"pyproject.toml",
	-- 	"setup.py",
	-- 	"setup.cfg",
	-- 	"requirements.txt",
	-- 	"Pipfile",
	-- 	".git",
	-- },
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
}
