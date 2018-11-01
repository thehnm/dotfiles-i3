let mapleader=','

filetype off                  " required for vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" ----- Vim as a programmer's text editor -----------------------------
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'w0rp/ale'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'vim-latex/vim-latex'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'

" ----- Making vim look good ------------------------------------------
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ryanoasis/vim-devicons'

" ----- Working with Git ----------------------------------------------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" ----- Other text editing features -----------------------------------
Plugin 'Raimondi/delimitMate'
Plugin 'ntpeters/vim-better-whitespace'

call vundle#end()

filetype plugin indent on


" --- General settings ---
set backspace=indent,eol,start
set incsearch
hi clear SignColumn


" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with <leader>t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>


" ----- w0rp/ale -----
let g:ale_sign_error = ''
let g:ale_sign_warning = ''


" ----- vim-latex/vim-latex -----
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_dvi = 'latex -interaction=nonstopmode $*'
let g:Tex_ViewRule_pdf = 'mupdf'


" ----- xolox/vim-easytags settings -----
" Where to look for tags files
set tags=./tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1


" ----- majutsushi/tagbar settings -----
" Open/close tagbar with <leader>b
nmap <silent> <leader>b :TagbarToggle<CR>


" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END


" ----- vim-airline/vim-airline -----
let g:airline_powerline_fonts = 1
let g:airline_detect_paste=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='base16_default'
let g:airline#extensions#ale#enabled = 1

" ----- ryanoasis/vim-devicons -----
let g:webdevicons_enable = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_nerdtree = 1

" ----- Key remapping -----

" Switch buffers quickly
map <leader>q : bp<CR>
map <leader>w : bn<CR>

" Switch windows quicker
"map <silent> <C-h> :wincmd h<CR>
"map <silent> <C-j> :wincmd j<CR>
"map <silent> <C-k> :wincmd k<CR>
"map <silent> <C-l> :wincmd l<CR>

noremap ö l
noremap l k
noremap k j
noremap j h

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

" Toggle encoding with F12
function! ToggleEncoding()
  if &encoding == "latin1"
    set encoding=utf-8
  elseif &encoding == "utf-8"
    set encoding=latin1
  endif
endfunction

map <silent> <F12> :call ToggleEncoding()<CR>

" Reformat comment on current line
map <silent> hc ==I  <ESC>:.s/\/\/ */\/\//<CR>:nohlsearch<CR>j

" Make sure == also indents #ifdef etc
noremap <silent> == IX<ESC>==:.s/X//<CR>:nohlsearch<CR>

" Next / previous error with Tab / Shift+Tab
map <silent> <Tab> :cn<CR>
map <silent> <S+Tab> :cp<CR>
map <silent> <BS><Tab> :cp<CR>

" Umlaut mappings for US keyboard
map "a ä
map "o ö
map "u ü
map "s ß
map "A Ä
map "O Ö
map "U Ü

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

" Make it easy to update/reload _vimrc
:nmap ,s :source $HOME/.vimrc
:nmap ,v :sp $HOME/.vimrc

" -----------------------------------------------------------------------------

" Enable syntax highlighting
syntax on

" Always show status bar
set laststatus=2

" No need to be compatible with vi and lose features
set nocompatible

" Set line numbers
set number

" Show ruler
set ruler

" Highlight all search matches
" set hlsearch

" Automatic C-style indenting
set autoindent

" When inserting TABs replace them with the appropriate number of spaces
set expandtab

" But TABs are needed in Makefiles
au BufNewFile,BufReadPost Makefile se noexpandtab

" Show matching braces
set showmatch

" Choose the right syntax highlightning per TAB-completion :-)
" map <F2> :source $VIM/syntax/
" Syntax highlightning, but only for color terminals.
if &t_Co > 1
  syntax on
endif

" Set update time to 1 second (default is 4 seconds), convenient vor taglist.vim
set updatetime=500

" Keep the horizontal cursor position when moving vertically
set nostartofline

" Do not break long lines
set nowrap
set listchars=eol:$,extends:>

" After this many msecs do not imap
set timeoutlen=500

" Always show the name of the file being edited
" set ls=2

" Show the mode (insert,replace,etc.)
set showmode

" No blinking cursor please
set gcr=a:blinkon0

" Do not show any line of minimized windows
set wmh=0

" Latex Suite 1.5 wants it
" REQUIRED. This makes vim invoke latex-suite when you open a tex file.
filetype plugin on

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse latex-suite. Set your grep
" program to alway generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type (by 2 spaces)
filetype indent on
set sw=2

" no placeholders please
let g:Imap_UsePlaceHolders = 0

" no " conversion please
let g:Tex_SmartKeyQuote = 0

" don't use Makefile if one is there
let g:Tex_UseMakefile = 0

" Syntax Highlighting for MhonArc Config files
au BufNewFile,BufRead *.mrc so $HOME/.vim/mhonarc.vim

set guifont=DejaVuSansMono\ Nerd\ Font\ 11
