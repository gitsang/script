 
"--------------------
" Basic
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
set encoding=utf-8 fileencodings=utf-8
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
" Leader Keymap
"--------------------
" source vimrc
noremap <LEADER>r :source $MYVIMRC<CR>
" no highlight
noremap <LEADER><CR> :nohlsearch<CR>
" remove trailing spaces
noremap <LEADER>s $a  g_ldwj
" retab
noremap <LEADER><TAB> :%retab!<CR>gg=G<C-o><C-o>zz
" unix format
noremap <LEADER>f :set ff=unix<CR>:set ff?<CR>

"--------------------
" Keymap
"--------------------
map ; $
map j gj
map k gk
map S :w<CR>
map Q :q<CR>

"--------------------
" Search and Highlight
"--------------------
exec "nohlsearch"
set hlsearch
set incsearch
set ignorecase
set smartcase

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
    silent !yum install git -y
    silent !dnf install git -y
    silent !apt install git -y
endif
if empty(glob('~/.vim/bundle/Vundle.vim'))
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    autocmd VimEnter * source $MYVIMRC
    autocmd VimEnter * PluginInstall
else
    "autocmd FileType go TagbarToggle
    "autocmd FileType go NERDTreeToggle
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    "--------------------
    " Vundle.vim
    "--------------------
    Plugin 'VundleVim/Vundle.vim'

    "--------------------
    " Markdown
    "--------------------
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

    "--------------------
    " NERDTree
    "--------------------
    Plugin 'preservim/nerdtree'
        map <leader>g :NERDTreeToggle<CR>

    Plugin 'Xuyuanp/nerdtree-git-plugin'
        let g:NERDTreeGitStatusIndicatorMapCustom = {
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

    "--------------------
    " Vim-go
    "--------------------
    "Plugin 'fatih/vim-go'
    "    if empty(glob('~/.vim/bundle/vim-go'))
    "        autocmd VimEnter * GoUpdateBinaries
    "    endif
    "    let g:syntastic_go_checkers = ['go', 'golint']

    "--------------------
    " Tagbar
    "--------------------
    "Plugin 'majutsushi/tagbar'
    "    nmap <F8> :TagbarToggle<CR>
    "    if empty(system('command -v ctags'))
    "        silent !yum install ctags -y
    "    endif
    "    let g:tagbar_type_go = {
    "        \ 'ctagstype' : 'go',
    "        \ 'kinds'     : [
    "            \ 'p:package',
    "            \ 'i:imports:1',
    "            \ 'c:constants',
    "            \ 'v:variables',
    "            \ 't:types',
    "            \ 'n:interfaces',
    "            \ 'w:fields',
    "            \ 'e:embedded',
    "            \ 'm:methods',
    "            \ 'r:constructor',
    "            \ 'f:functions'
    "        \ ],
    "        \ 'sro' : '.',
    "        \ 'kind2scope' : {
    "            \ 't' : 'ctype',
    "            \ 'n' : 'ntype'
    "        \ },
    "        \ 'scope2kind' : {
    "            \ 'ctype' : 't',
    "            \ 'ntype' : 'n'
    "        \ },
    "        \ 'ctagsbin'  : 'gotags',
    "        \ 'ctagsargs' : '-sort -silent'
    "    \ }

    "--------------------
    " You Complete Me
    "--------------------
    "Plugin 'Valloric/YouCompleteMe'
    "    let g:ycm_extra_conf_globlist = ['~/.ycm_extra_conf.py']
    "    " git submodule update --init --recursive
    "    " python3 install.py --go-completer --clang-completer --system-libclang
    "    " cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py ~/

    "--------------------
    " Vim airline
    "--------------------
    "Plugin 'vim-airline/vim-airline'
    "    let g:airline#extensions#tabline#enabled = 1
    "    let g:airline_powerline_fonts = 1
    "Plugin 'vim-airline/vim-airline-themes'
    "    let g:airline_theme='luna'

    "--------------------
    " Other
    "--------------------
    "Plugin 'acarapetis/vim-colors-github'
    "Plugin 'vim-scripts/SuperTab'
    "Plugin 'iamcco/mathjax-support-for-mkdp'
    "Plugin 'iamcco/markdown-preview.vim'

call vundle#end()

"--------------------
" Vim update doc
"--------------------
" git clone https://github.com/vim/vim.git
" ./configure  --enable-python3interp=yes
" make -j8
" make install

