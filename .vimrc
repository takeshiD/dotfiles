"====================================================
" Configuration dein.vim
" dein.vim Path = ~/.vim/bundles/dein.vim 
"====================================================
if &compatible
    set nocompatible
endif

" install dir {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" dein installation check {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" begin settings {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .toml file
  let s:rc_dir = expand('~/.vim')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'

  " read toml and cache
  call dein#load_toml(s:toml, {'lazy': 0})

  " end settings
  call dein#end()
  call dein#save_state()
endif
" }}}

" plugin installation check {{{
if dein#check_install()
  call dein#install()
endif
" }}}

" plugin remove check {{{
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}


" set runtimepath+=~/.vim/bundles/repos/github.com/Shougo/dein.vim
" if dein#check_install()
"     call dein#install()
" endif
" if dein#load_state('~/.vim/bundles/dein')
"     call dein#begin('~/.vim/bundles/dein')
"         call dein#add('Shougo/dein.vim')
"         call dein#add('roxma/nvim-yarp')
"         call dein#add('roxma/vim-hug-neovim-rpc')
"         call dein#add('vim-airline/vim-airline')
"         call dein#add('vim-airline/vim-airline-themes')
"         call dein#add('ryanoasis/vim-devicons')
"         call dein#add('scrooloose/nerdtree')
"         call dein#add('Shougo/neosnippet.vim')
"         call dein#add('Shougo/neosnippet-snippets')
"         call dein#add('Shougo/neocomplete.vim')
"         call dein#add('thinca/vim-quickrun')
"         call dein#add('tpope/vim-fugitive')
"         call dein#add('airblade/vim-gitgutter')
"         call dein#add('morhetz/gruvbox')
"         call dein#add('w0ng/vim-hybrid')
"     call dein#end()
"     call dein#save_state()
" endif
filetype plugin indent on
syntax on

"====================================================
" Deleting Plugin Step
" (1) commentout plugin row
" (2) write call map(dein#check_clean(), "delete(v:val, 'rf')") in .vimrc
" (3) vim cmd ':call dein#recache_runtimepath()'
" (4) enter in vim, delete plugin row, commentout call map...
"====================================================
"call map(dein#check_clean(), "delete(v:val, 'rf')")


"====================================================
" Utility Vim Configurations
"====================================================
"------ ColorScheme ------
syntax enable
set background=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark='hard'
autocmd FileType html colorscheme hybrid
autocmd FileType javascript colorscheme hybrid

"------ Airline ------
let g:airline_theme='base16'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
set ttimeoutlen=50

nnoremap <C-p> <Plug>AirlineSelectPrevTab
nnoremap <C-n> <Plug>AirlineSelectNextTab

"------ NerdTree ------
nnoremap <C-t> :NERDTreeToggle<CR>

"------ Quickrun ------
"let g:quickrun_config.cpp = {'command': 'g++', 'cmdopt': '-std=c++11'}

"------ Encode ------
set fileformat=unix
set fileencoding=utf-8

"------ Format ------
set smartindent
set autoindent
set showmatch
set expandtab
set tabstop=4
set shiftwidth=4
set cursorline
set number

"------ Look&Feel ------
set list
set listchars=tab:\|\ ,eol:$
set hlsearch
set incsearch
set ruler
set number
set diffopt=vertical
set cursorline
"------ Keymaps ------
nnoremap <ESC><ESC> :noh<CR>

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

"------ Neosnippet ------
imap <C-k>  <Plug>(neosnippet_expand_or_jump)
smap <C-k>  <Plug>(neosnippet_expand_or_jump)
xmap <C-k>  <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif

"------ Undo Persistent ------
if has('persistent_undo')
    let undo_path = expand("~/.vim/.undo")
    exe 'set undodir=' .. undo_path
    set undofile
endif
