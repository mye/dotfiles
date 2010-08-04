" Vim syntax file
" Language:	fnotes (folded notes syntax)
" Maintainer:	Lorenz Köhl (lorenz@quub.de)
" Last Change:	2010 Apr 17

" Quit when a (custom) syntax file was already loaded
if exists("g:fnotes_debug_mode")
  syntax clear
  syntax sync fromstart
elseif exists("b:current_syntax")
  finish
endif

syn keyword fnNote		note: Note: NOTE: Notes:
syn keyword fnFix		FIXME fixme: Fixme: FIXME: XXX XXX:
syn keyword fnTodo		TODO TODO: ToDo: Todo Todo:
syn match fnHyperTextJump	"\\\@<!|[#-)!+-~]\+|" contains=fnBar
syn match fnHyperTextEntry	"\*[#-)!+-~]\+\*\s"he=e-1 contains=fnStar
syn match fnHyperTextEntry	"\*[#-)!+-~]\+\*$" contains=fnStar
syn match fnBar			contained "|"
syn match fnStar		contained "\*"
syn match fnTitle		"\v\C^\s*\zs[A-ZÄÖÜ]{3,}%([A-ZÄÖÜ]|\d|\s)*$"

hi! def link fnNote		Todo
hi! def link fnTodo		Todo
hi! def link fnFix		Error
hi! def link fnHyperTextJump	Subtitle
hi! def link fnBar		Ignore
hi! def link fnStar		Ignore
hi! def link fnTitle		Label
hi! def link fnHyperTextEntry	String

let b:current_syntax = "fnotes"


" vim: ts=8 sw=2
