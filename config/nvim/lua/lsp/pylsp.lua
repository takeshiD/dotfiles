return {
	cmd = { "pylsp" },
	filetypes = { "python" },
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
