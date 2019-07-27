" Vim syntax file
" Language:    libertybasic
" Maintainer:  Troy Brumley
" Updated:     07/22/2019
"
" Description:
"
"       I'm attmpting to get a syntax for Liberty BASIC working. I
"       started using the various earlier basic syntax files but
"       Liberty BASIC is a much smaller language than VB, QB, and
"       Free BASIC, so I decided to start over from scratch. I may
"       lift some patterns from the Free BASIC syntax file.
"
"       Keywords, function names, and system variable names are pulled
"       from the help file included with the Liberty BASIC 4.5.1
"       environment.
"
" Progress:
"
"   07/24/2019:
"
"   Looking pretty good. No folding support or regions, I've not
"   been able to get syn match to do what I want and it isn't clear
"   to me what I'm doing wrong. I suspect the problem is due to
"   region ends being two word tokens, eg: 'end if'. 
"
"   Folding can be done manually or by indent, so I don't feel any
"   real need to support regions.
"
"   I've lifted one bit of code from freebasic.vim, and it may go
"   back further, to deal with parenthesis errors. This is still
"   commented out but I will try to get it to work.
"
if exists("b:current_syntax")
  finish
endif
syn clear
"
" Liberty BASIC 4.5.1 idiosyncracies:
"
" 1) some global system variable names are case sensitive.
" 2) if/then/else/endif -- there is no elseif.
" 3) the engine is written in Smalltalk, so data typing of variables
"    boils down to numeric or string, and stringness is indicated by
"    the traditional $ appended to the function or variable name.
" 4) branch/function targets can be line numbers or names enclosed
"    in square brackets.
" 5) string variables and functions follow the basic convention of
"    appending a dollar sign ($) to the name. keywords should allow
"    a dollar sign.
" 6) some of the language is case sensitive, and some is not. this
"    syntax file will default to case ignore and only switch to case
"    match when needed, returning to case ignore once done.
" 7) note that the opening paren is part of the function name
"    according to the documentation, but that causes side effects
"    in this definition so I'm going to ignore it in this file.
"
 setlocal iskeyword+=\$
 syn case ignore
"
">>>>keywords, reserved words:
"
 syn keyword lbKeyword BEEP BMPBUTTON BMPSAVE
 syn keyword lbKeyword BUTTON 
 syn keyword lbKeyword CALL CALLBACK CALLDLL CALLFN
 syn keyword lbKeyword CHECKBOX CLS
 syn keyword lbKeyword COLORDIALOG COMBOBOX CONFIRM CURSOR
 syn keyword lbKeyword DIALOG
 syn keyword lbKeyword DUMP 
 syn keyword lbKeyword ERROR EXIT
 syn keyword lbKeyword FILEDIALOG FILES FONTDIALOG
 syn keyword lbKeyword FUNCTION
 syn keyword lbKeyword GOSUB GOTO
 syn keyword lbKeyword GRAPHICBOX GROUPBOX
 syn keyword lbKeyword KILL
 syn keyword lbKeyword LET LISTBOX LOADBMP
 syn keyword lbKeyword MAINWIN MAPHANDLE MENU
 syn keyword lbKeyword NAME NOMAINWIN NONE NOTICE
 syn keyword lbKeyword ON
 syn keyword lbKeyword PASSWORD PLAYMIDI PLAYWAVE
 syn keyword lbKeyword POPUPMENU PRINT PRINTERDIALOG
 syn keyword lbKeyword PROMPT
 syn keyword lbKeyword RADIOBUTTON RANDOM RANDOMIZE
 syn keyword lbKeyword READJOYSTICK
 syn keyword lbKeyword RESUME RETURN RUN
 syn keyword lbKeyword SCAN SORT STATICTEXT
 syn keyword lbKeyword STOP STOPMIDI STRUCT SUB
 syn keyword lbKeyword TEXT TEXTBOX TEXTEDITOR
 syn keyword lbKeyword TIMER TITLEBAR TRACE
 syn keyword lbKeyword UNLOADBMP
 syn keyword lbKeyword WAIT WINDOW
"
">>>>Functions:
"
 syn keyword lbFunction ABS ACS AFTER$ AFTERLAST$ ASC ASN ATN
 syn keyword lbFunction CHR$ COS
 syn keyword lbFunction DATE$ DECHEX$
 syn keyword lbFunction EVAL EVAL$ EXP
 syn keyword lbFunction HBMP HEXDEC HTTPGET$ HWND
 syn keyword lbFunction INSTR INT
 syn keyword lbFunction LEFT$ LEN LOG LOWER$
 syn keyword lbFunction MAX MIDIPOS MID$ MIN
 syn keyword lbFunction REMCHAR$ REPLSTR$ RIGHT$ RMDIR RND
 syn keyword lbFunction SIN SPACE$ SQR STR$
 syn keyword lbFunction TAB TAN TIME$ TRIM$
 syn keyword lbFunction UPPER$ UPTO$ USING
 syn keyword lbFunction VAL
 syn keyword lbFunction WINSTRING WORD$
"
">>>>System Variables:
"
" note: these are case sensitive in Liberty BASIC so we'll need
" to use a distinctive hilighting to help see when the wrong
" case is used.
"
 syn case match
 syn keyword lbSystemVariable BackgroundColor$
 syn keyword lbSystemVariable ComboboxColor$ CommandLine$
 syn keyword lbSystemVariable DefaultDir$ DisplayHeight DisplayWidth Drives$
 syn keyword lbSystemVariable Err Err$
 syn keyword lbSystemVariable ForegroundColor$
 syn keyword lbSystemVariable Joy1x Joy1y Joy1z Joy1button1 Joy1button2 Joy2x Joy2y Joy2z Joy2button1 Joy2button2
 syn keyword lbSystemVariable ListboxColor$
 syn keyword lbSystemVariable Platform$ PrintCollate PrintCopies PrinterFont$ PrinterName$
 syn keyword lbSystemVariable TextboxColor$ TexteditorColor$
 syn keyword lbSystemVariable Version$
 syn keyword lbSystemVariable WindowHeight WindowWidth
 syn keyword lbSystemVariable UpperLeftX UpperLeftY
 syn case ignore
"
">>>>logical and looping constructs, pulled out of the
">>>>full keyword list for region definition.
" most end constructs, some loop definitions, and some
" other things are 'two words' such as 'end if' and
" 'select case'. Matching isn't working the way I
" expect and since I fold by indent instead of syntax,
" I'm taking the easy way out here and sticking with
" keywords instead of matches.
"
 syn keyword lbConditional IF THEN ELSE END
 syn keyword lbConditional SELECT CASE
 syn keyword lbLoop FOR TO STEP NEXT
 syn keyword lbLoop WHILE WEND
 syn keyword lbLoop DO LOOP UNTIL
"
">>>>Data and type definition:
" some of these are flagged as just keywords, such as dim
" so the highlighting of dim a$(10) makes sense as read.
"
 syn keyword lbKeyword AS DATA DIM READ REDIM RESTORE
 syn keyword lbType BOOLEAN BYREF DATA
 syn keyword lbTYPE DOUBLE DWORD
 syn keyword lbType FIELD GLOBAL LONG
 syn keyword lbType PTR SHORT
 syn keyword lbType ULONG USHORT VOID WORD
"
">>>>File and I/O:
syn keyword lbFile APPEND CLOSE GET GETTRIM INPUT INPUTCSV LINE
syn keyword lbFile LPRINT ONCOMERROR OPEN OUT OUTPUT PRINT PUT
syn keyword lbFile EOF INP INPUT$ INPUTTO$ LOF 
syn keyword lbFile MKDIR RMDIR TXCOUNT
syn keyword lbFile DLL GRAPHICS 
"
">>>>Literals:
" Normal integer
 syn match lbInteger "\<\d\+\>"
" various forms of floating point numbers
 syn match lbFloat "\<\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\=\>"
 syn match lbFloat "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
 syn match lbFloat "\<\d\+e[-+]\=\d\+[fl]\=\>"
" Strings. Since branch labels can be included in print to window,
" make sure they are highlighted.
 syn region lbString  start='"' end='"' contains=lbLabel
"
">>>>Special text matches to highlight in comments
 syn keyword lbTodo contained TODO
"
">>>>Expression Operators:
" Note that NOT is actually a function and not an operator
" in lb 4.5.1.
 syn match lbMathOp "[\+\-\=\*\/\>\<\^]"
 syn keyword lbLogicalOp AND OR XOR NOT
"
">>>>Variable name identifier:
 syn match lbIdentifier  "\<[a-zA-Z][a-zA-Z0-9]*\$*\>"
"
">>>>Labels, as distinct from line numbers:
 syn region lbLabel start="\[" end="\]"
"
">>>>Comments:
"
" comments are either REM or apostrophe opened and end at the end of the
" line. remember to extra highlight TODO. 
" 'rem' format comments must be preceeded by all blanks on the
" line or a colon and blanks, ie, 'rem' is the first token on the
" logical line
"
 syn region lbComment start="\s*'" end="$" contains=lbTodo
 syn region lbComment start="^'" end="$" contains=lbTodo
 syn region lbComment start=":\s*rem" end="$" contains=lbTodo
 syn region lbComment start="^\s*rem" end="$" contains=lbTodo
">>>>>>>>>>IDEAS<<<<<<<<<
"** recognize handle number and variables (#).
"** Catch errors caused by wrong parenthesis.
" from freebasic.vim
"syn region libertybasicParen  transparent start='(' end=')' contains=ALLBUT,@libertybasicParenGroup
"syn match libertybasicParenError ")"
"syn match libertybasicInParen contained "[{}]"
"syn cluster libertybasicParenGroup contains=libertybasicParenError,lbSpecial,lbTodo,libertybasicUserCont,libertybasicUserLabel,libertybasicBitField
"** is there a way to highlight graphic commands inside strings?
"** hilight #filehandles in either numeric or alpha format
"
" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_lbasic_syntax_inits")
  if version < 508
    let did_lbasic_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink lbDateTime     Type
  HiLink lbType         Type
  HiLink lbFunction     Function
  HiLink lbSystemVariable Special
  HiLink lbString       String
  HiLink lbMathOp       Operator
  HiLink lbLogicalOp    Operator
  HiLink lbInteger      Number
  HiLink lbFloat        Number
  HiLink lbTodo         Todo
  HiLink lbKeyword      Statement
  HiLink lbComment      Comment
  HiLink lbLoop         Repeat
  HiLink lbConditional  Conditional
  HiLink lbLabel        Identifier
  HiLink lbFile         Statement
  HiLink lbIdentifier   Identifier
 delcommand HiLink
endif

let b:current_syntax = "libertybasic"

" vim: ts=4
