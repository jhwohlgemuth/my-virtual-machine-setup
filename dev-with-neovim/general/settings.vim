set autoindent
set autoread
set background=dark
set cmdheight=1
set cursorline
set encoding=UTF-8
set expandtab " Convert tabs to spaces
set hidden " TextEdit might fail if hidden is not set
set nobackup
set nocompatible
set noswapfile
set nowrap
set nowritebackup
set number
set ruler
set shortmess+=c " Don't pass messages to |ins-completion-menu|
set smartindent
set smarttab
set termguicolors
set timeoutlen=100
" Use persistent history.
if !isdirectory('~/AppData/Local/nvim/undo')
    call mkdir('~/AppData/Local/nvim/undo', '', 0700)
endif
set undodir=~/AppData/Local/nvim/undo
set undofile " Maintain undo history between sessions
set updatetime=100 " Default is 4000ms
syntax on
syntax enable
filetype plugin indent on

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif