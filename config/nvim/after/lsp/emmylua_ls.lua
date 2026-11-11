return {
    cmd = { "emmylua_ls" },
	filetypes = { "lua" },
	root_markers = { ".emmyrc.json", ".luarc.json", ".git" },
    settings = {
        emmylua_ls = {
            runtime = {
                version = "LuaJIT"
            }
        }
    }
}
