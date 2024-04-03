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
"  gruvbox
" colorscheme gruvbox
" set background=dark
" let g:gruvbox_contrast_dark='hard'

" tokyonight
let g:tokyonight_style = 'night'
colorscheme tokyonight

"------ Airline ------
" let g:airline_theme = 'badwolf'
" let g:airline_theme = 'gruvbox'
let g:airline_theme = 'tokyonight'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
set ttimeoutlen=50
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

"------ NerdTree ------
let NERDTreeShowHidden = 1

"------ devicons ------
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['scm'] = '󰘧'
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\ 12
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif

"------ rainbow-parentheses -----
augroup rainbow_lisp
      autocmd!
        autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

"------ Encode ------
set fileformat=unix
set fileencoding=utf-8
set encoding=utf-8

"------ Format ------
set smartindent
set autoindent
set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
set cursorline

"------ Look&Feel ------
set list
set listchars=tab:\|\ ,eol:↲
set fillchars+=vert:│,fold:-,foldopen:─,foldclose:+
set hlsearch
set incsearch
set ruler
set number
set relativenumber
set diffopt=vertical
set cursorline
set cursorcolumn
set showmatch


"------ Keymaps ------
nnoremap <ESC><ESC> :noh<CR>
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
nnoremap <C-_> :Commentary<CR>
vnoremap <C-_> :Commentary<CR>
nnoremap <CR><CR> <C-w>w

"------ Misc ------
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set virtualedit=onemore
set visualbell
set laststatus=2
set wildmode=list:longest
set wildmenu
set clipboard=unnamedplus

""------ Neosnippet ------
"let g:deoplete#enable_at_startup = 1
"imap <C-k>  <Plug>(neosnippet_expand_or_jump)
"smap <C-k>  <Plug>(neosnippet_expand_or_jump)
"xmap <C-k>  <Plug>(neosnippet_expand_target)
"smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/snippets/,~/.vim/snippets'

""------ NeoComplete -----
"let g:neocomplete#enable_at_startup = 1

"------ Undo Persistent ------
if has('persistent_undo')
    let undo_path = expand("~/.vim/.undo")
    exe 'set undodir=' .. undo_path
    set undofile
endif

"------ Indent Guides ---------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 1
let g:indent_guides_color_change_percent = 3

"------ memolist ---------

