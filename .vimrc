set nocompatible              " required
filetype on                  " required
" syntax enable
" set the runtime path to include Vundle and initialize

call plug#begin()


" Markdown support
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" let Vundle manage Vundle, required
Plug 'gmarik/Vundle.vim'
Plug 'bitc/vim-bad-whitespace'
" Plug 'nvie/vim-flake8'
Plug 'avakhov/vim-yaml'
" Plug 'davidhalter/jedi-vim'
"Plug 'pappasam/coc-jedi'
" Colorschema
"Plug 'jnurmine/Zenburn'
"Plug 'altercation/vim-colors-solarized'
"Plug 'zcodes/vim-colors-basic'
"Plug 'ayu-theme/ayu-vim'
Plug 'danilo-augusto/vim-afterglow'
" So indent
Plug 'Yggdroot/indentLine'

" Autoclose (){}""
"Plug 'Townk/vim-autoclose'

" Most Recently Used (MRU) plugin
"Plug 'yegappan/mru'
" Go
Plug 'fatih/vim-go'
" Add Puppet lint
Plug 'rodjek/vim-puppet'
"syntax highlighter (deprecated)
"Plug 'vim-syntastic/syntastic'
" ALE Replaces syntastic
Plug 'dense-analysis/ale'
"Plug 'tpope/vim-pathogen'
" Themes
Plug 'jacoborus/tender.vim'

"git branch
Plug 'itchyny/vim-gitbranch'
"Powerline
Plug 'itchyny/lightline.vim'

" File manager
" https://github.com/ctrlpvim/ctrlp.vim
Plug 'ctrlpvim/ctrlp.vim'

" All of your Plugs must be added before the following line
"
Plug 'tpope/vim-fugitive'

" https://black.readthedocs.io/en/stable/integrations/editors.html
Plug 'psf/black'
"
" https://github.com/fisadev/vim-isort
Plug 'fisadev/vim-isort'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" https://github.com/neoclide/coc.nvim
" Need install
" CocInstall coc-pyright coc-jedi
Plug 'neoclide/coc.nvim'
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': 'yarn install --frozen-lockfile' }
" https://github.com/preservim/nerdcommenter
Plug 'preservim/nerdcommenter'

" https://github.com/puremourning/vimspector
" Plug 'puremourning/vimspector'
"
" :CocInstall coc-spell-checker
Plug 'iamcco/coc-spell-checker'

call plug#end()
filetype plugin indent on    " required

" Enable folding
set foldmethod=indent
set foldlevel=99
set cursorline			     " Highlight line
set hlsearch                         " highlight matches
set incsearch                        " ...as you type.
set autoread                         " automatically read changes from disk
highlight BadWhitespace ctermbg=red guibg=red

au BufNewFile,BufRead *.py
  \ set tabstop=4 |
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  \ set smarttab |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix |
  \ set colorcolumn=100 |

au BufNewFile,BufRead *.go,*.tmpl
  \ set smarttab |

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
    \ set fileformat=unix

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
""" coc.vim Customize colors
"func! s:my_colors_setup() abort
"    " this is an example
"    hi Pmenu guibg=#d7e5dc gui=NONE
"    hi PmenuSel guibg=#b7c7b7 gui=NONE
"    hi PmenuSbar guibg=#bcbcbc
"    hi PmenuThumb guibg=#585858
"endfunc
"
"augroup colorscheme_coc_setup | au!
"    au ColorScheme * call s:my_colors_setup()
"augroup END

colorscheme tender

" Allow paste in terminal, use only when pasting
" set paste

" Always show status line
set laststatus=2
" Filename
set statusline+=%F
set statusline+=\ col:\ %c

" vim-syntastic/syntastic
set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Bash like tab compleation
set wildmode=longest,list

" Fix escape delay
set timeoutlen=300 ttimeoutlen=0



" Set , as leader
let mapleader = ","


""" REMOVE
" https://github.com/vim-syntastic/syntastic
"execute pathogen#infect()
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
" Require: apt-get install yamllint
" cd ~/.vim/bundle/YouCompleteMe ; ./install.py --clang-completer --go-completer
" let g:syntastic_yaml_checkers = ['yamllint']
"let g:syntastic_yaml_checkers = ['yamlxs']
"let g:syntastic_puppet_checkers = ['puppetlint']
"let g:syntastic_puppet_checkers = ['puppet']
"let g:syntastic_go_checkers = ['gofmt']
"let g:go_fmt_autosave = 0
"let g:syntastic_python_checkers = ['pylint']
""" REMOVE END

" Python youcomplateme
" let g:ycm_python_interpreter_path = ''
" let g:ycm_python_sys_path = []
" let g:ycm_extra_conf_vim_data = [
"   \  'g:ycm_python_interpreter_path',
"   \  'g:ycm_python_sys_path'
"   \]
" let g:ycm_global_ycm_extra_conf = '~/.global_extra_conf.py'


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


" go syntax
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

set history=1000

" Don't loose undo history when change file :bn
set hidden




" Show nbsp as $
set list
set listchars=nbsp:§

" https://vim.fandom.com/wiki/Easier_buffer_switching#Switching_by_number
nnoremap <F5> :buffers<CR>:buffer<Space>

" Navigate in windows
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l


" YouCompleteMe
"nmap gr :YcmCompleter GoToReferences<cr>
"nmap gd :YcmCompleter GoToDefinition<cr>
"nmap gt :YcmCompleter GoToType<cr>
""" https://github.com/ycm-core/YouCompleteMe#the-gycm_auto_hover-option
"let g:ycm_auto_hover=''
"nmap <leader>d <plug>(YCMHover)
"nmap <leader>b :CtrlPBuffer<cr>
"nmap <leader>m :CtrlPMRU<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>m :GFiles<cr>
nmap <leader>h :History<cr>
nmap <leader>c :GFiles?<cr>


"augroup black_on_save
"	autocmd!
"	autocmd BufWritePre *.py Black Isort
"augroup end
"
"" ALE
let g:ale_linters={
\ 'python': ['ruff', 'mypy'],
\}


let g:ale_fixers = {
\		'*': ['remove_trailing_lines'],
\    'python': ['black', 'isort'],
\}
let g:ale_fix_on_save = 1


"augroup quickfix
"    autocmd!
"    autocmd QuickFixCmdPost [^l]* cwindow
"    autocmd QuickFixCmdPost l* lwindow
"augroup END
"
"
"coc.vim
"
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"



function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" END
