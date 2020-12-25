set autoindent
set autoread
set background=dark
" Give more space for displaying messages.
set cmdheight=1
set cursorline
set encoding=UTF-8
" Convert tabs to spaces
set expandtab
" TextEdit might fail if hidden is not set.
set hidden
set nobackup
set nocompatible
set noswapfile
set nowrap
set nowritebackup
set number
set ruler
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set smartindent
set smarttab
set termguicolors
set timeoutlen=300
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

let g:mapleader = "\<Space>"