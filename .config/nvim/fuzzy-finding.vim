function! FindParentGit()
    let parentGit = system('find-parent-git')
    let parentGit = substitute(parentGit, '\n$', '', '') " removes the newline

    if parentGit == "no parent git found"
        return ".git"
    endif

    return parentGit
endfunction

cnoremap %g <C-R>=FindParentGit()<cr>
map <expr> <leader>f '%g' != '.git' ? ':FZF<cr>' : 'GFiles %%<cr>'
map <leader>F :FZF %:h<cr>
map <leader>g :GFiles<cr>
map <leader>b :Buffers<cr>
map <leader>s :GFiles?<cr>

command! -bang Projects call fzf#run(
      \ fzf#wrap({'sink': 'cd', 'source': 'find ~/git -type d -maxdepth 1'}))
map <leader>p :Projects<cr>
