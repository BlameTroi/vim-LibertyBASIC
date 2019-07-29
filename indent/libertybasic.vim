" Vim indent file
" Language:    basic, but really Liberty BASIC
" Maintainer:  Troy Brumley
" Created:     2019 Jul 24
" Last Change: 2019 Jul 29
"
" In creating an indent file, I looked to Neil Carter's rather clean
" Pascal implementation dated 2017 Jun 13.
"
" Bugs:
"
" a [label] inside a loop or if construct can throw off indenting for
" the block. everything syncs back up eventually, and it isn't a
" common way to code something, so i ignore it for now.
"
" Maintenance Log:
"
" 2019/07/29 Correct indenting on select case/case blocks. Line
"            up the subsequent case lines under the select, indent
"            under the case lines, out outdent back to select level
"            at end case
" 2019/07/29 handle for:next on one line, don't reformat the
"            statement, just don't indent under it
" 2019/07/29 handle while:wend on one line, don't reformat the
"            statement, just don't indent under it
" 2019/07/29 reindented this, just because
"
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1
setlocal indentexpr=GetLibertyBasicIndent(v:lnum)
" We're not going to use the cindent keys, so build indentkeys up
" from scratch
setlocal indentkeys=!^F
setlocal indentkeys+=o
setlocal indentkeys+=O
setlocal indentkeys+==~sub
setlocal indentkeys+==~function
setlocal indentkeys+==~if
setlocal indentkeys+==~else
setlocal indentkeys+==~end
setlocal indentkeys+==~while
setlocal indentkeys+==~wend
setlocal indentkeys+==~do
setlocal indentkeys+==~loop
setlocal indentkeys+==~for
setlocal indentkeys+==~next
setlocal indentkeys+==~case


if exists("*GetLibertyBasicIndent")
    finish
endif


function! s:GetPrevNonCommentLineNum( line_num )

    " Skip lines starting with a comment

    let nline = a:line_num
    while nline > 0
        let nline = prevnonblank(nline-1)
        if getline(nline) !~? "^\s*\'"
            break
        endif
    endwhile

    return nline

endfunction


function! GetLibertyBasicIndent( line_num )

    " Line 0 always goes at column 0
    if a:line_num == 0
        return 0
    endif

    let this_codeline = getline( a:line_num )

    " subs, functions, line numbers
    if this_codeline =~? '^\s*\(sub\|function\)\>'
        return 0
    endif
    if this_codeline =~ '^\s*\d\+\>'
        return 0
    endif

    " [labels], let's try starting at 0
    if this_codeline =~? '^\s*\['
        return 0
    endif

    " OTHERWISE, WE NEED TO LOOK FURTHER BACK...

    let prev_codeline_num = s:GetPrevNonCommentLineNum( a:line_num )
    let prev_codeline = getline( prev_codeline_num )
    let indnt = indent( prev_codeline_num )

    " if first line is not a sub/function/label, force the indent
    if indnt == -1
        let indnt = 0
    endif

    " INCREASE INDENT

    " increase indent under subs and functions -but- not line numbers
    if prev_codeline =~? '^\s*\(sub\|function\)\>'
        return indnt + shiftwidth()
    endif

    " increase indent under if then, this should handle the 
    " if blah then goto xxxx and if blah then single-expression
    if prev_codeline =~? '\<then\s*$'
        return indnt + shiftwidth()
    endif

    " increase indent under do
    if prev_codeline =~? '^\s*do\>'
        return indnt + shiftwidth()
    endif

    " while
    " And sometimes people put wend on the same line as while ...
    " this isn't going to handle wend in a comment nor wend in a
    " string, but really, that'd be badly written code
    if prev_codeline =~? '^\s*while\>'
        if prev_codeline =~? '\<wend\>'
            return indnt
        else
            return indnt + shiftwidth()
        endif
    endif

    " for
    " And sometimes people put next on the same line as for
    " this isn't going to handle next in a comment nor next in a
    " string, but really, that'd be badly written code
    if prev_codeline =~? '^\s*for\>'
        if prev_codeline =~? '\<next\>'
            return indnt
        else
            return indnt + shiftwidth()
        endif
    endif

    " case, but not select ... line up case with its select
    if prev_codeline =~? '^\s*case\>'
        return indnt + shiftwidth()
    endif

    " [label] <- note there is no corresponding outdent since
    " these aren't really block markers.
    if prev_codeline =~? '^\s*\['
        return indnt + shiftwidth()
    endif

    "
    " DECREASE INDENT

    " Lines starting with "else"
    if this_codeline =~? '^\s*else\>'
        return indnt - shiftwidth()
    endif

    " lines starting with "end"
    if this_codeline =~? '^\s*end\>'
        return indnt - shiftwidth()
    endif

    " lines starting with "loop"
    if this_codeline =~? '^\s*loop\>'
        return indnt - shiftwidth()
    endif

    " and lines starting with "wend"
    if this_codeline =~? '^\s*wend\>'
        return indnt - shiftwidth()
    endif

    " and lines starting with "next"
    if this_codeline =~? '^\s*next\>'
        return indnt - shiftwidth()
    endif

    " and lines starting with "case"
    if this_codeline =~? '^\s*case\>'
        " unless prior codeline was a "select"
        if prev_codeline =~? '^\s*select\>'
            return indnt
        else
            return indnt - shiftwidth()
        endif
    endif

    " If nothing changed, return same indent.
    return indnt

endfunction

