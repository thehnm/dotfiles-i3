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

" ----- Vundle ----------------------------------------------------------------"
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

Plugin 'VundleVim/Vundle.vim'

" ----- Editor features -----
Plugin 'w0rp/ale'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'Rip-Rip/clang_complete'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'jiangmiao/auto-pairs'
Plugin 'scrooloose/nerdcommenter'
Plugin 'bfrg/vim-cpp-modern'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'majutsushi/tagbar'

" ----- Working with Git -----
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" ----- Latex support -----
Plugin 'vim-latex/vim-latex'

" ----- Visual aesthetics -----"
Plugin 'itchyny/lightline.vim'

" ----- Optimizations -----
Plugin 'Konfekt/FastFold'

call vundle#end()


" ----- Plugin Configuration --------------------------------------------------"

" ----- vim-latex/vim-latex -----
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_dvi = 'latex -interaction=nonstopmode $*'
let g:Tex_ViewRule_pdf = 'zathura'
let g:Tex_MultipleCompileFormats='pdf,bib,pdf'
let g:tex_no_error=1

" ----- w0rp/ale -----
let g:ale_sign_error = 'xx'
let g:ale_sign_warning = '--'
"let g:ale_linters = {'cpp': ['g++', 'clang']}

" ----- ntpeters/vim-better-whitespace -----
let g:better_whitespace_enabled=1

" ----- airblade/vim-gitgutter -----
autocmd BufWritePost * GitGutter

" ----- Konfekt/FastFold -----
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" ----- Rip-Rip/clang_complete -----
let g:clang_library_path='/usr/lib64/libclang.so.7'
let g:clang_close_preview=1

" ----- majutsushi/tagbar -----
nmap <F8> : TagbarToggle<CR>

" ----- itchyny/lightline.vim -----
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'gitbranch', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }


" ----- Mappings --------------------------------------------------------------"

" Set map leader key
let mapleader=','

" Toggle highlight search
nnoremap <F3> : set hlsearch!<CR>

" Switch buffers quickly
map <leader>q : bp<CR>
map <leader>w : bn<CR>

" Open netrw
map <leader>e : Vexplore<CR>

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


" ---------- Settings ----------

" Standart statusline with filetype
set statusline=%<%f\ %h%m%r%y%=%-14.(%l,%c%V%)\ %P

" Set vertical split bar to continous line
" set fillchars=stl:-,stlnc:-,vert:│
set fillchars=vert:│

" Allows auto-indenting depending on file type
filetype plugin indent on

" Show typed command
set showcmd

" Disable vertical split border background
hi VertSplit cterm=None

hi clear SignColumn

" Disable banner when opening netrw
let g:netrw_banner = 0
