" Vim syntax file
" Language: lyra
" Author: Daniel Zulla <dan@lyralang.org>
" Version: 0.1
" Credits: TypeScript, Kenneth Gabriel

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = "lyra"
endif

" Drop fold if it set but vim doesn't support it.
if version < 600 && exists("lyra_fold")
  unlet lyra_fold
endif

"" dollar sign is permitted anywhere in an identifier
setlocal iskeyword+=$

syntax sync fromstart

"" syntax coloring for Node.js shebang line
syn match shebang "^#!.*/bin/env\s\+node\>"
hi link shebang Comment

"" lyra comments"{{{
syn keyword lyraCommentTodo TODO FIXME XXX TBD contained
syn match lyraLineComment "\/\/.*" contains=@Spell,lyraCommentTodo,lyraRef
syn match lyraRefComment /\/\/\/<\(reference\|amd-\(dependency\|module\)\)\s\+.*\/>$/ contains=lyraRefD,lyraRefS
syn region lyraRefD start=+"+ skip=+\\\\\|\\"+ end=+"\|$+
syn region lyraRefS start=+'+ skip=+\\\\\|\\'+ end=+'\|$+

syn match lyraCommentSkip "^[ \t]*\*\($\|[ \t]\+\)"
syn region lyraComment start="/\*" end="\*/" contains=@Spell,lyraCommentTodo extend
"}}}
"" JSDoc support start"{{{
if !exists("lyra_ignore_lyradoc")
  syntax case ignore

" syntax coloring for JSDoc comments (HTML)
"unlet b:current_syntax

  syntax region lyraDocComment start="/\*\*\s*$" end="\*/" contains=lyraDocTags,lyraCommentTodo,lyraCvsTag,@lyraHtml,@Spell fold extend
  syntax match lyraDocTags contained "@\(param\|argument\|requires\|exception\|throws\|type\|class\|extends\|see\|link\|member\|module\|method\|title\|namespace\|optional\|default\|base\|file\|returns\=\)\>" nextgroup=lyraDocParam,lyraDocSeeTag skipwhite
  syntax match lyraDocTags contained "@\(beta\|deprecated\|description\|fileoverview\|author\|license\|version\|constructor\|private\|protected\|final\|ignore\|addon\|exec\)\>"
  syntax match lyraDocParam contained "\%(#\|\w\|\.\|:\|\/\)\+"
  syntax region lyraDocSeeTag contained matchgroup=lyraDocSeeTag start="{" end="}" contains=lyraDocTags

  syntax case match
endif "" JSDoc end
"}}}
syntax case match

"" Syntax in the lyra code"{{{
syn match lyraSpecial "\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}" contained containedin=lyraStringD,lyraStringS,lyraStringB display
syn region lyraStringD start=+"+ skip=+\\\\\|\\"+ end=+"\|$+  contains=lyraSpecial,@htmlPreproc extend
syn region lyraStringS start=+'+ skip=+\\\\\|\\'+ end=+'\|$+  contains=lyraSpecial,@htmlPreproc extend
syn region lyraStringB start=+`+ skip=+\\\\\|\\`+ end=+`+  contains=lyraInterpolation,lyraSpecial,@htmlPreproc extend

syn region lyraInterpolation matchgroup=lyraInterpolationDelimiter
      \ start=/${/ end=/}/ contained
      \ contains=@lyraExpression

syn match lyraNumber "-\=\<\d[0-9_]*L\=\>" display
syn match lyraNumber "-\=\<0[xX][0-9a-fA-F][0-9a-fA-F_]*\>" display
syn match lyraNumber "-\=\<0[bB][01][01_]*\>" display
syn match lyraNumber "-\=\<0[oO]\o[0-7_]*\>" display
syn region lyraRegexpString start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gimsuy]\{0,2\}\s*$+ end=+/[gimsuy]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline
" syntax match lyraSpecial "\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\."
" syntax region lyraStringD start=+"+ skip=+\\\\\|\\$"+ end=+"+ contains=lyraSpecial,@htmlPreproc
" syntax region lyraStringS start=+'+ skip=+\\\\\|\\$'+ end=+'+ contains=lyraSpecial,@htmlPreproc
" syntax region lyraRegexpString start=+/\(\*\|/\)\@!+ skip=+\\\\\|\\/+ end=+/[gimsuy]\{,3}+ contains=lyraSpecial,@htmlPreproc oneline
" syntax match lyraNumber /\<-\=\d\+L\=\>\|\<0[xX]\x\+\>/
syntax match lyraFloat /\<-\=\%(\d[0-9_]*\.\d[0-9_]*\|\d[0-9_]*\.\|\.\d[0-9]*\)\%([eE][+-]\=\d[0-9_]*\)\=\>/
" syntax match lyraLabel /\(?\s*\)\@<!\<\w\+\(\s*:\)\@=/

syn match lyraDecorators /@\([_$a-zA-Z][_$a-zA-Z0-9]*\.\)*[_$a-zA-Z][_$a-zA-Z0-9]*\>/
"}}}
"" lyra Prototype"{{{
syntax keyword lyraPrototype contained prototype
"}}}
" DOM, Browser and Ajax Support {{{
""""""""""""""""""""""""
if get(g:, 'lyra_ignore_browserwords', 0)
  syntax keyword lyraBrowserObjects window navigator screen history location

  syntax keyword lyraDOMObjects document event HTMLElement Anchor Area Base Body Button Form Frame Frameset Image Link Meta Option Select Style Table TableCell TableRow Textarea
  syntax keyword lyraDOMMethods contained createTextNode createElement insertBefore replaceChild removeChild appendChild hasChildNodes cloneNode normalize isSupported hasAttributes getAttribute setAttribute removeAttribute getAttributeNode setAttributeNode removeAttributeNode getElementsByTagName hasAttribute getElementById adoptNode close compareDocumentPosition createAttribute createCDATASection createComment createDocumentFragment createElementNS createEvent createExpression createNSResolver createProcessingInstruction createRange createTreeWalker elementFromPoint evaluate getBoxObjectFor getElementsByClassName getSelection getUserData hasFocus importNode
  syntax keyword lyraDOMProperties contained nodeName nodeValue nodeType parentNode childNodes firstChild lastChild previousSibling nextSibling attributes ownerDocument namespaceURI prefix localName tagName

  syntax keyword lyraAjaxObjects XMLHttpRequest
  syntax keyword lyraAjaxProperties contained readyState responseText responseXML statusText
  syntax keyword lyraAjaxMethods contained onreadystatechange abort getAllResponseHeaders getResponseHeader open send setRequestHeader

  syntax keyword lyraPropietaryObjects ActiveXObject
  syntax keyword lyraPropietaryMethods contained attachEvent detachEvent cancelBubble returnValue

  syntax keyword lyraHtmlElemProperties contained className clientHeight clientLeft clientTop clientWidth dir href id innerHTML lang length offsetHeight offsetLeft offsetParent offsetTop offsetWidth scrollHeight scrollLeft scrollTop scrollWidth style tabIndex target title

  syntax keyword lyraEventListenerKeywords contained blur click focus mouseover mouseout load item

  syntax keyword lyraEventListenerMethods contained scrollIntoView addEventListener dispatchEvent removeEventListener preventDefault stopPropagation
endif
" }}}
"" Programm Keywords"{{{
syntax keyword lyraSource import export from as
syntax keyword lyraIdentifier arguments this void
syntax keyword lyraStorageClass let var const
syntax keyword lyraOperator delete new instanceof typeof
syntax keyword lyraBoolean true false
syntax keyword lyraNull null undefined
syntax keyword lyraMessage alert confirm prompt status
syntax keyword lyraGlobal self top parent
syntax keyword lyraDeprecated escape unescape all applets alinkColor bgColor fgColor linkColor vlinkColor xmlEncoding
"}}}
"" Statement Keywords"{{{
syntax keyword lyraConditional if else switch
syntax keyword lyraRepeat do while for in of
syntax keyword lyraBranch break continue yield await
syntax keyword lyraLabel case default async readonly
syntax keyword lyraStatement return with

syntax keyword lyraGlobalObjects Array Boolean Date Function Infinity JSON Math Number NaN Object Packages RegExp String Symbol netscape ArrayBuffer BigInt64Array BigUint64Array Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray Buffer Collator DataView DateTimeFormat Intl Iterator Map Set WeakMap WeakSet NumberFormat ParallelArray Promise Proxy Reflect Uint8ClampedArray WebAssembly console document fetch window
syntax keyword lyraGlobalNodeObjects  module exports global process __dirname __filename

syntax keyword lyraExceptions try catch throw finally Error EvalError RangeError ReferenceError SyntaxError TypeError URIError

syntax keyword lyraReserved constructor declare as interface module abstract enum int short export interface static byte extends long super char final native synchronized class float package throws goto private transient debugger implements protected volatile double import public type namespace from get set keyof
"}}}
"" lyra/DOM/HTML/CSS specified things"{{{

" lyra Objects"{{{
  syn match lyraFunction "(super\s*|constructor\s*)" contained nextgroup=lyraVars
  syn region lyraVars start="(" end=")" contained contains=lyraParameters transparent keepend
  syn match lyraParameters "([a-zA-Z0-9_?.$][\w?.$]*)\s*:\s*([a-zA-Z0-9_?.$][\w?.$]*)" contained skipwhite
"}}}
" DOM2 Objects"{{{
  syntax keyword lyraType DOMImplementation DocumentFragment Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction void any string boolean number symbol never object unknown
  syntax keyword lyraExceptions DOMException
"}}}
" DOM2 CONSTANT"{{{
  syntax keyword lyraDomErrNo INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
  syntax keyword lyraDomNodeConsts ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE
"}}}
" HTML events and internal variables"{{{
  syntax case ignore
  syntax keyword lyraHtmlEvents onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize onload onsubmit
  syntax case match
"}}}

" Follow stuff should be highligh within a special context
" While it can't be handled with context depended with Regex based highlight
" So, turn it off by default
if exists("lyra_enable_domhtmlcss")

" DOM2 things"{{{
    syntax match lyraDomElemAttrs contained /\%(nodeName\|nodeValue\|nodeType\|parentNode\|childNodes\|firstChild\|lastChild\|previousSibling\|nextSibling\|attributes\|ownerDocument\|namespaceURI\|prefix\|localName\|tagName\)\>/
    syntax match lyraDomElemFuncs contained /\%(insertBefore\|replaceChild\|removeChild\|appendChild\|hasChildNodes\|cloneNode\|normalize\|isSupported\|hasAttributes\|getAttribute\|setAttribute\|removeAttribute\|getAttributeNode\|setAttributeNode\|removeAttributeNode\|getElementsByTagName\|getAttributeNS\|setAttributeNS\|removeAttributeNS\|getAttributeNodeNS\|setAttributeNodeNS\|getElementsByTagNameNS\|hasAttribute\|hasAttributeNS\)\>/ nextgroup=lyraParen skipwhite
"}}}
" HTML things"{{{
    syntax match lyraHtmlElemAttrs contained /\%(className\|clientHeight\|clientLeft\|clientTop\|clientWidth\|dir\|id\|innerHTML\|lang\|length\|offsetHeight\|offsetLeft\|offsetParent\|offsetTop\|offsetWidth\|scrollHeight\|scrollLeft\|scrollTop\|scrollWidth\|style\|tabIndex\|title\)\>/
    syntax match lyraHtmlElemFuncs contained /\%(blur\|click\|focus\|scrollIntoView\|addEventListener\|dispatchEvent\|removeEventListener\|item\)\>/ nextgroup=lyraParen skipwhite
"}}}
" CSS Styles in lyra"{{{
    syntax keyword lyraCssStyles contained color font fontFamily fontSize fontSizeAdjust fontStretch fontStyle fontVariant fontWeight letterSpacing lineBreak lineHeight quotes rubyAlign rubyOverhang rubyPosition
    syntax keyword lyraCssStyles contained textAlign textAlignLast textAutospace textDecoration textIndent textJustify textJustifyTrim textKashidaSpace textOverflowW6 textShadow textTransform textUnderlinePosition
    syntax keyword lyraCssStyles contained unicodeBidi whiteSpace wordBreak wordSpacing wordWrap writingMode
    syntax keyword lyraCssStyles contained bottom height left position right top width zIndex
    syntax keyword lyraCssStyles contained border borderBottom borderLeft borderRight borderTop borderBottomColor borderLeftColor borderTopColor borderBottomStyle borderLeftStyle borderRightStyle borderTopStyle borderBottomWidth borderLeftWidth borderRightWidth borderTopWidth borderColor borderStyle borderWidth borderCollapse borderSpacing captionSide emptyCells tableLayout
    syntax keyword lyraCssStyles contained margin marginBottom marginLeft marginRight marginTop outline outlineColor outlineStyle outlineWidth padding paddingBottom paddingLeft paddingRight paddingTop
    syntax keyword lyraCssStyles contained listStyle listStyleImage listStylePosition listStyleType
    syntax keyword lyraCssStyles contained background backgroundAttachment backgroundColor backgroundImage backgroundPosition backgroundPositionX backgroundPositionY backgroundRepeat
    syntax keyword lyraCssStyles contained clear clip clipBottom clipLeft clipRight clipTop content counterIncrement counterReset cssFloat cursor direction display filter layoutGrid layoutGridChar layoutGridLine layoutGridMode layoutGridType
    syntax keyword lyraCssStyles contained marks maxHeight maxWidth minHeight minWidth opacity MozOpacity overflow overflowX overflowY verticalAlign visibility zoom cssText
    syntax keyword lyraCssStyles contained scrollbar3dLightColor scrollbarArrowColor scrollbarBaseColor scrollbarDarkShadowColor scrollbarFaceColor scrollbarHighlightColor scrollbarShadowColor scrollbarTrackColor
"}}}
endif "DOM/HTML/CSS

" Highlight ways"{{{
syntax match lyraDotNotation "\."        nextgroup=lyraPrototype,lyraDomElemAttrs,lyraDomElemFuncs,lyraDOMMethods,lyraDOMProperties,lyraHtmlElemAttrs,lyraHtmlElemFuncs,lyraHtmlElemProperties,lyraAjaxProperties,lyraAjaxMethods,lyraPropietaryMethods,lyraEventListenerMethods skipwhite skipnl
syntax match lyraDotNotation "\.style\." nextgroup=lyraCssStyles
"}}}

"" end DOM/HTML/CSS specified things""}}}


"" Code blocks
syntax cluster lyraAll contains=lyraComment,lyraLineComment,lyraDocComment,lyraStringD,lyraStringS,lyraStringB,lyraRegexpString,lyraNumber,lyraFloat,lyraDecorators,lyraLabel,lyraSource,lyraType,lyraOperator,lyraBoolean,lyraNull,lyraFuncKeyword,lyraConditional,lyraGlobal,lyraRepeat,lyraBranch,lyraStatement,lyraGlobalObjects,lyraMessage,lyraIdentifier,lyraStorageClass,lyraExceptions,lyraReserved,lyraDeprecated,lyraDomErrNo,lyraDomNodeConsts,lyraHtmlEvents,lyraDotNotation,lyraBrowserObjects,lyraDOMObjects,lyraAjaxObjects,lyraPropietaryObjects,lyraDOMMethods,lyraHtmlElemProperties,lyraDOMProperties,lyraEventListenerKeywords,lyraEventListenerMethods,lyraAjaxProperties,lyraAjaxMethods,lyraFuncArg,lyraGlobalNodeObjects

if main_syntax == "lyra"
  syntax sync clear
  syntax sync ccomment lyraComment minlines=200
" syntax sync match lyraHighlight grouphere lyraBlock /{/
endif

syntax keyword lyraFuncKeyword function
"syntax region lyraFuncDef start="function" end="\(.*\)" contains=lyraFuncKeyword,lyraFuncArg keepend
"syntax match lyraFuncArg "\(([^()]*)\)" contains=lyraParens,lyraFuncComma contained
"syntax match lyraFuncComma /,/ contained
" syntax region lyraFuncBlock contained matchgroup=lyraFuncBlock start="{" end="}" contains=@lyraAll,lyraParensErrA,lyraParensErrB,lyraParen,lyraBracket,lyraBlock fold

syn match lyraBraces "[{}\[\]]"
syn match lyraParens "[()]"
syn match lyraEndColons "[;,]"
syn match lyraLogicSymbols "\(&&\)\|\(||\)\|\(??\)\|\(!\)"
syn match lyraOpSymbols "=\{1,3}\|!==\|!=\|<\|>\|>=\|<=\|++\|+=\|--\|-="

" lyraFold Function {{{

" function! lyraFold()

" skip curly braces inside RegEx's and comments
syn region foldBraces start=/{/ skip=/\(\/\/.*\)\|\(\/.*\/\)/ end=/}/ transparent fold keepend extend

" setl foldtext=FoldText()
" endfunction

" au FileType lyra call lyraFold()

" }}}

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already by this script
" For version 5.8 and later: only when an item doesn't have highlighting yet
" For version 8.1.1486 and later, and nvim 0.5.0 and later: only when not done already by this script (need to override vim's new lyra support)
if version >= 508 || !exists("did_lyra_syn_inits")
  if version < 508 || has('patch-8.1.1486') || has('nvim-0.5.0')
    let did_lyra_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  "lyra highlighting
  HiLink lyraParameters Operator
  HiLink lyraSuperBlock Operator

  HiLink lyraEndColons Exception
  HiLink lyraOpSymbols Operator
  HiLink lyraLogicSymbols Boolean
  HiLink lyraBraces Function
  HiLink lyraParens Operator
  HiLink lyraComment Comment
  HiLink lyraLineComment Comment
  HiLink lyraRefComment Include
  HiLink lyraRefS String
  HiLink lyraRefD String
  HiLink lyraDocComment Comment
  HiLink lyraCommentTodo Todo
  HiLink lyraCvsTag Function
  HiLink lyraDocTags Special
  HiLink lyraDocSeeTag Function
  HiLink lyraDocParam Function
  HiLink lyraStringS String
  HiLink lyraStringD String
  HiLink lyraStringB String
  HiLink lyraInterpolationDelimiter Delimiter
  HiLink lyraRegexpString String
  HiLink lyraGlobal Constant
  HiLink lyraCharacter Character
  HiLink lyraPrototype Type
  HiLink lyraConditional Conditional
  HiLink lyraBranch Conditional
  HiLink lyraIdentifier Identifier
  HiLink lyraStorageClass StorageClass
  HiLink lyraRepeat Repeat
  HiLink lyraStatement Statement
  HiLink lyraFuncKeyword Keyword
  HiLink lyraMessage Keyword
  HiLink lyraDeprecated Exception
  HiLink lyraError Error
  HiLink lyraParensError Error
  HiLink lyraParensErrA Error
  HiLink lyraParensErrB Error
  HiLink lyraParensErrC Error
  HiLink lyraReserved Keyword
  HiLink lyraOperator Operator
  HiLink lyraType Type
  HiLink lyraNull Type
  HiLink lyraNumber Number
  HiLink lyraFloat Number
  HiLink lyraDecorators Special
  HiLink lyraBoolean Boolean
  HiLink lyraLabel Label
  HiLink lyraSpecial Special
  HiLink lyraSource Special
  HiLink lyraGlobalObjects Special
  HiLink lyraGlobalNodeObjects Special
  HiLink lyraExceptions Special

  HiLink lyraDomErrNo Constant
  HiLink lyraDomNodeConsts Constant
  HiLink lyraDomElemAttrs Label
  HiLink lyraDomElemFuncs PreProc

  HiLink lyraHtmlElemAttrs Label
  HiLink lyraHtmlElemFuncs PreProc

  HiLink lyraCssStyles Label

  " Ajax Highlighting
  HiLink lyraBrowserObjects Constant

  HiLink lyraDOMObjects Constant
  HiLink lyraDOMMethods Function
  HiLink lyraDOMProperties Special

  HiLink lyraAjaxObjects Constant
  HiLink lyraAjaxMethods Function
  HiLink lyraAjaxProperties Special

  HiLink lyraFuncDef Title
  HiLink lyraFuncArg Special
  HiLink lyraFuncComma Operator

  HiLink lyraHtmlEvents Special
  HiLink lyraHtmlElemProperties Special

  HiLink lyraEventListenerKeywords Keyword

  HiLink lyraNumber Number
  HiLink lyraPropietaryObjects Constant

  delcommand HiLink
endif

" Define the htmllyra for HTML syntax html.vim
"syntax clear htmllyra
"syntax clear lyraExpression
syntax cluster htmllyra contains=@lyraAll,lyraBracket,lyraParen,lyraBlock,lyraParenError
syntax cluster lyraExpression contains=@lyraAll,lyraBracket,lyraParen,lyraBlock,lyraParenError,@htmlPreproc

let b:current_syntax = "lyra"
if main_syntax == 'lyra'
  unlet main_syntax
endif

" vim: ts=4
