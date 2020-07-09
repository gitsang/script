 
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
 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
    Plug 'https://github.com/plasticboy/vim-markdown.git'
        let g:vim_markdown_folding_disabled=1
    Plug 'https://github.com/preservim/nerdtree.git'
        map <leader>g :NERDTreeToggle<CR>
    Plug 'Xuyuanp/nerdtree-git-plugin'
 
    Plug 'https://github.com/dhruvasagar/vim-table-mode'
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
call plug#end()
