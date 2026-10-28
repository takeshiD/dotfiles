vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("core.keymap")
    end,
})

-- ############## Indent (oxfmt) ####################
-- .oxfmtrc.json(c) があるプロジェクトでは tabWidth / useTabs をインデント設定に反映する
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "javascript", "javascriptreact", "typescript", "typescriptreact",
        "json", "jsonc", "json5", "yaml", "toml", "css", "scss", "less",
        "html", "vue", "astro", "markdown", "graphql",
    },
    callback = function(args)
        local names = { ".oxfmtrc.json", ".oxfmtrc.jsonc" }
        local root = vim.fs.root(args.buf, names)
        if not root then
            return
        end
        -- oxfmt の既定値
        local config = { tabWidth = 2, useTabs = false }
        for _, name in ipairs(names) do
            local path = vim.fs.joinpath(root, name)
            if vim.uv.fs_stat(path) then
                local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"), { skip_comments = true })
                if ok and type(decoded) == "table" then
                    config = vim.tbl_extend("force", config, decoded)
                end
                break
            end
        end
        local bo = vim.bo[args.buf]
        bo.expandtab = not config.useTabs
        bo.tabstop = config.tabWidth
        bo.shiftwidth = config.tabWidth
        bo.softtabstop = config.tabWidth
    end,
})

-- ############## Folding ####################
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        local bufname = vim.fn.expand('%')
        local buftype = vim.bo.buftype
        if bufname ~= '' and not string.match(buftype, 'nofile') then
            vim.cmd('mkview')
        end
    end
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function()
        local bufname = vim.fn.expand('%')
        local buftype = vim.bo.buftype
        if bufname ~= '' and not string.match(buftype, 'nofile') then
            vim.cmd('silent! loadview')
        end
    end
})
