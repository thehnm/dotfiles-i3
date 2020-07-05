if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

set showmatch               " Show matching brackets.
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
"set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set splitright
set splitbelow
set noshowmode
set hidden
set wrap linebreak
set fillchars=vert:│
set showcmd
set laststatus=0 " disable status bar
set conceallevel=2
set cursorline

filetype off

" ----- Vundle ----------------------------------------------------------------"
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

Plug 'VundleVim/Vundle.vim'

" ----- Editor features -----
Plug 'ntpeters/vim-better-whitespace'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'scrooloose/nerdcommenter'
Plug 'bfrg/vim-cpp-modern'
Plug 'jlanzarotta/bufexplorer'
Plug 'majutsushi/tagbar'
Plug 'bling/vim-bufferline'
Plug 'tpope/vim-surround'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'preservim/nerdtree'

" ----- Working with Git -----
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" ----- Latex support -----
Plug 'lervag/vimtex'

" ----- Visual aesthetics -----"
Plug 'itchyny/lightline.vim'
Plug 'rafi/awesome-vim-colorschemes'
call plug#end()


" ----- Plugin Configuration --------------------------------------------------"

" ----- ntpeters/vim-better-whitespace -----
let g:better_whitespace_enabled=1

" ----- airblade/vim-gitgutter -----
autocmd BufWritePost * GitGutter

" ----- Konfekt/FastFold -----
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" ----- Rip-Rip/clang_complete -----
let g:clang_library_path='/usr/lib/libclang.so.8'
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

" ----- junegunn/goyo-----
let g:goyo_width = '50%'
let g:goyo_height = '75%'

" ----- junegunn/limelight -----
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" ----- vimtex -----
let g:vimtex_view_general_viewer = "zathura"
let g:vimtex_compiler_latexmk = {
        \ 'backend' : 'nvim',
        \ 'background' : 1,
        \ 'build_dir' : 'build',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'options' : [
        \   '-pdf',
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \   '-outdir=build',
        \   '-xelatex',
        \ ],
\}

" ----- nerdtree -----
map <C-o> :NERDTreeToggle<CR>

" ----- Mappings --------------------------------------------------------------"

" Set map leader key
let mapleader=','

" Toggle highlight search
nnoremap <F3> : set hlsearch!<CR>

" Switch buffers quickly
map <leader>q :bp<CR>
map <leader>w :bn<CR>

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

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Autoclose matching brackets
" Press ctrl-v for single bracket
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ` ``<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O

nnoremap <F9> : !texcount %:t<CR>

" Move around displayed lines
map j gj
map k gk

" Execute makefile
map <leader>ll : !make<CR>
map <leader>lr : !make clean<CR>

" Remap omnicomplete
inoremap <c-o> <c-x><c-o>

" ---------- Settings ----------

" Allows auto-indenting depending on file type
filetype plugin indent on

" Disable vertical split border background
hi VertSplit cterm=None

hi clear SignColumn

" Disable banner when opening netrw
let g:netrw_banner = 0

set termguicolors
colorscheme tender
