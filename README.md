# vim-LibertyBASIC

A minimal set of vim script files to support editing of
Liberty BASIC source code.

Liberty BASIC is a small but effective BASIC implementation
for desktop environments. See https://libertybasic.com/ for
more information about the language.

## what this package provides

Simple indent and syntax highlighting. I prefer to use indent
as my foldmethod so the syntax doesn't attempt to support
folding.

## installation

Note that Liberty BASIC uses the .bas file extension,
which conflicts with the vim standard installation version
of filetype.vim's assumption that .bas files are either for
VB or "standard" basic. A small change is needed in
filetype.vim.

To install, copy the files to your ~/.vim/ directory or
platform equivalent. If you already have a personal copy of
filetype.vim, change it as follows. If you do not, copy the
installation copy of filetype.vim to your ~/.vim/ directory
and then change it.

### filetype.vim changes

around line 197, reading "BASIC or Visual Basic", replace the line

    au BufNewFile,BufRead *.bas     call dist#ft#FTVB("basic")

with

    au BufNewFile,BufRead *.bas     setf libertybasic

Or change the argument on the call to dist#ft#FTVB to "libertybasic"
if you also edit VB files in vim.

## License

This code is released under the MIT license. Feel free to offer
corrections or suggestions. Thanks.
