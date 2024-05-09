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

"------ fern ------
let g:fern#renderer = "nerdfont"
let g:fern#default_hidden = 1
" let g:fern#logfile = expand('~/fern.log')
" let g:fern#loglevel = g:fern#DEBUG
nnoremap <C-e> :Fern . -drawer -width=30 -toggle -reveal=%<CR>
function! s:init_fern() abort
    nmap <buffer> r <Plug>(fern-action-reload:cursor)
    nmap <buffer> R <Plug>(fern-action-reload:all)
    nmap <buffer> v <Plug>(fern-action-open:vsplit)
    nmap <buffer> s <Plug>(fern-action-open:split)
    nmap <buffer> f <Plug>(fern-action-focus:parent)
    nmap <buffer><expr>
                \ <Plug>(fern-my-recursive-collapse)
                \ fern#smart#leaf(
                \   "\<Plug>(fern-action-collapse)",
                \   "\<Plug>(fern-action-expand-tree:stay)",
                \   "\<Plug>(fern-action-collapse)",
                \ )
    nmap <buffer><nowait> O <Plug>(fern-my-recursive-collapse)
    nmap <buffer><expr>
                \ <Plug>(fern-my-open-or-expand-or-collapse)
                \ fern#smart#leaf(
                \   "\<Plug>(fern-action-open)",
                \   "\<Plug>(fern-action-expand:stay)",
                \   "\<Plug>(fern-action-collapse)",
                \ )

    nmap <buffer><nowait> o <Plug>(fern-my-open-or-expand-or-collapse)
endfunction

augroup fern-custom
    autocmd! *
    autocmd FileType fern call s:init_fern()
augroup END

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
nnoremap <F2> <plug>(lsp-peek-definition)
nnoremap <F3> <plug>(lsp-peek-declaration)
nnoremap <F4> <plug>(lsp-references)
nnoremap <C-j> <plug>(lsp-next-reference)
nnoremap <C-k> <plug>(lsp-previous-reference)
let g:lsp_auto_enable = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_curosr = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 500
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_highlights_delay = 200
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_signs_delay = 500
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_delay = 100
let g:lsp_document_code_action_signs_enabled = 1
let g:lsp_document_code_action_signs_delay = 200
let g:lsp_inlay_hints_enabled = 1
let g:lsp_inlay_hints_delay = 100
highlight link lspInlayHintsType Grey
highlight link lspInlayHintsParameter Grey
let g:lsp_peek_alignment = 'bottom'
let g:lsp_use_native_client = 1
let g:lsp_document_symbol_detail = 1

function! My_supported_capabilities(server_info) abort
    return {
    \   'textDocument': {
    \       'callHierarchy': {
    \           'dynamicRegistration': v:false,
    \       },
    \       'codeAction': {
    \         'dynamicRegistration': v:false,
    \         'codeActionLiteralSupport': {
    \           'codeActionKind': {
    \             'valueSet': ['', 'quickfix', 'refactor', 'refactor.extract', 'refactor.inline', 'refactor.rewrite', 'source', 'source.organizeImports'],
    \           }
    \         },
    \         'isPreferredSupport': v:true,
    \         'disabledSupport': v:true,
    \       },
    \       'codeLens': {
    \           'dynamicRegistration': v:false,
    \       },
    \       'completion': {
    \           'dynamicRegistration': v:true,
    \           'completionItem': {
    \              'documentationFormat': ['markdown', 'plaintext'],
    \              'snippetSupport': v:true,
    \              'resolveSupport': {
    \                  'properties': ['additionalTextEdits']
    \              }
    \           },
    \           'completionItemKind': {
    \              'valueSet': lsp#omni#get_completion_item_kinds()
    \           }
    \       },
    \       'declaration': {
    \           'dynamicRegistration': v:true,
    \           'linkSupport' : v:true
    \       },
    \       'definition': {
    \           'dynamicRegistration': v:true,
    \           'linkSupport' : v:true
    \       },
    \       'documentHighlight': {
    \           'dynamicRegistration': v:false,
    \       },
    \       'documentSymbol': {
    \           'dynamicRegistration': v:true,
    \           'symbolKind': {
    \              'valueSet': lsp#ui#vim#utils#get_symbol_kinds()
    \           },
    \           'hierarchicalDocumentSymbolSupport': v:true,
    \           'labelSupport': v:true
    \       },
    \       'foldingRange': {
    \           'dynamicRegistration': v:false,
    \           'lineFoldingOnly': v:true,
    \           'rangeLimit': 5000,
    \       },
    \       'formatting': {
    \           'dynamicRegistration': v:false,
    \       },
    \       'hover': {
    \           'dynamicRegistration': v:false,
    \           'contentFormat': ['markdown', 'plaintext'],
    \       },
    \       'inlayHint': {
    \           'dynamicRegistration': v:true,
    \       },
    \       'implementation': {
    \           'dynamicRegistration': v:false,
    \           'linkSupport' : v:true
    \       },
    \       'publishDiagnostics': {
    \           'relatedInformation': v:true,
    \       },
    \       'rangeFormatting': {
    \           'dynamicRegistration': v:false,
    \       },
    \       'references': {
    \           'dynamicRegistration': v:true
    \       },
    \       'rename': {
    \           'dynamicRegistration': v:false,
    \           'prepareSupport': v:true,
    \           'prepareSupportDefaultBehavior': 1
    \       },
    \       'semanticTokens': {
    \           'dynamicRegistration': v:false,
    \           'requests': {
    \               'range': v:false,
    \               'full': lsp#internal#semantic#is_enabled()
    \                     ? {'delta': v:true}
    \                     : v:false
    \
    \           },
    \           'tokenTypes': [
    \               'type', 'class', 'enum', 'interface', 'struct',
    \               'typeParameter', 'parameter', 'variable', 'property',
    \               'enumMember', 'event', 'function', 'method', 'macro',
    \               'keyword', 'modifier', 'comment', 'string', 'number',
    \               'regexp', 'operator'
    \           ],
    \           'tokenModifiers': [],
    \           'formats': ['relative'],
    \           'overlappingTokenSupport': v:false,
    \           'multilineTokenSupport': v:false,
    \           'serverCancelSupport': v:false
    \       },
    \       'signatureHelp': {
    \           'dynamicRegistration': v:true,
    \       },
    \       'synchronization': {
    \           'didSave': v:true,
    \           'dynamicRegistration': v:false,
    \           'willSave': v:false,
    \           'willSaveWaitUntil': v:false,
    \       },
    \       'typeDefinition': {
    \           'dynamicRegistration': v:true,
    \           'linkSupport' : v:true
    \       },
    \       'typeHierarchy': {
    \           'dynamicRegistration': v:true
    \       },
    \   },
    \   'window': {
    \       'workDoneProgress': g:lsp_work_done_progress_enabled ? v:true : v:false,
    \   },
    \   'workspace': {
    \       'applyEdit': v:true,
    \       'configuration': v:true,
    \       'symbol': {
    \           'dynamicRegistration': v:true,
    \       },
    \       'workspaceFolders': g:lsp_experimental_workspace_folders ? v:true : v:false,
    \   },
    \ }
endfunction
let g:lsp_get_supported_capabilities = [function('My_supported_capabilities')]

"------ vim-lsp-settings --------
" none
"------ asyncomplete --------
let g:asyncomplete_auto_popup = 1
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

"------ vista.vim ------
let g:vista_default_executive = 'ctags'
let g:vista_icon_indent = ["▶ ", ""]
let g:vista_sidebar_position = 'vertical topleft'
let g:vista_sidebar_width = 30
let g:vista_sidebar_keepalt = 1
let g:vista_echo_cursor_strategy = 'scroll'
let g:vista_cursor_delay = '100'
let g:vista_log_file = expand('~/vista.log')
let g:vista#renderer#enable_icon = 1
nnoremap <C-f> :<C-u>Vista!!<CR>
nnoremap <F1> :<C-u>Vista finder<CR>

"------- colortips.vim -------
let g:colortips_left_char = " "
let g:colortips_right_char = " "
let g:colortips_left_visible = v:true
let g:colortips_right_visible = v:false
let g:colortips_fill_visible = v:true

"------- vim-anzu -------
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
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
nnoremap <C-w><C-w> :bdelete %<cr>
noremap L $

"------ encode ------
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
