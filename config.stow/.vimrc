let mapleader=','

filetype off                  " required for vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" ----- Vim as a programmer's text editor -----------------------------
Plugin 'vim-latex/vim-latex'
Plugin 'w0rp/ale'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'airblade/vim-gitgutter'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'Konfekt/FastFold'

call vundle#end()

" ----- vim-latex/vim-latex -----
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_dvi = 'latex -interaction=nonstopmode $*'
let g:Tex_ViewRule_pdf = 'zathura'
let g:Tex_MultipleCompileFormats='pdf,bib,pdf'

" ----- w0rp/ale -----
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_linters = {'cpp': ['g++']}

" ----- ntpeters/vim-better-whitespace -----
let g:better_whitespace_enabled=1

" ----- Konfekt/FastFold -----
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
let g:tex_fold_enabled = 1

" -----------------------------------------------------------------------------
" Mappings

" Toggle highlight search
nnoremap <F3> :set hlsearch!<CR>

" Cycle through completions with TAB (and SHIFT-TAB cycles backwards)
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
   elseif "backward" == a:direction
        return "\<c-p>"
    else
        return "\<c-n>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>

" Switch buffers quickly
map <leader>q : bp<CR>
map <leader>w : bn<CR>

" Toggle between .h and .cpp with F4
function! ToggleBetweenHeaderAndSourceFile()
  let bufname = bufname("%")
  let ext = fnamemodify(bufname, ":e")
  if ext == "h"
    let ext = "cpp"
  elseif ext == "cpp"
    let ext = "h"
  else
    return
  endif
  let bufname_new = fnamemodify(bufname, ":r") . "." . ext
  let bufname_alt = bufname("#")
  if bufname_new == bufname_alt
    execute ":e#"
  else
    execute ":e " . bufname_new
  endif
endfunction
map <silent> <F4> :call ToggleBetweenHeaderAndSourceFile()<CR>

" -----------------------------------------------------------------------------
" Tab specific option

" When inserting TABs replace them with the appropriate number of spaces
set expandtab

" A tab is 8 spaces
set tabstop=8

" Insert 4 spaces when tab is pressed
set softtabstop=4

" An indent is 4 spaces
set shiftwidth=4

" Round indent to nearest shiftwidth multiple
set shiftround

" -----------------------------------------------------------------------------
" Options

" Choose the right syntax highlightning per TAB-completion :-)
" map <F2> :source $VIM/syntax/
" Syntax highlightning, but only for color terminals.
if &t_Co > 1
  syntax on
endif

"Break long lines
set wrap

" Show matching braces
set showmatch

" Keep the horizontal cursor position when moving vertically
set nostartofline

" Latex Suite 1.5 wants it
" REQUIRED. This makes vim invoke latex-suite when you open a tex file.
filetype plugin on

" Highlight all search matches and toggle it with F3
set hlsearch!

" Set line numbers
set number

set backspace=indent,eol,start

set incsearch

" Automatic C-style indenting
set autoindent

hi clear SignColumn

set re=1
