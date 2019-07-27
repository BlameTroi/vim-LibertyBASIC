" BASIC or Visual Basic
" txb--------------------------------------
" the default filetype.vim forces an assumption
" that any *.bas file that doesn't look like a
" vb file is a 'basic' file. i haven't found a
" way to override that without changing the
" filetype.vim script itself.
" txb--------------------------------------
" au BufNewFile,BufRead *.bas			call dist#ft#FTVB("basic")
au BufRead,BufNewFile *.bas setf libertybasic
