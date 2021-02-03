
"--------------------
" Basic
"--------------------
let mapleader=" "
"set guifont=iosevka:h14:cANSI
set t_Co=256
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
" Diff
"--------------------
hi DiffAdd    cterm=reverse ctermbg=235 ctermfg=108
hi DiffDelete cterm=reverse ctermbg=235 ctermfg=131
hi DiffChange cterm=reverse ctermbg=235 ctermfg=11
hi DiffText   cterm=reverse ctermbg=235 ctermfg=192

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
" bar
noremap <leader>b :NERDTreeToggle<CR>:TagbarToggle<CR><C-w>l

"--------------------
" Keymap
"--------------------
map ; $
map j gj
map k gk
map S :w<CR>
map Q :q<CR>
map t gt
map T gT

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
" Plug
"--------------------
if version < 800 || !has("python3")
    echom 'update vim:'
    echom '    git clone http://github.com/vim/vim.git'
    echom '    ./configure --enable-python3interp=yes'
    echom '    make && make install'
endif

filetype off
filetype plugin indent on
filetype plugin on

if empty(glob(expand('~/.vim/autoload/plug.vim')))
    silent curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

    "--------------------
    " Vim airline
    "--------------------
    Plug 'vim-airline/vim-airline'
        " statistic
        let g:airline#extensions#whitespace#enabled = 1
        let g:airline#extensions#wordcount#enabled = 1

        " powerline symbols
        let g:airline_powerline_fonts = 1
        if !exists('g:airline_symbols')
            let g:airline_symbols = {}
        endif
        let g:airline_left_sep = ''
        let g:airline_left_alt_sep = ''
        let g:airline_right_sep = ''
        let g:airline_right_alt_sep = ''
        let g:airline_symbols.branch = ''
        let g:airline_symbols.readonly = ''
        let g:airline_symbols.linenr = '☰'
        let g:airline_symbols.maxlinenr = ''
        let g:airline_symbols.dirty='⚡'

        " tab line
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#overflow_marker = '…'
        let g:airline#extensions#tabline#show_tabs = 0
        let g:airline#extensions#tabline#buffer_idx_mode = 1
        nmap <leader>1 <Plug>AirlineSelectTab1
        nmap <leader>2 <Plug>AirlineSelectTab2
        nmap <leader>3 <Plug>AirlineSelectTab3
        nmap <leader>4 <Plug>AirlineSelectTab4
        nmap <leader>5 <Plug>AirlineSelectTab5
        nmap <leader>6 <Plug>AirlineSelectTab6
        nmap <leader>7 <Plug>AirlineSelectTab7
        nmap <leader>8 <Plug>AirlineSelectTab8
        nmap <leader>9 <Plug>AirlineSelectTab9
        nmap <leader>- <Plug>AirlineSelectPrevTab
        nmap <leader>= <Plug>AirlineSelectNextTab

        let g:airline#extensions#branch#enabled = 1
        let g:airline#extensions#branch#vcs_priority = ["git", "mercurial"]

    Plug 'vim-airline/vim-airline-themes'
        let g:airline_theme='luna'

    "--------------------
    " Markdown
    "--------------------
    Plug 'plasticboy/vim-markdown', { 'for': ['markdown'] }
        let g:vim_markdown_folding_disabled=1

    Plug 'dhruvasagar/vim-table-mode', { 'for': ['markdown'] }
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
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
        map <leader>t :NERDTreeToggle<CR>

    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
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
    " Tagbar
    "--------------------
    Plug 'majutsushi/tagbar', { 'do': 'yum install ctags -y', 'on': 'TagbarToggle' }
        map <leader>g :TagbarToggle<CR>
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

    "--------------------
    " Vim-go
    "--------------------
    if !empty(system('command -v go'))
        "Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': ['go'] }
        Plug 'fatih/vim-go', { 'for': ['go'] }
            let g:syntastic_go_checkers = ['go', 'golint']

            "let g:go_fmt_command = "goimports"
            let g:go_autodetect_gopath = 1
            let g:go_list_type = "quickfix"

            let g:go_version_warning = 1
            let g:go_highlight_types = 1
            let g:go_highlight_fields = 1
            let g:go_highlight_functions = 1
            let g:go_highlight_function_calls = 1
            let g:go_highlight_operators = 1
            let g:go_highlight_extra_types = 1
            let g:go_highlight_methods = 1
            let g:go_highlight_generate_tags = 1

        Plug 'dgryski/vim-godef', { 'for': ['go'] }
            let g:godef_split=2
    endif

    "--------------------
    " YouCompleteMe
    "--------------------
    if version > 800 && has("python3")
        Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --go-completer', 'for': ['go'] }
            " --clang-completer --system-libclang
            let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
    endif

    "--------------------
    " Other
    "--------------------
    "Plug 'acarapetis/vim-colors-github'
    "Plug 'vim-scripts/SuperTab'
    "Plug 'iamcco/mathjax-support-for-mkdp'
    "Plug 'iamcco/markdown-preview.vim'

call plug#end()

