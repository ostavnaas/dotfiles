set nocompatible              " required
filetype on                  " required
" syntax enable
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Markdown support
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'bad-whitespace'
" Plugin 'nvie/vim-flake8'
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
"
" Add Puppet lint
Plugin 'rodjek/vim-puppet'

"syntax highlighter
Plugin 'vim-syntastic/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required


filetype plugin indent on    " required

" Enable folding
set foldmethod=indent
set foldlevel=99

set hlsearch                         " highlight matches
set incsearch                        " ...as you type.
set autoread                         " automatically read changes from disk
highlight BadWhitespace ctermbg=red guibg=red

au BufNewFile,BufRead *.py
  \ set tabstop=4 |
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  \ set textwidth=79 |
  \ set smarttab |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix |
  \ set colorcolumn=119 |

au BufNewFile,BufRead *.yaml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set nowrap

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.pp match BadWhitespace /\s\+$/

au BufNewFile,BufRead *.pp
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set filetype=puppet

set encoding=utf-8

let python_highlight_all=1
set number

" vim-flake8 autodetect code fault
" pip install flake8
" autocmd BufWritePost *.py call Flake8()

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
"
" Always show status line
set laststatus=2
" Filename
set statusline+=%F

" vim-syntastic/syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Require: apt-get install yamllint
" cd ~/.vim/bundle/YouCompleteMe ; ./install.py --clang-completer --go-completer
" let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_yaml_checkers = ['yamlxs']
" let g:syntastic_puppet_checkers = ['puppetlint']
let g:syntastic_puppet_checkers = ['puppet']
let g:syntastic_go_checkers = ['gofmt']
