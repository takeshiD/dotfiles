"====================================================
" Configuration dein.vim
" dein.vim Path = ~/.vim/bundles/dein.vim 
"====================================================
if &compatible
    set nocompatible
endif

set runtimepath+=~/.vim/bundles/dein.vim

if dein#load_state('~/.vim/bundles')
    call dein#begin('~/.vim/bundles')
    call dein#add('~/.vim/bundles/dein.vim')
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('scrooloose/nerdtree')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/neocomplete.vim')
    if !has('nvim')
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif

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
set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
autocmd FileType python colorscheme badwolf
autocmd FIleType html colorscheme hybrid
autocmd FIleType javascript colorscheme hybrid

"------ Airline ------
let g:airline_theme='term'
let g:airline#extensions#tabline#enabled = 1
set ttimeoutlen=50

nnoremap <C-p> <Plug>AirlineSelectPrevTab
nnoremap <C-n> <Plug>AirlineSelectNextTab

"------ NerdTree ------
nnoremap <C-t> :NERDTreeToggle<CR>


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
set ruler
set number
set diffopt=vertical

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
