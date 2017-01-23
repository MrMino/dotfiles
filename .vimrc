set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'tmhedberg/SimpylFold'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'chrisbra/Recover.vim'
Plugin 'AndrewRadev/sideways.vim'
Plugin 'justinmk/vim-syntax-extra'
Plugin 'Valloric/YouCompleteMe'


" Add all your plugins here (note older versions of Vundle used Bundle
" instead of Plugin)

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Line numbers
set nu

let python_highlight_all=1
syntax on

colorscheme brighton-modified
" highlight LineNr ctermFg=238

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

"Set the default clipboard to system-clipboard (requires '+xterm-clipboard')
set clipboard=unnamedplus

set laststatus=2

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_checkers = ['flake8']

" You complete me has completly fuckedup color scheme
highlight Pmenu ctermfg=lightgray ctermbg=darkgray      

" Disable completion previews
set completeopt-=preview

" Close NERDTree after opening of a file
let NERDTreeQuitOnOpen=1

" Ingore '*.pyc' in NERD
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" NERDTree keybindings
silent! nmap <C-p> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>

let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"

" Enable folding
set foldmethod=indent
set foldlevel=99


" Enable folding with the spacebar
nnoremap <space> za

" Make ctrlp work vith NERD
let g:NERDTreeChDirMode       = 2
let g:ctrlp_working_path_mode = 'rw'


au BufNewFile,BufRead *.py
	\ set tabstop=4 |
	\ set softtabstop=4 |
	\ set shiftwidth=4 |
	\ set textwidth=79 |
	\ set expandtab |
	\ set autoindent |
	\ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
	\ set tabstop=2 |
	\ set softtabstop=2 |
	\ set shiftwidth=2

highlight BadWhitespace ctermbg=red guibg=darkred
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


set encoding=utf-8

set cursorline

" Relative numbers settings: toggling with ctr-n, change on focus, change on
" mode
set relativenumber
function! NumberToggle()
	if(&relativenumber == 1)
		set number
		set norelativenumber
	else
		set relativenumber
		set nonumber
	endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>

:au FocusLost * :set number
:au FocusGained * :set relativenumber

autocmd InsertEnter * :set number | set norelativenumber
autocmd InsertLeave * :set relativenumber | set nonumber

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

" Annoyance fixes
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
" The scrolling bullshit
set scrolloff=10

" Sideways! = and - move arguments (and more) left and right
nnoremap - :SidewaysLeft<cr>
nnoremap = :SidewaysRight<cr>

" Escape key timeout
set timeoutlen=1000 ttimeoutlen=0
