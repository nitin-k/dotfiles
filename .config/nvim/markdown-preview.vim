" Set to open preview in your default browser
let g:mkdp_browser = ''

" Automatically start preview when opening markdown file
let g:mkdp_auto_start = 0

" Automatically close preview when leaving markdown buffer
let g:mkdp_auto_close = 1

" Refresh preview on save
let g:mkdp_refresh_slow = 0

" Preview page title
let g:mkdp_page_title = '「${name}」'

" Set the port (optional)
" let g:mkdp_port = '8080'

" Toggle Markdown Preview
nnoremap <leader>mp :MarkdownPreviewToggle<CR>