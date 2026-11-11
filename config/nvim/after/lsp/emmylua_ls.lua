return {
    cmd = { "emmylua_ls" },
    filetypes = { "lua" },
    root_markers = { ".emmyrc.json", ".luarc.json", ".git" },
    workspace_required = true,
    settings = {
        runtime = {
            version = "LuaJIT",
        },
        diagnostics = {
            globals = { "vim" },
        },
        workspace = {
            library = {
                vim.env.VIMRUNTIME,
            },
        },
    },
}
