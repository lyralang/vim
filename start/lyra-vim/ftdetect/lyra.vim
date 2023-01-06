" use `set filetype` to override default filetype=xml for *.ts files
autocmd BufNewFile,BufRead *.ly  set filetype=lyra
" use `setfiletype` to not override any other plugins like ianks/vim-tsx
autocmd BufNewFile,BufRead *.lyra setfiletype lyra
autocmd BufNewFile,BufRead *.lyr setfiletype lyra
" use `setfiletype` to not override any other plugins like ianks/vim-tsx
