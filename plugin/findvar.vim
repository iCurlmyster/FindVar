" set up FindVar command so you don't have to do :call FindVar
:command! -nargs=* FindVar :call findvar#FindVar(<args>)

