let mapleader=','

filetype off                  " required for vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-latex/vim-latex'
Plugin 'w0rp/ale'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'airblade/vim-gitgutter'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'Rip-Rip/clang_complete'

call vundle#end()

" ----- vim-latex/vim-latex -----
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_dvi = 'latex -interaction=nonstopmode $*'
let g:Tex_ViewRule_pdf = 'zathura'
let g:Tex_MultipleCompileFormats='pdf,bib,pdf'
let g:tex_no_error=1

" ----- w0rp/ale -----
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_linters = {'cpp': ['g++']}

" ----- ntpeters/vim-better-whitespace -----
let g:better_whitespace_enabled=1

" ----- Rip-Rip/clang_complete -----
let g:clang_library_path='/usr/lib64/libclang.so.7'
let g:clang_close_preview=1

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

" Latex Suite 1.5 wants it
" REQUIRED. This makes vim invoke latex-suite when you open a tex file.

filetype plugin indent on

" Syntax highlightning, but only for color terminals.
set t_Co=256
syntax on

" Set vertical split bar to continous line
set fillchars=stl:-,stlnc:-,vert:│

" Disable vertical split border background
highlight VertSplit cterm=None

"Break long lines
set wrap

" Show matching braces
set showmatch

" Keep the horizontal cursor position when moving vertically
set nostartofline


" Highlight all search matches and toggle it with F3
set hlsearch!

" Set line numbers
set number

set backspace=indent,eol,start

set incsearch

" Automatic C-style indenting
set autoindent

hi clear SignColumn

set showcmd

" Completion function optimized for c++
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
