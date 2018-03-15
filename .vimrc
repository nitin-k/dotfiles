
set nocompatible              " be iMproved, required
filetype off                  " required

syntax on

set relativenumber
set number
set nowrap " forces style
set noautoindent
set nosmartindent
set cindent
set backspace=indent,eol,start
set copyindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab " makes you go back 2 when you del from tab
set hlsearch " highlight all matches in a file when searching
set incsearch " incrementally highlight your searches
set pastetoggle=<f8>
set ignorecase smartcase " use caps if any caps used in search
set laststatus=2 " forces showing status bar
set encoding=utf-8 " order matters for Windows (encoding should be before autochdir)
set autochdir " (should be below encoding)
set title " modifies window to have filename as its title
set scrolloff=3 " keep the last 3 lines as you're scrolling down
set shell=/bin/zsh
set viminfo='10,\"100,:20,%,n~/.viminfo " saves position in files
set clipboard=unnamed
set nocursorline
set wildmode=longest,full
set wildmenu
set hidden
set noswapfile
set history=10000 " remember more commands and search history
set autoread " automatically re-read if file is modified externally
let mapleader=","
set mouse=nv " enable mouse for normal and visual modes (not insert!!!)
set nocompatible
filetype off

" save when losing focus
autocmd FocusLost * :silent! wall
" auto-resize splits when window is resized
autocmd VimResized * :wincmd =

augroup resCur
  " restore files to last cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" *** abbreviations ***
iabbrev teh the
iabbrev oyu you
iabbrev dont' don't
iabbrev its' it's
iabbrev haev have

" *** command mappings ***
cnoremap %% <C-R>=getcwd().'/'<cr>
cnoremap %g <C-R>=FindParentGit()<cr>

" *** normal mode remappings ***
noremap j gj
noremap k gk
noremap gj j
noremap gk k
nnoremap Q gqip
nnoremap S 1z=
nnoremap <leader>n :wincmd v<cr>:wincmd l<cr>
nnoremap ; :
nnoremap <leader>1 :call Underline("=")<CR>
nnoremap <leader>2 :call Underline("-")<CR>
nnoremap <leader>3 I### <esc>
nnoremap <leader>4 I#### <esc>
nnoremap <leader>5 I##### <esc>
nnoremap <F4> <Esc>:1,$!xmllint --format %<CR>
"json formating
nnoremap <F5> <Esc>:%!ppjson<CR>
nnoremap <F6> :call UpdateTags()
nnoremap <F7> :NumbersToggle<CR>
nnoremap ,, <C-^>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>" viw<Esc>a"<Esc>hbi"<Esc>lel
nnoremap <leader>' viw<Esc>a'<Esc>hbi'<Esc>lel
nnoremap <leader>w :set hlsearch!<CR>
nnoremap <leader>dw :%s/\v +\n/\r/g<CR><C-o> " when substituting, \r is newline
nnoremap <leader>sw :call VimuxRunCommand("cd $HOME/git/swlib && ./sendToMud.sh wizards/sead/" . @%)<CR>
" need to understand thi before undoing it
"nnoremap / /\v
nnoremap Y y$
" swap the word the cursor is on with the next (newlines are okay, punctuation
" is skipped)
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>:noh<CR>
nnoremap <Right> <C-w>l
nnoremap <C-l> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <C-h> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <C-k> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <C-j> <C-w>j
nnoremap <leader>c :Silent echo -n %% \| pbcopy<cr>

" =======================
" Fuzzy-finding mappings:
" =======================
" <leader>f => If pwd is in a Git repo, do FZF on $(git ls-files) from pwd,
"              otherwise all files in pwd + subdirectories
" <leader>F => all files in $HOME + subdirectories
" <leader>g => all files in current Git repo EXCEPT gitignored (git ls-files)
" <leader>G => all files in current Git repo

map <expr> <leader>f '%g' != '.git' ? ':FZF<cr>' : 'GFiles %%<cr>'
map <leader>F :FZF $HOME<cr>
map <leader>g :GFiles<cr>
map <leader>G :FZF %g<cr>

" *** insert mode mappings ***
inoremap jk <esc>
inoremap <c-c> <esc>
inoremap <esc> <nop>
" use this to paste code or anything else formatted
inoremap <leader>p <f8><cr> p<cr> <f8><cr>

" *** conditional options ***
" in Vim 7.3, built-in; otherwise fall back to other function
if exists('+colorcolumn')
  set colorcolumn=+2 " colorcolumn will appear at +2 whatever textwidth is
  autocmd FileType html setlocal colorcolumn=
else
  highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
  match OverLength /\%>80v.\+/
endif

if v:version >= 600
  filetype plugin indent on
else
  filetype on
endif

" *** functions ***
" function to underline text with a delimiter
function! Underline(delimiter)
  let x = line('.')
  if x == "0"
    echo "Nope"
  else
    :call append(line('.'), repeat(a:delimiter, strlen(getline(x))))
  endif
endfunction

function! FindParentGit()
    let parentGit = system('find-parent-git')
    let parentGit = substitute(parentGit, '\n$', '', '') " removes the newline

    if parentGit == "no parent git found"
        return ".git"
    endif

    return parentGit
endfunction

command! -nargs=1 Silent
      \ | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

" OS specific mappings {{{
" also useful - has('gui_running')
if has("win32")
  " assume that your file ends with .html
  autocmd FileType html nmap <silent> <F5> :! start %<CR>
else
  if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
      " mac stuff
      autocmd FileType html nmap <silent> <F5> :!open -a Google\ Chrome %<CR>
    else
      " linux stuff
      autocmd FileType html nmap <silent> <F5> :!gnome-open %<CR>
    endif
    " mac + linux stuff
    let &titleold=getcwd()
  else
    echo "No idea what OS you're running"
  endif
endif
" }}}

" Language-specific mappings {{{

autocmd filetype crontab setlocal nobackup nowritebackup

augroup filetype_coffeescript
  autocmd!
  autocmd BufRead,BufNewFile *.coffee set filetype=coffee
augroup END

augroup filetype_c_cpp
  autocmd!
  autocmd FileType javascript,java,c nnoremap <buffer> <localleader>c I//<ESC>
  autocmd FileType python nnoremap <buffer> <localleader>c I#<ESC>
augroup END
" }}}

" Language-specific mappings {{{
augroup filetype_python
  autocmd!
  autocmd FileType python nnoremap <leader>r :!python % <CR>
  autocmd FileType python set tabstop=2
  autocmd FileType python set shiftwidth=2
  autocmd FileType python set softtabstop=2
augroup END

augroup filetype_markdown
  autocmd!
  autocmd FileType markdown setlocal textwidth=78
  autocmd FileType markdown set spell
augroup END

augroup filetype_lpc
  autocmd!
  autocmd BufRead,BufNewFile ~/git/swlib/wizards/sead/* set filetype=lpc
  autocmd BufRead,BufNewFile ~/git/swlib/wizards/sead/* set tw=78
augroup END

augroup filetype_js
  autocmd!
  autocmd FileType javascript nnoremap <leader>j :call JsBeautify()<CR>
augroup END

augroup filetype_sh
  autocmd!
  autocmd Filetype sh nnoremap <leader>r :!bash %<CR>
augroup END

augroup filetype_wig
  autocmd!
  autocmd FileType wig nnoremap <leader>r :!wiggle % --symbol <CR>
  autocmd FileType wig nnoremap <leader>m :Silent cd $WIGGLEDIR && make<CR>
augroup END

augroup filetype_html
  autocmd!
  autocmd FileType html :iabbrev </ </<C-X><C-O>
augroup END

augroup filetype_perl
  autocmd!
  autocmd FileType perl nnoremap <F5> :!perl % <CR>
augroup END

augroup filetype_makefile
  autocmd!
  autocmd Filetype make setlocal noexpandtab
augroup END

augroup filetype_java
  autocmd!
  autocmd Filetype java setlocal cindent
  autocmd BufNewFile *.java call Create_Java_Template()
  autocmd Filetype java nnoremap <leader>r :call Compile_And_Run_Java()<CR>
augroup END

function! Create_Java_Template()
  let classname = expand("%:r")
  execute "normal ipublic class " . classname . " {"
  execute "normal opublic static void main(String[] args) {"
  execute "normal o}"
  execute "normal o}"
  execute "normal kk^"
endfunction

" compile and run Java - assumes that the current file has "main"
function! Compile_And_Run_Java()
  if match(readfile(expand("%")), "public static void main") != -1
    let output = system("cd \"" . expand("%:p:h") . "\" && javac \"" . expand("%") . "\" && java " . expand("%:r"))
    echo output
  else
    echom "Main method not found"
  endif
endfunction

" }}}

" Vimscript file settings {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'junegunn/fzf'
Bundle 'junegunn/fzf.vim'
Bundle 'kchmck/vim-coffee-script'
Bundle 'mhinz/vim-startify'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-vinegar'
Bundle 'vim-scripts/sudo.vim'

" Colorschemes
Bundle 'altercation/vim-colors-solarized'
Bundle 'joedicastro/vim-molokai256'
Bundle 'sjl/badwolf'
Bundle 'slindberg/vim-colors-smyck'

" Unite settings
autocmd FileType unite call s:unite_my_settings()

function! s:unite_my_settings()
  nmap <buffer> <C-c>      i_<Plug>(unite_exit)
endfunction

" Status line settings {{{
set statusline=%.40F " write full path to file, max of 40 chars
set statusline+=%h%m%r " help file, modified, and read only
set statusline+=\ col=%v " column number
set statusline+=\ Buf\=%n " Buffer number
set statusline+=\ %y " Filetype
set statusline+=\ char=\[%b\]
set statusline+=\ %=%l/%L\ (%p%%)\ \  " right align percentages
" }}}

if $TERM == "xterm-256color"
  set t_Co=256
endif
colorscheme molokai256

" flag lines that have trailing whitespace, has to come after colorscheme
highlight TrailingWhiteSpace ctermbg=red guibg=red
match TrailingWhiteSpace /\v +\n/

let g:ycm_filetypes_to_completely_ignore = { 'java' : 1 }
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['java'] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>
