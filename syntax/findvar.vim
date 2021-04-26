if exists("b:current_syntax")
    finish
endif

syntax match FileName "^[a-zA-Z0-9_/]\+.\w\+"
syntax match LineNumber ":\d\+:"

highlight FileName ctermfg=Green guifg=Green
highlight LineNumber ctermfg=DarkRed guifg=DarkRed
" FindVarWord is set in FindVar function
hi FindVarWord term=bold ctermfg=Cyan gui=bold guifg=Cyan
hi CursorLine ctermbg=DarkGray guibg=DarkGray

let b:current_syntax = "findvar"

