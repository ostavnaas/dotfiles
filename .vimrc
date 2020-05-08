set nocompatible              " required
filetype on                  " required
" syntax enable
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


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
"Plugin 'jnurmine/Zenburn'
"Plugin 'altercation/vim-colors-solarized'
"Plugin 'zcodes/vim-colors-basic'
"Plugin 'ayu-theme/ayu-vim'
Plugin 'danilo-augusto/vim-afterglow'
" So indent
Plugin 'Yggdroot/indentLine'

" Autoclose (){}""
"Plugin 'Townk/vim-autoclose'

" Most Recently Used (MRU) plugin
"Plugin 'yegappan/mru'
" Go
Plugin 'fatih/vim-go'
" Add Puppet lint
Plugin 'rodjek/vim-puppet'
"syntax highlighter
Plugin 'vim-syntastic/syntastic'
"Plugin 'tpope/vim-pathogen'
" Themes
Plugin 'jacoborus/tender.vim'

"git branch
Plugin 'itchyny/vim-gitbranch'
"Powerline
Plugin 'itchyny/lightline.vim'

" File manager
Plugin 'ctrlpvim/ctrlp.vim'

" All of your Plugins must be added before the following line
"
Plugin 'tpope/vim-fugitive'
call vundle#end()            " required


filetype plugin indent on    " required

" Enable folding
set foldmethod=indent
set foldlevel=99


set cursorline			     " Hightligh line
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

au BufNewFile,BufRead *.go
  \ set tabstop=2 |
  \ set softtabstop=2 |
  \ set shiftwidth=2 |
  \ set smarttab |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix |

au BufNewFile,BufRead *.yaml,*.yml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set nowrap |
    \ let g:indentLine_enabled=1

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h,*.pp match BadWhitespace /\s\+$/

au BufNewFile,BufRead *.pp
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set filetype=puppet

au BufNewFile,BufRead *.sh
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

" Yggdroot/indentLine Disable indent line in default
let g:indentLine_enabled = 0

" vim-flake8 autodetect code fault
" pip install flake8
" autocmd BufWritePost *.py call Flake8()

" Putty - Connection - Data - Terminal details : Terminal-type string : "xterm-256color"
syntax enable

if (has("termguicolors"))
 let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
 let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
 set termguicolors
endif


" set background=dark
" colorscheme solarized
" colorscheme basic-dark
" colorscheme afterglow
colorscheme tender

" Allow paste in terminal, use only when pasting
" set paste

" let g:jedi#completions_enabled = 0
" let g:jedi#auto_initialization = 0
"
" Always show status line
set laststatus=2
" Filename
set statusline+=%F
set statusline+=\ col:\ %c

" vim-syntastic/syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Bash like tab compleation
set wildmode=longest,list

" Fix escape delay
set timeoutlen=0 ttimeoutlen=0

" https://github.com/vim-syntastic/syntastic
"execute pathogen#infect()
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
let g:go_fmt_autosave = 0


" https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
set nomodeline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }
" Townk/vim-autoclose
" https://github.com/ycm-core/YouCompleteMe/issues/9
let g:AutoClosePumvisible = {"ENTER": "", "ESC": ""}

" ctrlpvim/ctrlp.vim
let g:ctrlp_map = '<c-p>'
