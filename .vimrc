" Encoding
set encoding=utf-8

set nocompatible              " required
filetype off                  " required

"""""""""""""""
""" Plugins """
"""""""""""""""
" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here
" (note older versions of Vundle used Bundle instead of Plugin)
"
Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'scrooloose/syntastic'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'tmhedberg/SimpylFold'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'chrisbra/Recover.vim'
Plugin 'AndrewRadev/sideways.vim'
Plugin 'justinmk/vim-syntax-extra'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mattn/emmet-vim'
Plugin 'fatih/vim-go'
"
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


""""""""""""""""""""""
""" Basic behavior """
""""""""""""""""""""""
" Powerline for vim (managed by pip)
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" Fetch vimrc files from working directory
set exrc
" ...but disable some options, so that it is secure to do it
set secure

" Add horizontal background line to cursor
set cursorline

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable syntax coloring
syntax on

" Vim aware tmux scrolling
set mouse=a

" Make YouCompleteMe close documentation automatically
let g:ycm_autoclose_preview_window_after_completion=1

" Set Syntastic linters for python
let g:syntastic_python_checkers = ['flake8']

" Set execution path for python files
let g:syntastic_python_python_exec = 'python3'

" Always show statusline
set laststatus=2

"Set the default clipboard to system-clipboard (requires '+xterm-clipboard')
set clipboard=unnamedplus

" Escape key timeout
" set esckeys 
" Not used because it breaks sequences that use escape in insert mode
" Use this instead
set timeoutlen=1000 ttimeoutlen=0

" Make scrolling distance out from bottom
set scrolloff=10

" Disable YouCompleteMe docstrings previews at entering a completion
set completeopt-=preview

" Make Simplyfold show docstrings of folded code chunks
let g:SimpylFold_docstring_preview=1


""""""""""""""""""
""" Appearnace """
""""""""""""""""""
" Selection colors fix
set background=dark

" Show where the 80th column is
set colorcolumn=80
" And do it with using this color
highlight ColorColumn ctermbg=darkgray

" Better color scheme
colorscheme brighton-modified

" YouCompleteMe completion submenu colors
highlight Pmenu ctermfg=lightgray ctermbg=darkgray guifg=#ffffff guibg=#000000    
" highlight Pmenu ctermfg=15 ctermbg=0 

" Color by which trailing whitespaces are colored
highlight BadWhitespace ctermbg=red guibg=darkred


""""""""""""""""""""
""" Line numbers """
""""""""""""""""""""
" Relative numbers settings: toggling with ctr-n, change on focus, change on
" mode
set relativenumber
function! NumberToggle()
	if(&relativenumber == 1)
		set number
		set norelativenumber
		highlight LineNr ctermFg=232
	else
		set relativenumber
		set nonumber
		highlight LineNr ctermFg=246
	endif
endfunc

" Toggle numberline when losing and regaining focus
:au FocusLost * :set number
:au FocusGained * :set relativenumber

" Toggle numberline when entering and exiting insert mode
autocmd InsertEnter * :set number | set norelativenumber
autocmd InsertLeave * :set relativenumber | set nonumber


"""""""""""""""""""
""" Keybindings """
"""""""""""""""""""
" Split navigations
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>
noremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Habit breaking, habit making
" Disable the arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>

" Sideways! = and - move arguments (and more) left and right
nnoremap - :SidewaysLeft<cr>
nnoremap = :SidewaysRight<cr>

" NERDTree keybindings
silent! nmap <C-p> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>
silent! map <F2> :NERDTreeToggle<CR>

" Enable folding with the spacebar
nnoremap <space> za

" YouCompleteMe - go to definition / declaration
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Make ctrl+n toggle between numberline and relative numberline
nnoremap <C-n> :call NumberToggle()<cr>


"""""""""""""""""""""""""
"""	Tabulation config """
"""""""""""""""""""""""""
" Set how many collumns a tab character counts for
set tabstop=4 |

" Set how many collumns (spaces, or tabs + spaces, or just tabs)
" when tab key is hit
set softtabstop=4 |

" Set how many collumns a << and >> shifts by
set shiftwidth=4 |


""""""""""""""""""""""""""""""""
""" Per-filetype preferences """
""""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.py
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ let python_highlight_all=1

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2 

au BufNewFile,BufRead *.go
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ set foldmethod=syntax

" Find trailing whitespaces 
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Start emmet only in html and css files.
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

"""""""""""""""""""""""""
""" NERDTree settings """
"""""""""""""""""""""""""
" Keybindings for when the menu is open and focused
let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"
let g:NERDTreeClose="<F2>"

" Close NERDTree after opening of a file
let NERDTreeQuitOnOpen=1

" Ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__'] "ignore files in NERDTree

" Make ctrlp work vith NERD
let g:NERDTreeChDirMode       = 2
let g:ctrlp_working_path_mode = 'rw'


"""""""""""""""""""""""""
""" Common annoyances """
"""""""""""""""""""""""""
" ':' commands that annoy
if has("user_commands")
	command! -bang -nargs=? -complete=file E e<bang> <args>
	command! -bang -nargs=? -complete=file W w<bang> <args>
	command! -bang -nargs=? -complete=file Wq wq<bang> <args>
	command! -bang -nargs=? -complete=file WQ wq<bang> <args>
	command! -bang Wa wa<bang>
	command! -bang WA wa<bang>
	command! -bang Q q<bang>
	command! -bang QA qa<bang>
	command! -bang Qa qa<bang>
endif

" Because 'U' keybinding is never useful. 
:nnoremap U :echohl Error \| echo " <== C H E C K   C A P S   L O C K ==>"<CR>\
			:echohl Normal

"""""""""""""""""""""
""" Miscellaneous """
"""""""""""""""""""""
" DISABLED - errors caused by execfile call removed from python3
" Virtualenv support for python 
"py3 << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
"	project_base_dir = os.environ['VIRTUAL_ENV']
"	activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"	execfile(activate_this, dict(__file__=activate_this))
"EOF
