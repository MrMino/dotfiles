""""""""""""""""""""""""
""" Plugins (Vundle) """
""""""""""""""""""""""""

" Disable filetype (Vundle requires it)
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here
" (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'w0rp/ale'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/nerdtree'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'chrisbra/Recover.vim'
Plugin 'AndrewRadev/sideways.vim'
Plugin 'justinmk/vim-syntax-extra'
Plugin 'elzr/vim-json'
Plugin 'mfukar/robotframework-vim'
Plugin 'othree/xml.vim'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'inkarkat/vim-ReplaceWithRegister'
Plugin 'Chiel92/vim-autoformat'
Plugin 'metakirby5/codi.vim'
Plugin 'simnalamburt/vim-mundo'
Plugin 'preservim/tagbar'
Plugin 'ludovicchabant/vim-gutentags'


" All of your Plugins must be added before the following lines
call vundle#end()
"
" Reenable filetype
filetype plugin indent on


"""""""""""""""""""""""""
""" Plugin graveyard  """
"""""""""""""""""""""""""
" Uses some weird proprietary crap to run python debuger
" Maybe we could implement a dbgp protocol for ipdb?
" Plugin 'vim-vdebug/vdebug'

" Brighton is still much better, especially after fixing Pmenu artifacts
" Plugin 'altercation/vim-colors-solarized'

" Never helped much, I don't use tabs
" Plugin 'jistr/vim-nerdtree-tabs'

" They say its cool, but I don't really see use for it
" Plugin 'tpope/vim-fugitive'

" Makes '<motion>c' laggy as...
" Plugin 'christoomey/vim-system-copy'

" Not using these languages right now
" Plugin 'mxw/vim-prolog'
" Plugin 'fatih/vim-go'
" Plugin 'JuliaEditorSupport/julia-vim'

" Makes basic operations slow in large files. See SimpylFold#122
" Plugin 'tmhedberg/SimpylFold'

""""""""""""""""""""""
""" Basic behavior """
""""""""""""""""""""""

" Disable Vi compatibility mode
set nocompatible

" Output (terminal) encoding
set encoding=utf-8

" Powerline for vim (managed by pip)
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" Fetch vimrc files from working directory
set exrc
" ...but disable some options, so that it is secure to do it
set secure

" Enable folding
set foldmethod=indent
set foldlevel=99

" Vim aware tmux scrolling
set mouse=a

" Always show statusline
set laststatus=2

" Set the default clipboard to system-clipboard (requires '+xterm-clipboard')
set clipboard=unnamedplus

" Escape key timeout
set timeoutlen=1000 ttimeoutlen=0

" Make scrolling distance out from bottom
set scrolloff=10

" Persistent undo
set undofile

" Undo/backup/swap files in their own dirs
set backupdir=~/.vim/backupfiles
set directory=~/.vim/swapfiles
set undodir=~/.vim/undofiles

" Make mouse mode work under tmux
set ttymouse=xterm2

" Persistent folds
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent loadview
augroup END


"""""""""""""""""""
" Plugin behavior "
"""""""""""""""""""

" Simpylfold
" Make Simpylfold show docstrings of folded code chunks
let g:SimpylFold_docstring_preview=1

" YouCompleteMe
" Make YouCompleteMe close documentation automatically
let g:ycm_autoclose_preview_window_after_completion=1
" Globabl extra conf
let g:ycm_global_ycm_extra_conf = '/home/mrmino/.ycm_extra_conf.py'
" Disable YouCompleteMe docstrings previews at entering a completion
set completeopt-=preview
" Completion submenu colors
highlight Pmenu ctermfg=lightgray ctermbg=darkgray guifg=#ffffff guibg=#000000
" highlight Pmenu ctermfg=15 ctermbg=0


" ALE
" Set syntax linters
let g:ale_linters = {
\   'python': ['flake8', 'pycodestyle', 'mypy'],
\}

" UltiSnips
" let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" Make :UltiSnipsEdit to split current window.
let g:UltiSnipsEditSplit="vertical"

" NerdTree
" Keybindings for when the menu is open and focused
let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"
let g:NERDTreeClose="<F2>"
" Close NERDTree after opening of a file
let NERDTreeQuitOnOpen=1
" Ignored files
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__', '\.o$', '^a\.out$']
" Make ctrlp work vith NERD
let g:NERDTreeChDirMode       = 2
let g:ctrlp_working_path_mode = 'rw'

" Tagbar
" Open on the left side
let g:tagbar_position = 'botright vertical'


""""""""""""""""""
""" Appearnace """
""""""""""""""""""
" (Some appearance settings may also reside under 'Plugin behavior')

" Add horizontal background line to cursor
set cursorline

" Selection colors fix
set background=dark

" Show where the 81th column is
set colorcolumn=81
highlight ColorColumn ctermbg=darkgray

" Better color scheme
colorscheme brighton_modified

" Color by which trailing whitespaces are colored
highlight BadWhitespace ctermbg=red guibg=darkred

" Enable syntax coloring
syntax on


""""""""""""""""""""
""" Line numbers """
""""""""""""""""""""

" Toggle relative numbering with ctr-n
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
" (Some keybindings may also reside under 'Plugin keybindings' and 'Common
" annoyances')

" Split navigations
noremap <C-J> <C-W><C-J>
noremap <C-K> <C-W><C-K>
noremap <C-L> <C-W><C-L>
noremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

inoremap <C-J> <C-O><C-W><C-J><ESC>
inoremap <C-K> <C-O><C-W><C-K><ESC>
inoremap <C-L> <C-O><C-W><C-L><ESC>
inoremap <C-H> <C-O><C-W><C-H><ESC>

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

" Enable folding with the spacebar
nnoremap <space> za

" Make ctrl+n toggle between numberline and relative numberline
nnoremap <C-n> :call NumberToggle()<cr>


""""""""""""""""""""""""""
""" Plugin keybindings """
""""""""""""""""""""""""""

" Sideways
" = and - move arguments (and more) left and right
nnoremap - :SidewaysLeft<cr>
nnoremap = :SidewaysRight<cr>

" NERDTree
silent! nmap <C-p> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>
silent! map <F2> :NERDTreeToggle<CR>

" YouCompleteMe
" Go to definition / declaration
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <leader>k <plug>(YCMHover)

" ALE
" Navigate between errors / warns
nmap <silent> H <Plug>(ale_previous_wrap)
nmap <silent> L <Plug>(ale_next_wrap)

" Vim-autoformat
noremap <F4> :Autoformat<CR>

" UltiSnips
" Trigger configuration.
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<F5>"
let g:UltiSnipsJumpForwardTrigger="<c-s>"

" Codi
noremap <F6> :Codi!! python<CR>

" Mundo (undo tree)
nnoremap <F7> :MundoToggle<CR>

" Tagbar
noremap <F8> :TagbarToggle<CR>


"""""""""""""""""""""""""
"""	Tabulation config """
"""""""""""""""""""""""""

" Set how many collumns a tab character counts for
set tabstop=4 |

" Set how many collumns (spaces, or tabs + spaces, or just tabs) are added
" with every tab key hit
set softtabstop=4 |

" Set how many collumns a << and >> shifts by
set shiftwidth=4 |


""""""""""""""""""""""""""""""""
""" Per-filetype preferences """
""""""""""""""""""""""""""""""""

au BufNewFile,BufRead *.js,*.html,*.css,*.robot,*.py,*.c,*.jl,*.groovy,*.json,*.md
    \ set expandtab |
    \ set autoindent

au BufNewFile,BufRead *.py,*.robot,*.pl,*.c,*.jl
    \ set textwidth=79 |
    \ set fileformat=unix

au BufNewFile,BufRead *.py
    \ let python_highlight_all=1

au BufNewFile,BufRead *.pl
    \ setf prolog

au BufNewFile,BufRead *.robot
    \ setf robot

au BufNewFile,BufRead *.c,*.h
    \ set textwidth=79 |
    \ set fileformat=unix |
    \ set cindent |

au BufWrite *.c,*.h
    \ :Autoformat

" Find trailing whitespaces 
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


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

" Show warning when using 'U'
:nnoremap U :echohl Error \| echo " <== C H E C K   C A P S   L O C K ==>"<CR>\
			:echohl Normal

" Do not select newline character - prevents clobbering next line on pasting
:set selection=exclusive
