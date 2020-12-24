call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'jiangmiao/auto-pairs'
    Plug 'alvan/vim-closetag'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'metakirby5/codi.vim'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'chrisbra/csv.vim'
    Plug 'tpope/vim-commentary' " line (gcc) / motion (gc)
    Plug 'junegunn/vim-easy-align'
    Plug 'elixir-lang/vim-elixir'
    Plug 'voldikss/vim-floaterm'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'yuki-ycino/fzf-preview.vim'
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/goyo.vim'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'ryanoasis/vim-devicons'
    Plug 'joshdick/onedark.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'luochen1990/rainbow'
    Plug 'rust-lang/rust.vim'
    Plug 'mhinz/vim-signify'
    Plug 'psliwka/vim-smoothie'
    Plug 'tpope/vim-surround'" change (cd)/ delete (ds) / add (ys)/ visual (S)
    Plug 'vim-syntastic/syntastic'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

" {{{ Airline Settings }}}
let g:airline_powerline_fonts = 1

" {{{ Codi Settings }}}
" Windows not support yet: https://github.com/metakirby5/codi.vim/issues/14
" let g:codi#virtual_text_prefix = "❯ "
" let g:codi#aliases = {
"                    \ 'javascript.jsx': 'javascript',
"                    \ }

" {{{ Colorizer Settings }}}
lua require'colorizer'.setup()

" {{{ Floaterm Settings }}}
let g:floaterm_title=''`
let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

" {{{ NERDTree Settings }}}
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeGitStatusUseNerdFonts = 1
if exists("g:loaded_webdevicons")
	call webdevicons#refresh()
endif
" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" {{{ Rainbow Settings }}}
let g:rainbow_active = 1
let g:rainbow_conf = {
	\	'separately': {
	\		'nerdtree': 0,
	\	}
	\}

"{{{ Syntastic Settings }}}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['javascript']
let g:syntastic_css_checkers = ['css']
