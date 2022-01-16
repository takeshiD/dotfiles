"====================================================
" Configuration dein.vim
" dein.vim Path = ~/.vim/bundles/dein.vim 
"====================================================
if &compatible
    set nocompatible
endif

set runtimepath+=~/.vim/bundles/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.vim/bundles/dein')
    call dein#begin('~/.vim/bundles/dein')
        call dein#add('Shougo/dein.vim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
        call dein#add('vim-airline/vim-airline')
        call dein#add('vim-airline/vim-airline-themes')
        call dein#add('ryanoasis/vim-devicons')
        call dein#add('scrooloose/nerdtree')
        call dein#add('Shougo/neosnippet.vim')
        call dein#add('Shougo/neosnippet-snippets')
        call dein#add('Shougo/neocomplete.vim')
        call dein#add('thinca/vim-quickrun')
        call dein#add('tpope/vim-fugitive')
        call dein#add('airblade/vim-gitgutter')
        call dein#add('morhetz/gruvbox')
        call dein#add('w0ng/vim-hybrid')
    call dein#end()
    call dein#save_state()
endif
if dein#check_install()
    call dein#install()
endif
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
