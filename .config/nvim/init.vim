source ~/.config/nvim/plugins.vim

let mapleader=","

noremap j gj
noremap k gk
noremap gj j
noremap gk k

inoremap jk <esc>
nnoremap ; :

nnoremap <leader><leader> <C-^>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

nnoremap <Right> <C-w>l
nnoremap <leader>l <C-w>l

nnoremap <Left> <C-w>h
nnoremap <leader>h <C-w>h

nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <C-j> <C-w>j
nnoremap <F4> <Esc>:1,$!xmllint --format %<CR>
"json formating
nnoremap <F5> <Esc>:%!ppjson -i 2 -m false<CR>
" toggle folding
nnoremap <Space> za
nnoremap <leader>lj :set filetype=json foldmethod=syntax<CR>

colorscheme molokai256

set number
" Clipboard configuration
set clipboard+=unnamedplus
set clipboard+=unnamed
" Ensure clipboard works with system clipboard
if has('mac')
  set clipboard=unnamed
endif
set hidden
set noswapfile
set tags^=./.git/tags;

source ~/.config/nvim/smart-tab.vim
" source ~/.config/nvim/trailing-whitespace.vim
source ~/.config/nvim/filetype-load.vim
source ~/.config/nvim/fuzzy-finding.vim
source ~/.config/nvim/markdown-preview.vim

if filereadable($HOME . '/.config/nvim/local.vim')
    source $HOME/.config/nvim/local.vim
endif

set ignorecase
set smartcase

" Enable colors and syntax highlighting
syntax on
syntax enable
set termguicolors


" nvim-tree minimal setup and keymaps
lua << EOF
require('nvim-tree').setup({
  hijack_cursor = true,
  view = { width = 30, side = 'left' },
  renderer = { group_empty = true, highlight_git = true },
  filters = { dotfiles = false },
  git = { enable = true },
})
EOF

nnoremap <silent> <leader>e :NvimTreeToggle<CR>
nnoremap <silent> <leader>r :NvimTreeRefresh<CR>
nnoremap <silent> <leader>n :NvimTreeFindFile<CR>
nnoremap <silent> <leader>o :NvimTreeFocus<CR>
nnoremap <silent> <leader><Tab> <C-w>p

set shiftwidth=2

" Command to disable ALE in current Python buffer
command! DisablePythonALE if &filetype ==# 'python' && exists(":ALEDisableBuffer") == 2 | ALEDisableBuffer | echo "ALE disabled for Python buffer" | else | echo "Not a Python buffer or ALE missing" | endif

" Shortcut: <leader>ap to disable ALE in current Python buffer
nnoremap <silent> <leader>ap :DisablePythonALE<CR>