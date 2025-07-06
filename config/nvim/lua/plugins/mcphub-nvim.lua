local function build_if()
    local ok, _ = pcall(vim.system, {"pnpm", "--version"})
    if ok then
        return "pnpm add -g mcp-hub@latest"
    end
    local ok, _ = pcall(vim.system, {"npm", "--version"})
    if ok then
        return "npm install -g mcp-hub@latest"
    end
    vim.notify("Error! pnpm, npm are not found.", vim.log.levels.ERROR)
    return nil
end
return {
    "ravitemer/mcphub.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Required for Job and HTTP requests
    },
    build = build_if(),
    config = function()
      require("mcphub").setup({
            extensions = {
                avante = {
                    make_slash_commands = true,
                }
            }
        })
    end,
}
