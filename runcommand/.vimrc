 
"--------------------
" Default
"--------------------

let mapleader=" "
set pastetoggle=<F12>
syntax on
 
"--------------------
" Indent
"--------------------
 
set cindent
set smartindent
set autoindent
filetype indent on
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
noremap <LEADER><TAB> :%retab!<CR>gg=G<C-o><C-o>zz
map =b =iB<C-o>
 
"--------------------
" Individuation
"--------------------

"set t_Co=256
set mouse-=a
set number
set showcmd
set wildmenu
set wrap
 
"--------------------
" Highlight
"--------------------

set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase
noremap <LEADER><CR> :nohlsearch<CR>

"--------------------
" Shortcut Key
"--------------------

map R :source $MYVIMRC<CR>
map ; $
map j gj
map k gk
map S :w<CR>
map Q :q<CR>
 
"--------------------
" Comment
"--------------------
 
let @c = "^i//j"
let @u = "^:s/\\/\\//j"
map <LEADER>/ @c
map <LEADER>? @u:nohl<CR>
map <LEADER>9 ko#if 0<esc>
map <LEADER>0 o#endif<esc>
 
"--------------------
" Cursor
"--------------------
 
set nocursorcolumn
set cursorline
highlight CursorLine cterm=NONE ctermbg=Black
" Black、DarkBlue、DarkGreen、DarkCyan、DarkRed、DarkMagenta、
" Brown(DarkYellow)、LightGray(LightGrey、Gray、Grey)、DarkGray(DarkGrey)、
" Blue(LightBlue)、Green(LightGreen)、Cyan(LightCyan)、Red(LightRed)、
" Magenta(LightMagenta)、Yellow(LightYellow)、White
 
"--------------------
" Register
"--------------------
 
let @w = "+"
let @s = "-"
let @a = "<"
let @d = ">"
let @f = "$a  g_ldwj"
 
"--------------------
" Plugin
"--------------------

set nocompatible              " be iMproved, required
filetype off                  " required

if empty(glob('~/.vim/bundle/Vundle.vim'))
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    autocmd VimEnter * PluginInstall --sync | source $MYVIMRC
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    " This plugin adds Go language support for Vim
    Plugin 'https://github.com/fatih/vim-go.git'

    " Syntax highlighting, matching rules and mappings for the original Markdown and extensions.
    Plugin 'https://github.com/plasticboy/vim-markdown.git'
        let g:vim_markdown_folding_disabled=1

    " The NERDTree is a file system explorer for the Vim editor
    Plugin 'https://github.com/preservim/nerdtree.git'
        map <leader>g :NERDTreeToggle<CR>

    " A plugin of NERDTree showing git status flags
    Plugin 'https://github.com/Xuyuanp/nerdtree-git-plugin'

    " An awesome automatic table creator & formatter allowing one to create neat tables as you type
    Plugin 'https://github.com/dhruvasagar/vim-table-mode.git'
        let g:table_mode_corner = '|'
        let g:table_mode_border=0
        let g:table_mode_fillchar=' '

        function! s:isAtStartOfLine(mapping)
          let text_before_cursor = getline('.')[0 : col('.')-1]
          let mapping_pattern = '\V' . escape(a:mapping, '\')
          let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
          return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
        endfunction

        inoreabbrev <expr> <bar><bar>
                  \ <SID>isAtStartOfLine('\|\|') ?
                  \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
        inoreabbrev <expr> __
                  \ <SID>isAtStartOfLine('__') ?
                  \ '<c-o>:silent! TableModeDisable<cr>' : '__'

call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line 
