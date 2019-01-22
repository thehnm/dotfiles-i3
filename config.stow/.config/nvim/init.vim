set nocompatible            " Disable compatibility to old-time vi
set showmatch               " Show matching brackets.
set ignorecase              " Do case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions

filetype off

" ---------- Vundle ----------
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-latex/vim-latex'
Plugin 'w0rp/ale'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'airblade/vim-gitgutter'
Plugin 'Konfekt/FastFold'

call vundle#end()


" --------- Plugin Configuration ----------

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

" ----- airblade/vim-gitgutter -----
autocmd BufWritePost * GitGutter

" ----- Konfekt/FastFold -----
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']


" ---------- Mappings ----------

" Set map leader key
let mapleader=','

" Toggle highlight search
nnoremap <F3> :set hlsearch!<CR>

" Switch buffers quickly
map <leader>q : bp<CR>
map <leader>w : bn<CR>


" ---------- Settings ----------

set fillchars=stl:-,stlnc:-,vert:│ " Set vertical split bar to continous line

set showmatch " Show matching braces

filetype plugin indent on " Allows auto-indenting depending on file type

set showcmd

" Disable vertical split border background
hi VertSplit cterm=None

hi clear SignColumn

"" Cycle through completions with TAB (and SHIFT-TAB cycles backwards).
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
