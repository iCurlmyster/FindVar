" Global variables
" base commands used
if !exists("g:findvar_base_cmds")
    let g:findvar_base_cmds = '-rni'
endif
" extra commands that user can tag onto the end
if !exists("g:findvar_extra_cmds")
    let g:findvar_extra_cmds = ''
endif
" default file matcings to be used (comma separated)
if !exists("g:findvar_default_file_matching")
    let g:findvar_default_file_matching = ''
endif

" - private functions
" - local function to gen include arguments for grep command
fun! s:gen_includes(fm)
    let l:file_matching = a:fm
    " grab includes from arguments
    let l:file_matching_list = split(l:file_matching, ',')
    let l:file_matching = ''
    for mat in l:file_matching_list
        let l:file_matching = l:file_matching . ' --include ' . mat
    endfor
    " grab includes from global default value
    let l:file_matching_list = split(g:findvar_default_file_matching, ',')
    for mat in l:file_matching_list
        let l:file_matching = l:file_matching . ' --include ' . mat
    endfor
    return l:file_matching
endfun
" - perform the grep operation
fun! s:execute_grep(vtf, fm, sd)
    " create command 
    let l:cmd = 'grep ' . g:findvar_base_cmds . ' ' . a:vtf . a:fm . ' ' . g:findvar_extra_cmds . ' ' . a:sd
    " grab results from executing command
    silent let l:results = systemlist(l:cmd)
    return l:results
endfun
" - display findvar results to user in separate window
fun! s:write_results_to_window(results)
    let l:name = '__FindVar_Results__.findvar'
    " check if buffer already exists
    if bufwinnr(l:name) == -1
        " create new split view with given name
        execute 'vsplit ' . l:name
    else
        " move focus to the window 
        execute bufwinnr(l:name) . 'wincmd w'
    endif
    " delete existing content
    normal! ggdG
    " don't prompt to save the buffer
    setlocal buftype=nofile
    " delete buffer when hidden
    setlocal bufhidden=delete
    " append results from 0
    call append(0, a:results)
endfun

" - public functions
" - Execute the grep command and display results in a new window
function! findvar#FindVar(...)
    " create local variables
    let l:starting_directory = ''
    let l:var_to_find = ''
    let l:file_matching = ''
    " look to see if a starting directory was given
    if a:0 > 0
        let l:starting_directory = a:1
    endif
    " look to see if a word to find was given
    if a:0 > 1
        " reassign to local mutable variable
        let l:var_to_find = a:2
    else
        " if argument is empty grab the word under the cursor
        let l:var_to_find = expand('<cword>')
    endif
    " look to see if a pattern for matching certain files was given
    " through)
    if a:0 > 2
        let l:file_matching = s:gen_includes(a:3)
    else
        let l:file_matching = s:gen_includes('')
    endif
    let l:results = s:execute_grep(l:var_to_find, l:file_matching, l:starting_directory)
    call s:write_results_to_window(l:results)
    " go back to previous window
    execute 'wincmd p'
endfunction
" - Execute the grep command and display results in a new window
function! findvar#FindVarWithWord(...)
    " create local variables
    let l:var_to_find = ''
    let l:file_matching = ''
    " look to see if a word to find was given
    if a:0 > 0
        " reassign to local mutable variable
        let l:var_to_find = a:1
    else
        " if argument is empty grab the word under the cursor
        let l:var_to_find = expand('<cword>')
    endif
    " look to see if a pattern for matching certain files was given
    " through)
    if a:0 > 1
        call findvar#FindVar('', l:var_to_find, a:2)
    else
        call findvar#FindVar('', l:var_to_find)
    endif
endfunction
" - Execute the grep command and display results in a new window
function! findvar#FindVarInFiles(...)
    " look to see if a pattern for matching certain files was given
    " through)
    if a:0 > 0
        call findvar#FindVar('', expand('<cword>'), a:1)
    else
        call findvar#FindVar('', expand('<cword>'))
    endif
endfunction

