 
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
    autocmd VimEnter * PluginInstall --sync | source $MYVIMRC
endif

"call vundle#begin('~/.vim/bundle/Vundle.vim')
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    " This plugin adds Go language support for Vim
    Plugin 'fatih/vim-go'
        " use :GoInstallBinaries or :GoUpdateBinaries to install vim-go dependence

        " Tagbar is a Vim plugin that provides an easy way to browse the tags
        Plugin 'majutsushi/tagbar'
            if empty(system('command -v ctags'))
                silent !yum install ctags
            endif
            nmap <F8> :TagbarToggle<CR>

            Plugin 'jstemmer/gotags'
            if empty(glob('$GOPATH/src/github.com/jstemmer/gotags'))
                silent !go get -u github.com/jstemmer/gotags
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

    " Syntax highlighting, matching rules and mappings for the original Markdown and extensions
    Plugin 'plasticboy/vim-markdown'
        let g:vim_markdown_folding_disabled=1
    
        " An awesome automatic table creator & formatter allowing one to create neat tables as you type
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

    " The NERDTree is a file system explorer for the Vim editor
    Plugin 'preservim/nerdtree'
        map <leader>g :NERDTreeToggle<CR>

        " A plugin of NERDTree showing git status flags
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


    " status/tabline for vim that's light as air
    Plugin 'vim-airline/vim-airline'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1

        " This is the official theme repository for vim-airline
        Plugin 'vim-airline/vim-airline-themes'
            let g:airline_theme='luna'

    "Plugin 'acarapetis/vim-colors-github'
    "Plugin 'Valloric/YouCompleteMe'
    "Plugin 'vim-scripts/SuperTab'
    "Plugin 'iamcco/mathjax-support-for-mkdp'
    "Plugin 'iamcco/markdown-preview.vim'


call vundle#end()

" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" :h                - vundle for more details or wiki for FAQ
