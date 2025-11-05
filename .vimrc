set t_Co=256

" probably only works consistently with iTerm2
set term=xterm-256color

set nocompatible

filetype plugin indent on

" disable swap files - live dangerously
set noswapfile

" show line numbers
set number

" enable syntax highlighting
syntax enable

set backspace=indent,eol,start

" set file name previewing/completion options (eg, for opening files)
set wildmode=longest,list,full
set wildmenu

" set tabs to have 4 spaces
set tabstop=4

" expand tabs into spaces
set expandtab

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

" show a visual line under the cursor's current line
"set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" indent when moving to the next line while writing code
set autoindent

" just better in general
set background=dark

" the default comment color makes puppies cry
hi Comment ctermfg=DarkGreen
hi String ctermfg=DarkRed


""" python stuff

"" Number of spaces that a pre-existing tab is equal to.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4

"spaces for indents
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.py set softtabstop=4

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.html,*.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
"au BufRead,BufNewFile *.py,*.pyw, set textwidth=100

" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

" Set the default file encoding to UTF-8:
set encoding=utf-8

" For full syntax highlighting:
let python_highlight_all=1

" Keep indentation level from previous line:
autocmd FileType python set autoindent

" folding stuff
"   toggle current fold: za
"   un/fold all: zR/zM
"set foldmethod=indent
"set foldnestmax=2
"hi Folded ctermbg=black
"hi Folded ctermfg=darkgrey
