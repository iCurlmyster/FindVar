if exists("b:current_syntax")
    finish
endif

syntax match FileName "^[a-zA-Z0-9_/]\+.\w\+"
syntax match LineNumber ":\d\+:"

highlight FileName ctermfg=Green
highlight LineNumber ctermfg=DarkRed
hi FindVarWord term=bold ctermfg=Cyan
hi CursorLine ctermbg=darkgray

let b:current_syntax = "findvar"

