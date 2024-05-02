"====================================================
" Configuration dein.vim
"====================================================
if &compatible
    set nocompatible
endif

"------ install dir ------
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

"------ dein installation check -------
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif

"------ begin settings ------
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  "--- toml file ---
  let s:rc_dir = expand('~/.vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'

  "--- read toml and cache ---
  call dein#load_toml(s:toml, {'lazy': 0})

  "---- end settings ---
  call dein#end()
  call dein#save_state()
endif

"------ plugin installation check ------
if dein#check_install()
  call dein#install()
endif

"------ plugin remove check ------
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif

filetype plugin indent on
syntax on

"====================================================
" Utility Vim Configurations
"====================================================
"------ ColorScheme ------
syntax enable
" True Color
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " 文字色
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" " 背景色

" gruvbox
" set background=dark
" let g:gruvbox_contrast_dark='hard'
" colorscheme gruvbox

" tokyonight
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
let g:tokyonight_transparent_background = 0
let g:tokyonight_cursor = 'auto'
colorscheme tokyonight

"------ Lightline -----
let g:lightline = { 'colorscheme' : 'tokyonight'}
" let g:lightline = { 'colorscheme' : 'gruvbox'}
let g:lightline.active = {
            \ 'left':[['mode', 'paste'],
            \         ['gitbranch'],
            \         ['filenamestatus']],
            \ 'right':[['lineinfo'],
            \          ['fileformat','fileencoding','filetype']]
            \}
let g:lightline.inactive = {
            \ 'left':[['filename']],
            \ 'right':[['fileformat','fileencoding','filetype']]
            \}
let g:lightline.tabline = {
            \ 'left':[['buffers']],
            \ 'right':[['close']]
            \}
let g:lightline.separator = {'left': "\<Char-0xe0b0>", 'right': "\<Char-0xe0b2>"}
let g:lightline.subseparator = {'left': "\<Char-0xe0b1>", 'right': "\<Char-0xe0b3>"}
let g:lightline.mode_map = {
            \ 'n' : "\<Char-0xf01be> NORMAL",
            \ 'i' : "\<Char-0xf03eb> INSERT",
            \ 'R' : "\<Char-0xf021> REPLACE",
            \ 'v' : "\<Char-0xf0ad9> VISUAL",
            \ 'V' : "\<Char-0xf0ad9> V-LINE",
            \ "\<C-v>": "\<Char-0xf0ad9> V-LINE",
            \ 'c' : 'COMMAND',
            \ 's' : 'SELECT',
            \ 'S' : 'S-LINE',
            \ "\<C-s>": 'S-BLOCK',
            \ 't': 'TERMINAL',
            \ }

let g:lightline.component_expand = {
            \ 'gitbranch': 'LightlineGitbranch',
            \ 'filenamestatus': 'LightlineFilenameAndStatus',
            \ 'lineinfo': 'LightlineLineInfo',
            \ 'buffers': 'lightline#bufferline#buffers',
            \ 'filetype': 'LightlineFileType',
            \}
let g:lightline.component_type = {
            \ 'buffers': 'tabsel'
            \}

let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#enable_nerdfont = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#smart_path  = 0
let g:lightline#bufferline#modified = " [+]"
let g:lightline#bufferline#read_only = " [RO]"
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#show_number = 1

function! LightlineGitbranch() abort
    if exists('*FugitiveHead')
        let branch = FugitiveHead()
        if empty(branch)
            return ''
        else
            return "\<Char-0xf062c> " . branch
        endif
    endif
endfunction

function! LightlineFilenameAndStatus() abort
    let filename = @%
    let filename = empty(filename) ? '[No Name]' : filename
    let status = &modified ? '[+]' : 
                \&readonly ? '[RO]':
                \ ''
    return l:filename . ' ' . l:status
endfunction

function! LightlineLineInfo() abort
    return "\<Char-0xe0a1>%l/%L \<Char-0xe0a3>%c"
endfunction

function! LightlineFileType() abort
    return WebDevIconsGetFileTypeSymbol(fnamemodify(@%,':t')) . ' ' . &ft
endfunction

augroup LightlineUpdate
    autocmd!
    autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
augroup END

"------ NerdTree ------
let NERDTreeShowHidden = 1
let NERDTreeWinSize = 20
nnoremap <C-e> :NERDTreeToggle<CR>

"------ devicons ------
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['scm'] = '󰘧'
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

"------ rainbow-parentheses -----
augroup rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

"------ GitGutter -----------------------
let g:gitgutter_sign_added = "❚"                            " ❚ 
let g:gitgutter_sign_modified = "❚"                         " ❚
let g:gitgutter_sign_removed = "\<Char-0xf44a>"             " 
let g:gitgutter_sign_removed_first_line = "\<Char-0xf44b>"  " 
let g:gitgutter_sign_removed_above_and_below = '{'
let g:gitgutter_sign_modified_removed = "\<Char-0xf0dbb>"
let g:gitgutter_enabled = 1
nnoremap g] :GitGutterNextHunk<CR>
nnoremap g[ :GitGutterPrevHunk<CR>
nnoremap gp :GitGutterPreviewHunk<CR>
nnoremap gt :GitGutterToggle<CR>
nnoremap gs <Plug>(GitGutterStageHunk)
nnoremap gu <Plug>(GitGutterUndoHunk)

"------ Commentary -------
nnoremap <C-_> :Commentary<CR>
vnoremap <C-_> :Commentary<CR>

"------ Indent Guides ---------
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 1

"------ vim-lsp --------
nnoremap <F1> <plug>(lsp-hover-float)
nnoremap <F1><F1> <plug>(lsp-hover-preview)
nnoremap <F2> <plug>(lsp-peek-definition)
nnoremap <F2><F2> <plug>(lsp-definition)
nnoremap <F3> <plug>(lsp-peek-declaration)
nnoremap <F3><F3> <plug>(lsp-declaration)
nnoremap <F4> <plug>(lsp-references)
nnoremap <C-j> <plug>(lsp-next-reference)
nnoremap <C-k> <plug>(lsp-previous-reference)
let g:lsp_peek_alignment = 'bottom'
let g:lsp_auto_enable = 1

"------ asyncomplete --------
let g:asyncomplete_auto_popup = 1
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

"------- colortips.vim -------
let g:colortips_left_visible = 1
let g:colortips_left_char = "\<Char-0xe22b> " ":
let g:colortips_right_visible = 0
let g:colortips_right_char = "\<Char-0xe22b>" ":
let g:colortips_fill_visible = 1

"------ Keymaps ------
let mapleader = "\<Space>"
nnoremap <ESC><ESC> :noh<CR>
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
noremap <CR><CR> <C-w>w
inoremap jj <ESC>
nnoremap <C-p> :bprev<CR>
nnoremap <C-n> :bnext<CR>
nnoremap <C-w>w :bdelete %<CR>

"------ Encode ------
set fileformat=unix
set fileencoding=utf-8
set encoding=utf-8

"------ Format ------
set smartindent
set autoindent
set showmatch
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4

"------ Look&Feel ------
set list
set listchars=tab:›—,eol:↲,nbsp:*,
set fillchars+=vert:│,fold:-,foldopen:─,foldclose:+
set hlsearch
set incsearch
set ruler
set number
set relativenumber
set diffopt=vertical
set showmatch
set showtabline=2
set laststatus=2
set nofoldenable
" set cursorline
" set cursorcolumn
if has('win64')
    set guifont=HackGenNerd\ Console:h14
    set guifontwide=HackGenNerd\ Console:h14
else
    set guifont=HackGenNerd\ Console\ 14
    set guifontwide=HackGenNerd\ Console\ 14
endif

"------ Misc ------
set nobackup
set noswapfile
set autoread
set hidden
set showcmd
set virtualedit=onemore
set visualbell
set wildmode=list:longest
set wildmenu
set clipboard=unnamedplus
set synmaxcol=200
set helplang=ja,en
"------ Undo Persistent ------
if has('persistent_undo')
    let undo_path = expand("~/.vim/.undo")
    exe 'set undodir=' .. undo_path
    set undofile
endif

"------ Indent Guides ---------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 1

"====================================================
" Functions
"====================================================
command! Profile call s:command_profile()
command! -nargs=1 -complete=help Vhelp :vertical belowright help <args>
function! s:command_profile() abort
    profile start ~/log/profile.log
    profile func *
    profile file *
endfunction

" Usage: $ vim +'call ProfileCursorMove()' <カーソルを動かすのが重いファイル>
function! ProfileCursorMove() abort
    let profile_file = expand('~/log/profile-cursor.log')
    if filereadable(profile_file)
        call delete(profile_file)
    endif
    normal! gg
    normal! zR
    execute 'profile start ' . profile_file
    profile func *
    profile file *
    augroup ProfileCursorMove
        autocmd!
        autocmd CursorHold <buffer> profile pause | q
    augroup END
    for i in range(500)
        call feedkeys('j')
    endfor
endfunction

set modeline
