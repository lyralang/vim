if exists("current_compiler")
  finish
endif
let current_compiler = "lyra"

if !exists("g:lyra_compiler_binary")
  let g:lyra_compiler_binary = "lyb"
endif

if !exists("g:lyra_compiler_options")
  let g:lyra_compiler_options = ""
endif

if exists(":CompilerSet") != 2
  command! -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

execute 'CompilerSet makeprg='
      \ . escape(g:lyra_compiler_binary, ' ')
      \ . '\ '
      \ . escape(g:lyra_compiler_options, ' ')
      \ . '\ $*\ %'

CompilerSet errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m

let &cpo = s:cpo_save
unlet s:cpo_save
