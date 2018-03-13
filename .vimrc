set nocompatible              " required
filetype on                  " required
" syntax enable
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'bad-whitespace'
Plugin 'nvie/vim-flake8'
Plugin 'avakhov/vim-yaml'
Plugin 'Valloric/YouCompleteMe'
" Plugin 'davidhalter/jedi-vim'
" Colorschema
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'zcodes/vim-colors-basic'
Plugin 'ayu-theme/ayu-vim'
Plugin 'danilo-augusto/vim-afterglow'
" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)

" All of your Plugins must be added before the following line
call vundle#end()            " required


filetype plugin indent on    " required

" Enable folding
set foldmethod=indent
set foldlevel=99

set hlsearch                         " highlight matches
set incsearch                        " ...as you type.
set autoread                         " automatically read changes from disk

au BufNewFile,BufRead *.py
  \ set tabstop=4 |
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  \ set textwidth=79 |
  \ set smarttab |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix |
  \ set colorcolumn=100 |

au BufNewFile,BufRead *.yml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
" Mark whitespace in python code
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

set encoding=utf-8

let python_highlight_all=1
set number

" vim-flake8 autodetect code fault
" pip install flake8
autocmd BufWritePost *.py call Flake8()

" Putty - Connection - Data - Terminal details : Terminal-type string : "xterm-256color"
syntax enable
" set background=dark
" colorscheme solarized
" colorscheme basic-dark
" colorscheme afterglow

" Allow paste in terminal, use only when pasting
" set paste

" let g:jedi#completions_enabled = 0
" let g:jedi#auto_initialization = 0
