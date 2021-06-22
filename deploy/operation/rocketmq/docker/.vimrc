
"--------------------
" Basic
"--------------------
let mapleader=" "
set pastetoggle=<F12>
set nocompatible
set mouse-=a
set number
set showcmd
set wildmenu
set wrap
set backspace=indent,eol,start
set encoding=utf-8 fileencodings=utf-8
noremap <LEADER>r :source $MYVIMRC<CR>
syntax on

"--------------------
" Indent
"--------------------
filetype indent on
set cindent
set smartindent
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
map =b =iB<C-o>

"--------------------
" Keymap
"--------------------
map ; $
map j gj
map k gk

"--------------------
" Search and Highlight
"--------------------
"exec nohlsearch
set hlsearch
set incsearch
set ignorecase
set smartcase
noremap <LEADER><CR> :nohlsearch<CR>

"--------------------
" Cursor
"--------------------
set nocursorcolumn
set cursorline
highlight CursorLine cterm=NONE ctermbg=Black

