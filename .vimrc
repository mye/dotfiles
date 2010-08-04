set nocompatible  " Do not pretend to be baroque
set encoding=utf-8 " utf-16, nothing or ucs-2le
set guioptions=-M " prevent menu loading! Menus are braindamage, they remind
                  " you of things you had mercifully forgotten existed.

"if has("gui_running")
  "set runtimepath+=~/.vim,~/.vim/after  " Because winvim wins not for using windows paths
"endif

" Thanks to godlygeek for foldexpr and base config, without which my believe
" in the possibility of sane [vim] config files would have collapsed.

if version >= 700
""" Settings
"""" Unsorted
"set exrc
set fillchars=fold:\ 
set shiftround
set noerrorbells
set novisualbell
set smarttab
set nowrap
set ch=2

"""" Display
set nonumber                " Display line numbers not
set numberwidth=1           " using only 1 column (and 1 space) while possible

if &enc =~ '^u\(tf\|cs\)'   " When running in a Unicode environment,
  set list                  " visually represent certain invisible characters:
  let s:arr = nr2char(9655) " using U+25B7 (▷) for an arrow, and
  let s:dot = nr2char(8901) " using U+22C5 (⋅) for a very light dot,
  " display tabs as an arrow followed by some dots (▷⋅⋅⋅⋅⋅⋅⋅),
  exe "set listchars=tab:"    . s:arr . s:dot
  " and display trailing and non-breaking spaces as U+22C5 (⋅).
  exe "set listchars+=trail:" . s:dot
  exe "set listchars+=nbsp:"  . s:dot
  " Also show an arrow+space (↪ ) at the beginning of any wrapped long lines?
  let &sbr=nr2char(8618).' '
endif

"""" Statusline
set laststatus=2
function! Fenc()
  if &fenc !~ "^$\|utf-8" || &bomb
    return &fenc . (&bomb ? "-bom" : "" )
  else
    return ""
  endif
endfunction
" %#StatusFileName# %#StatusRight#
"  "\ [%n] forget the buffer number
"set statusline+=%#StatusFileType#\ %-0.20{StatusLineGetPath()}%0* " filetype

set statusline=%#StatusBufNr#\ %f\ %h%m%r%w%=
set statusline+=[%{&fileformat}]\ [%{Fenc()}]
"set statusline+=\ \/\ %{strlen(&ft)?&ft:'**'}%{CodingStyle()=='none'?'':CodingStyle()}\ 
set statusline+=\ %y
set statusline+=\ [%P]\ %4l\,%-3c\ Hex:\ %-4B\ 

"""" Folding
"set foldmethod=syntax       " By default, use syntax to determine folds
set foldlevelstart=99       " All folds open by default
"""" Text Formatting
set formatoptions=q         " Format text with gq, but don't format as I type.
set formatoptions+=n        " gq recognizes numbered lists, and will try to
set formatoptions+=1        " break before, not after, a 1 letter word
set formatoptions-=ro       " turn of comment auto inserting for open/return
"""" Mouse, Keyboard, Terminal
"set mouse=nv                " Allow mouse use in normal and visual mode.
set mouse=a                 " Allow mouse use
set clipboard=unnamed
set ttymouse=xterm2         " Most terminals send modern xterm mouse reporting
                            " but this isn't always detected in GNU Screen.
set timeoutlen=2000         " Wait 2 seconds before timing out a mapping
set ttimeoutlen=100         " and only 100 ms before timing out on a keypress.
set lazyredraw              " Avoid redrawing the screen mid-command.
set ttyscroll=3             " Prefer redraw to scrolling for more than 3 lines
set ttyfast                 " Send more characters to terminal

" XXX Fix a vim bug: Only t_te, not t_op, gets sent when leaving an alt screen
exe "set t_te=" . &t_te . &t_op

"""" Moving Around/Editing
set nostartofline           " Avoid moving cursor to BOL when jumping around
set whichwrap=b,s,h,l,<,>   " <BS> <Space> h l <Left> <Right> can change lines
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=0             " Keep 0 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set matchtime=2             " (for only .2 seconds).

"""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

"""" Windows, Buffers, Tabpage
set noequalalways           " Don't keep resizing all windows to the same size
set hidden                  " Hide modified buffers when they are abandoned
set swb=useopen,usetab      " Allow changing tabs/windows for quickfix/:sb/etc
set splitright              " New windows open to the right of the current one
set showtabline=2           " Always show tab line

"""" Insert completion
set completeopt-=preview    " Don't show preview menu for tags.
set infercase               " Try to adjust insert completions for case.

"""" Messages, Info, Status
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess=aOstT

set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.

"let &statusline = '%<%f%{&mod?"[+]":""}%r%'
" \ . '{&fenc !~ "^$\\|utf-8" || &bomb ? "[".&fenc.(&bomb?"-bom":"")."]" : ""}'
" \ . '%='
" \ . '%{exists("actual_curbuf")&&bufnr("")==actual_curbuf?CountMatches(1):""}'
" \ . '%15.(%l,%c%V %P%)'

"""" Indent/Tabs Levels
set autoindent              " Do dumb autoindentation when no filetype is set
set tabstop=8               " Real tab characters are 8 spaces wide,
set shiftwidth=2            " but an indent level is 2 spaces wide.
set softtabstop=2           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.

"""" Tags
set tags=./tags;/home       " Tags can be in ./tags, ../tags, ..., /home/tags.
set showfulltag             " Show more information while completing tags.
set cscopetag               " When using :tag, <C-]>, or "vim -t", try cscope:
set cscopetagorder=0        " try ":cscope find g foo" and then ":tselect foo"

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.
set fileencodings=ucs-bom,utf-8,default,latin1

"""" Backups/Swap Files
" Make sure that the directory where we want to put swap/backup files exists.
if ! len(glob("~/.backup/"))
  echomsg "Backup directory ~/.backup doesn't exist!"
endif

set writebackup             " Make a backup of the original file when writing
set backup                  " and don't delete it after a succesful write.
set backupskip=             " There are no files that shouldn't be backed up.
set updatetime=2000         " Write swap files after 2 seconds of inactivity.
set backupext=~             " Backup for "file" is "file~"
set backupdir^=~/.backup    " Backups are written to ~/.backup/ if possible.
set directory^=~/.backup//  " Swap files are also written to ~/.backup, too.
" ^ Here be magic! Quoth the help:
" For Unix and Win32, if a directory ends in two path separators "//" or "\\",
" the swap file name will be built from the complete path to the file with all
" path separators substituted to percent '%' signs.  This will ensure file
" name uniqueness in the preserve directory.

"""" Command Line
set history=1000            " Keep a very long command-line history.
set wildmenu                " Menu completion in command mode on <Tab>
set wildmode=full           " <Tab> cycles between all matching choices.
set wcm=<C-Z>               " Ctrl-Z in a mapping acts like <Tab> on cmdline
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.lo
set wildignore=*.o,*.obj,*.bak,*.exe,*~,*.dll,*.pyc
"source $VIMRUNTIME/menu.vim " Load menus (this would be done anyway in gvim)
" <F4> triggers the menus, even in terminal vim.
"map <F4> :emenu <C-Z>

"""" Per-Filetype Scripts
" NOTE: These define autocmds, so they should come before any other autocmds.
"       That way, a later autocmd can override the result of one defined here.
filetype on                 " Enable filetype detection,
filetype indent on          " use filetype-specific indenting where available,
filetype plugin on          " also allow for filetype-specific plugins,
syntax on                   " and turn on per-filetype syntax highlighting.

""" Plugin settings
let lisp_rainbow=1          " Color parentheses by depth in LISP files.
let is_posix=1              " I don't use systems where /bin/sh isn't POSIX.
let bufExplorerFindActive=0 " Disable emulated 'switchbuf' from BufExplorer
let vim_indent_cont=4       " Spaces to add for vimscript continuation lines
let no_buffers_menu=1       " Disable gvim 'Buffers' menu
let surround_indent=1       " Automatically reindent text surround.vim actions
let html_number_lines = 0 " don't show line numbers
let html_use_css = 1      " don't use inline stylesheets
let html_no_pre = 1       " don't enclose in <pre> tags

""" Key Mappings
let mapleader = ","
"""" Leader: Normal mode formatting
nnoremap <leader>> >']
nnoremap <leader>< <']
nnoremap <leader><space> i<space><esc>
nnoremap <leader>> >']
nnoremap <leader><cr> o<esc>
" Insert a modeline on the last line with <leader>ml
nmap <leader>ml :$put =ModelineStub()<CR>

" Use \sq to squeeze blank lines with :Squeeze, defined below
nnoremap <leader>sq :Squeeze<CR>
"""" Leader: clipboard integration for vim
nnoremap <silent> <leader>p :call Getclip()<CR>
nnoremap <silent> <leader>y :call Putclip('n', 1)<CR>
vnoremap <silent> <leader>y :call Putclip(visualmode(), 1)<CR>

"""" Leader: buffers / cmdline
nnoremap <leader>, :ls<cr>:b
nnoremap <leader>e :e ~/.vimrc<cr>
nnoremap <silent> <Leader>bd :Bclose<CR>
nnoremap <Leader>j :bp<CR>
nnoremap <Leader>k :bn<CR>
" <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-6> <C-6>`"
nnoremap <leader>l :e#<cr>`"
nnoremap <leader>ww :wa<cr>
nnoremap <leader>wq :w<cr>:Bclose!<cr>
nnoremap <leader>wl :w<cr>:e#<cr>

"""" command mode
cnoremap <C-a>     <Home>
cnoremap <C-e>     <End>
cnoremap <C-n>     <Up>
cnoremap <C-b>     <S-Left>
cnoremap <C-f>     <S-Right>

"""" Formats and stuff
" Tapping C-W twice brings me to previous window, not next.
nnoremap <C-w><C-w> :winc p<CR>
" Get old behavior with <C-w><C-e>
nnoremap <C-w><C-e> :winc w<CR>
" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>
map Q gq| map QQ gqip
" ease command entering
map ; :
" my shortcuts for dealing with folds
nmap s za| nmap S [z| nmap <C-s> ]z
" Yank like D deletes
nnoremap Y y$
" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

nnoremap <F1> "=strftime("%d. %B %Y, %A")<CR>p

""" Functions and Commands
let g:statusline_max_path = 20
"""" LastModified
function! LastModified()
  if &modified
    normal ms
    let n = min([20, line("$")])
    exe '1,' . n . 's#^\(.\{,10}Last modified: \).*#\1' .
          \ strftime('%a %b %d, %Y  %I:%M%p') . '#e'
    normal `s
  endif
endfun

"""" StatusLineGetPath
function! StatusLineGetPath() "{{{2
  let p = expand('%:.:h') "relative to current path, and head path only
  let p = substitute(p,'\','/','g')
  let p = substitute(p, '^\V' . $HOME, '~', '')
  if len(p) > g:statusline_max_path
    let p = simplify(p)
    let p = pathshorten(p)
  endif
  return p
endfunction

"""" Getclip
function! Getclip()
  "let reg_save = @@
  "let @@ = system('getclip')
  setlocal paste
  "exe 'normal p'
  exe 'normal "+p'
  setlocal nopaste
  "let @@ = reg_save
endfunction
"""" Putclip
function! Putclip(type, ...) range
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@
  if a:type == 'n'
    silent exe a:firstline . "," . a:lastline . "y"
  elseif a:type == 'c'
    silent exe a:1 . "," . a:2 . "y"
  else
    silent exe "normal! `<" . a:type . "`>y"
  endif
  "call system('putclip', @@)
  let @+ = @@
  let &selection = sel_save
  let @@ = reg_save
endfunction

let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

"""" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

"""" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
  " try to find bufnr of current buffer (to be closed)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
 " check  if a buffer was found and doesn't have changes
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " find out which windows display our prey
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  " switch the windows to to other buffers
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>', '<args>')

"""" Assign foldlevel to lines based on an indent tree structure
let s:tfoldlvl = 0
func! TreeFold(lnum)
  let line = getline(a:lnum)
  let indent = indent(a:lnum)
  " Any line could be the beginning of a new fold
  if -1 != match(line, '\v\C^\s*\zs[A-ZÄÖÜ]{3,}%([A-ZÄÖÜ]|\d|\s)*$') &&
      \ indent < indent(nextnonblank(a:lnum+1))
    let s:tfoldlvl = (indent/&sw+1)
    return '>' . s:tfoldlvl
  elseif line !~ '^\s*$' && indent/&sw+1 <= s:tfoldlvl
    let s:tfoldlvl = indent/&sw
    return s:tfoldlvl
  endif
  return '='
endfunc
"""" Prettier foldtext
function! TreeFoldText()
  let line = getline(v:foldstart)
  return line.
      \ repeat(' ',winwidth(0)-(2+strlen(v:foldend-v:foldstart)+strlen(line))).
      \ (v:foldend-v:foldstart) . "  "
endfunction
"""" Squeeze blank lines with :Squeeze
command! -nargs=0 Squeeze g/^\s*$/,/\S/-j
"""" ModelineStub
function! ModelineStub()
  let fmt = ' vim: set ts=%d sts=%d sw=%d %s: '
  let x = printf(&cms, printf(fmt, &ts, &sts, &sw, (&et?"et":"noet")))
  return substitute(substitute(x, '\ \+', ' ', 'g'), ' $', '', '')
endfunction
""" Colorscheme
if !has("gui_running")
  set t_Co=256
  colorscheme desert256
else
  colorscheme inkpot
endif
source ~/.vim/colors/lorenzk.vim

""" Abbreviations
function! EatChar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
iabbr _me Lorenz Köhl (lorenz@quub.de)
iabbr _. •
iabbr _' ’<C-R>=EatChar('\s')<CR>
iabbr _e …<C-R>=EatChar('\s')<CR>
iabbr _t  <C-R>=strftime("%H:%M:%S")<CR><C-R>=EatChar('\s')<CR>
iabbr _d  <C-R>=strftime("%a, %d %b %Y")<CR><C-R>=EatChar('\s')<CR>
iabbr _dt <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR><C-R>=EatChar('\s')<CR>

" Minus: − Hyphen-minus: -
" Hyphen: ‐ Non-breaking hyphen: ‑ " recreation vs. re-creation

" ⟨ ⟩ "< >

""" Autocommands
if has("autocmd")
  augroup vimrcA
  au!
  " Instantly apply changes to main config after save
  au bufwritepost .vimrc source ~/.vimrc
  " Reload my colors after colorscheme reset
  au ColorScheme * :source ~/.vim/colors/lorenzk.vim
  " Don't remember why I've got this one
  au BufEnter * :syntax sync fromstart
  " Helps with developing regular expressions
  au CmdwinEnter / map <buffer> <cr> <cr>q/k
  au CmdwinEnter / imap <buffer> <cr> <cr>q/k
  "au BufWritePre * call LastModified()
  " Update tags for my main notes file after save
"  au BufWritePost ~/notes/notes.txt helptags ~/notes/
endif

"" >= 700
endif
finish
"" Scrapyard
highlight rightMargin ctermfg=lightblue
match rightMargin /.\%>79v/
inoremap <F1> <C-R>=strftime("%d. %B %Y, %A")<CR>

"" vim:fdm=expr:
"" vim:fde=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='
