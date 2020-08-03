 
"--------------------
" Default
"--------------------

let mapleader=" "
"set t_Co=256
set pastetoggle=<F12>
set nocompatible
set mouse-=a
set number
set showcmd
set wildmenu
set wrap
set backspace=indent,eol,start
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
noremap <LEADER><TAB> :%retab!<CR>gg=G<C-o><C-o>zz
map =b =iB<C-o>
 
"--------------------
" Search and Highlight
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

let @c = "^i//j"
let @u = "^:s/\\/\\//j"
map <LEADER>/ @c
map <LEADER>? @u:nohl<CR>
map <LEADER>9 ko#if 0<esc>
map <LEADER>0 o#endif<esc>

"--------------------
" Register
"--------------------
 
let @w = "+"
let @s = "-"
let @a = "<"
let @d = ">"
let @f = "$a  g_ldwj"
 
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
" Plugin
"--------------------

filetype off
filetype plugin indent on
filetype plugin on

if empty(system('command -v git'))
    silent !yum install git
endif
if empty(glob('~/.vim/bundle/Vundle.vim'))
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    "autocmd VimEnter * PluginInstall
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    
    Plugin 'fatih/vim-go'
        "autocmd GoUpdateBinaries

    Plugin 'majutsushi/tagbar'
        if empty(system('command -v ctags'))
            silent !yum install ctags
        endif
        nmap <F8> :TagbarToggle<CR>

    Plugin 'jstemmer/gotags'
        if empty(glob('$GOPATH/src/github.com/jstemmer/gotags'))
            if empty(glob('$GOPATH/pkg/mod/github.com/jstemmer/gotags*'))
                silent !go get -u github.com/jstemmer/gotags
            endif
        endif
        let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [
                \ 'p:package',
                \ 'i:imports:1',
                \ 'c:constants',
                \ 'v:variables',
                \ 't:types',
                \ 'n:interfaces',
                \ 'w:fields',
                \ 'e:embedded',
                \ 'm:methods',
                \ 'r:constructor',
                \ 'f:functions'
            \ ],
            \ 'sro' : '.',
            \ 'kind2scope' : {
                \ 't' : 'ctype',
                \ 'n' : 'ntype'
            \ },
            \ 'scope2kind' : {
                \ 'ctype' : 't',
                \ 'ntype' : 'n'
            \ },
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'
        \ }

    Plugin 'plasticboy/vim-markdown'
        let g:vim_markdown_folding_disabled=1
    
    Plugin 'dhruvasagar/vim-table-mode'
        let g:table_mode_corner = '|'
        let g:table_mode_border = 0
        let g:table_mode_fillchar = ' '

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

    Plugin 'preservim/nerdtree'
        map <leader>g :NERDTreeToggle<CR>

    Plugin 'Xuyuanp/nerdtree-git-plugin'
        let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ "Ignored"   : "☒",
            \ "Unknown"   : "?"
            \ }
    
    "Plugin 'Valloric/YouCompleteMe'
        " git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
        " cd .vim/bundle/YouCompleteMe/
        " git submodule update --init --recursive
        " python3 install.py --clang-completer --go-completer
        " # python3 install.py --clang-completer  --system-libclang
        " cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py ~/


    "Plugin 'vim-airline/vim-airline'
    "    let g:airline#extensions#tabline#enabled = 1
    "    let g:airline_powerline_fonts = 1
    "Plugin 'vim-airline/vim-airline-themes'
    "    let g:airline_theme='luna'
    "Plugin 'acarapetis/vim-colors-github'
    "Plugin 'vim-scripts/SuperTab'
    "Plugin 'iamcco/mathjax-support-for-mkdp'
    "Plugin 'iamcco/markdown-preview.vim'

call vundle#end()

"--------------------
" Document
"--------------------

" update to vim8
" git clone https://github.com/vim/vim.git
" cd vim
" ./configure  --enable-python3interp=yes
" make -j 8
" make install
" cp src/vim /usr/bin
" vim --version











