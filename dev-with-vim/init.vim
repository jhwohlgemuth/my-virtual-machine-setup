set autoread
" Give more space for displaying messages.
set cmdheight=2
set encoding=UTF-8
" TextEdit might fail if hidden is not set.
set hidden
set nobackup
set nocompatible
set noswapfile
set nowritebackup
set number
set ruler
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
set termguicolors
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
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
    Plug 'tpope/vim-surround'" change (cd)/ delete (ds) / add (ys)/ visual (S)
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'joshdick/onedark.vim'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'luochen1990/rainbow'
    Plug 'junegunn/goyo.vim'
    Plug 'mhinz/vim-signify'
    Plug 'voldikss/vim-floaterm'
    Plug 'psliwka/vim-smoothie'
    Plug 'alvan/vim-closetag'
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-commentary' " line (gcc) / motion (gc)
    " Plug 'Xuyuanp/scrollbar.nvim'
call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Configure colorizer.lua plugin
lua require'colorizer'.setup()

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

let g:mapleader = "\<Space>"
let g:airline_powerline_fonts = 1
let g:coc_global_extensions = ['coc-fzf-preview', 'coc-snippets', 'coc-vimlsp', 'coc-json', 'coc-git', 'coc-html', 'coc-emmet', 'coc-css', 'coc-powershell', 'coc-python', 'coc-elixir', 'coc-fsharp', 'coc-reason', 'coc-xml', 'coc-yaml']
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeGitStatusUseNerdFonts = 1
if exists("g:loaded_webdevicons")
	call webdevicons#refresh()
endif
" Rainbow plugin causes NERDTree to display brackets
let g:rainbow_conf = {
	\	'separately': {
	\		'nerdtree': 0,
	\	}
	\}
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

" Exit terminal with Escape
tnoremap <Esc> <C-\><C-n>
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <silent> <C-Bslash> :NERDTreeToggle<CR>

" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" {{{ One Dark Theme }}}
" onedark.vim override: Don't set a background color when running in a terminal;
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END
endif
hi Comment cterm=italic
let g:onedark_hide_endofbuffer=1
let g:onedark_terminal_italics=1
let g:onedark_termcolors=256
syntax on
if !exists('g:syntax_on')
	syntax enable
endif
" checks if your terminal has 24-bit color support
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif
colorscheme onedark