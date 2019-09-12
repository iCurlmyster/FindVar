" set up FindVar command so you don't have to do :call FindVar
:command! -nargs=* FindVar         :call findvar#FindVar(<args>)
:com!     -nargs=* FindVarWithWord :call findvar#FindVarWithWord(<args>)
:com!     -nargs=? FindVarInFiles  :call findvar#FindVarInFiles(<args>)
:com!              FindVarOpenFile :call findvar#OpenFile()

