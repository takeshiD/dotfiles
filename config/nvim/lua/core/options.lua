local opt = vim.opt

--############ Encode&Format ###########
vim.scriptencoding = "utf-8"

--############ OperationBehavior ###########
opt.updatetime = 100
opt.clipboard = { "unnamed", "unnamedplus" }
opt.mouse = 'a' --マウス操作を有効化
opt.updatetime = 300
opt.swapfile = false --スワップファイルを生成しない
opt.backup = false

--############ Look&Feel ###########
--===== Colors =====
opt.hlsearch = true
opt.termguicolors = true

--===== Indent&Tab&Space =====
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.showtabline = 4

--===== Linenumber =====
vim.wo.number = true
vim.wo.relativenumber = true
opt.number = true
opt.signcolumn = 'yes' --行数表示の横に余白を追加

--====== ControlCharacters =====
opt.list = true
opt.listchars = {
    tab = "↦ ",
    eol = "↲",
}

--====== Commandline ======
opt.showcmd = true
opt.showmode = false
opt.cmdheight = 1
opt.laststatus = 2

--====== MISC =====
opt.title = true
-- opt.scrolloff = 10
opt.shell = 'bash'
opt.inccommand = 'split'
opt.ignorecase = true 
opt.wrap = true 
opt.helplang = 'ja', 'en'
opt.hidden = true
opt.wrap = true --端までコードが届いた際に折り返す