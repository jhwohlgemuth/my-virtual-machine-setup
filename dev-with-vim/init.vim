set autoread
set encoding=UTF-8
set nobackup
set nocompatible
set noswapfile
set nowritebackup
set ruler
set termguicolors
syntax on
" exe 'source' 'C:\Users\jason\AppData\Local\nvim\plug-config\coc.vim'

call plug#begin()
    Plug 'sheerun/vim-polyglot'
    Plug 'chrisbra/csv.vim'
    Plug 'elixir-lang/vim-elixir'
    Plug 'rust-lang/rust.vim'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'ryanoasis/vim-devicons'
    Plug 'vim-syntastic/syntastic'
    Plug 'junegunn/vim-easy-align'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'tpope/vim-surround'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tomasiser/vim-code-dark'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'luochen1990/rainbow'
    Plug 'junegunn/goyo.vim'
    " Plug 'wfxr/minimap.vim'
    " Plug 'Xuyuanp/scrollbar.nvim'
    " Plug 'severin-lemaignan/vim-minimap'
call plug#end()

" Configure colorizer.lua plugin
lua require'colorizer'.setup()

" colorscheme codedark

"{{{ Coc Settings }}}
" use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

set guifont=Cascadia\ Code\ PL:h13
let g:mapleader = "\<Space>"
let g:airline_powerline_fonts = 1
" let g:airline_theme = 'codedark'
let g:coc_global_extensions = ['coc-snippets', 'coc-vimlsp', 'coc-json', 'coc-git', 'coc-html', 'coc-emmet', 'coc-css', 'coc-powershell', 'coc-python', 'coc-elixir', 'coc-fsharp', 'coc-reason', 'coc-xml', 'coc-yaml']
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:rainbow_active = 1
"{{{ Syntastic Settings }}}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['javascript']


" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap <Leader>l <Plug>(Limelight)
map <C-f> <Esc><Esc>:Files!<CR>
inoremap <C-f> <Esc><Esc>:BLines!<CR>
xmap <Leader>l <Plug>(Limelight)
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <silent> <C-Bslash> :NERDTreeToggle<CR>

" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif