" Plugins
call plug#begin('~/.config/nvim/autoload/plugged')
    Plug 'sheerun/vim-polyglot' "Better Syntax Support
    Plug 'scrooloose/NERDTree' "File Explorer
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'jiangmiao/auto-pairs' "Auto pairs for '(' '[' '{'
    Plug 'scrooloose/syntastic'
    Plug 'tpope/vim-surround'
    Plug 'vim-airline/vim-airline' "Bottom Line information
    Plug 'vim-airline/vim-airline-themes' "Bottom Line information
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'mattn/emmet-vim'
    Plug 'scrooloose/nerdcommenter'
    Plug 'morhetz/gruvbox'

    "i dont know this plugins
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'ctrlpvim/ctrlp.vim' "fuzzy find files
    Plug 'HerringtonDarkholme/yats.vim'
call plug#end()

" General Settings
set encoding=UTF-8
filetype plugin indent on
syntax on
set number relativenumber
set backspace=indent,eol,start
set shiftwidth=4
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set expandtab
set noswapfile
colorscheme gruvbox

" Keymaping

" Custom Plugins
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
