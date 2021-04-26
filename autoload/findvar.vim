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

if !exists("g:findvar_default_dir_exclude")
    let g:findvar_default_dir_exclude = ''
endif

" - private functions
" - local function to gen include arguments for grep command
fun! s:gen_includes(fm)
    let l:file_matching = a:fm
    " grab includes from arguments
    let l:file_matching_list = split(l:file_matching, ',')
    let l:file_matching = ''
    for mat in l:file_matching_list
        let l:file_matching = l:file_matching . ' --include=' . mat
    endfor
    " grab includes from global default value
    let l:file_matching_list = split(g:findvar_default_file_matching, ',')
    for mat in l:file_matching_list
        let l:file_matching = l:file_matching . ' --include=' . mat
    endfor
    return l:file_matching
endfun
fun! s:exclude_dirs(dm)
    let l:dir_matching = a:dm
    " grab excludes from arguments
    let dir_matching_list = split(l:dir_matching, ',')
    let l:dir_matching = ''
    for dir in l:dir_matching_list
        let l:dir_matching = l:dir_matching . ' --exclude-dir=' . dir
    endfor
    " grab excludes from global default value
    let l:dir_matching_list = split(g:findvar_default_dir_exclude, ',')
    for dir in l:dir_matching_list
        let l:dir_matching = l:dir_matching . ' --exclude-dir=' . dir
    endfor
    return l:dir_matching
endfun
" - perform the grep operation
"   @param vtf Variable to find
"   @param fm File matching includes
"   @param sd Starting Directory
"   @param exd Directories to exclude
fun! s:execute_grep(vtf, fm, sd, exd)
    " create command 
    let l:cmd = 'grep ' . g:findvar_base_cmds . ' ' . a:vtf . a:fm . a:exd . ' ' . g:findvar_extra_cmds . ' ' . a:sd
    " grab results from executing command
    silent let l:results = systemlist(l:cmd)
    return l:results
endfun
" - display findvar results to user in separate window
" - second param is window direction. options are 'v' (vertical split) or
"   anything else for horizontal split
fun! s:write_results_to_window(results, wind)
    let l:name = '__FindVar_Results__.findvar'
    " check if buffer already exists
    if bufwinnr(l:name) == -1
        if a:wind == 'v'
            " create new split view with given name
            execute 'vsplit ' . l:name
        else 
            " create new split view with given name
            execute 'split ' . l:name
        endif
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
    " jump back to top of file
    normal! gg
endfun

" - Clean the given wind
" - returns 'v' if wind is 'v' otherwise ''
fun! s:wind_clean(wind)
    if a:wind == 'v'
        return 'v'
    endif
    return ''
endfun

" - public functions
" - Execute the grep command and display results in a new window
function! findvar#FindVar(...)
    " create local variables
    let l:starting_directory = ''
    let l:var_to_find = ''
    let l:file_matching = ''
    " window direction. default is vertical split
    let l:wind = 'h'
    " look to see if a starting directory was given
    if a:0 > 0
        if a:1 == ''
            let l:starting_directory = getcwd()
        else
            let l:starting_directory = a:1
        endif
    else
        let l:starting_driectory = getcwd()
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
    if a:0 > 3
        let l:wind = s:wind_clean(a:4)
    endif
    " currently not accepting exclude dirs on the fly
    " TODO change this to handle that
    let l:exclude_dirs = s:exclude_dirs('')
    let l:results = s:execute_grep(l:var_to_find, l:file_matching, l:starting_directory, l:exclude_dirs)
    call s:write_results_to_window(l:results, l:wind)
    " reset syntax
    execute "syntax on"
    " add current searched word to be syntax highlighted
    execute "syntax match FindVarWord \"" . l:var_to_find ."\""
    " turn on a cursorline
    execute "set cursorline"
    
    " this didn't work for security reasons
    " nmap <buffer> <expr> <CR> Enter_key()

    " go back to previous window
    " execute "wincmd p"
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
" Open file from findvar results view when user presses enter
fun! findvar#OpenFile()
    let l:current_file_name = expand('%')
    if l:current_file_name !~ "\.*.findvar"
        echom "not a findvar file"
        return
    endif
    " get line under cursor
    let l:line_val = getline('.')
    let l:line_words = split(l:line_val, ':')
    if len(l:line_words) < 3
        return
    endif
    let l:file_name = l:line_words[0]
    let l:line_num = str2nr(l:line_words[1])
    echom "opening file '" . l:file_name . "' to line '" . l:line_num
    if !filereadable(l:file_name)
        echom "cannot read given file"
        return
    endif
    if type(l:line_num) != type(0)
        echom "could not find line number. defaulted to 0"
        let l:line_num = 0
    endif
    if bufwinnr(l:file_name) == -1
        " create new split view with given name
        silent execute "vsplit " . l:file_name
    else
        " move focus to the window 
        silent execute bufwinnr(l:file_name) . 'wincmd w'
    endif
    silent execute 'normal ' . l:line_num . 'gg'
    execute "set nocul"
endfun
