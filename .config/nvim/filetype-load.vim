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

augroup filetype_yml
  autocmd!
  autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
  autocmd BufNewFile,BufReadPost *.{yaml,yml} set foldmethod=indent
  autocmd BufNewFile,BufReadPost *.{yaml,yml} set foldlevel=99
augroup END

augroup filetype_js
  autocmd!
  autocmd FileType javascript nnoremap <leader>j :call JsBeautify()<CR>
augroup END

augroup filetype_sh
  autocmd!
  autocmd Filetype sh nnoremap <leader>r :!bash %<CR>
augroup END

augroup textfiles
  autocmd!
  autocmd BufRead,BufNewFile *.txt set spell
  autocmd FileType gitcommit set spell
augroup END

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

