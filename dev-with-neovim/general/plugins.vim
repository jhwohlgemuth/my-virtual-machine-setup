" Install vim-plug if not found
let uname = substitute(system('uname'),'\n','','')
if uname == 'Linux'
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
else
    if empty(glob('~/AppData/Local/nvim/autoload/plug.vim'))
        execute 'silent !curl -fLo' shellescape("%HOMEDRIVE%%HOMEPATH%/AppData/Local/nvim/autoload/plug.vim", 1) '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endif
" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'jiangmiao/auto-pairs'
    Plug 'MattesGroeger/vim-bookmarks' " bookmark (mm) / annotate (mi)
    Plug 't9md/vim-choosewin'
    Plug 'alvan/vim-closetag'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'metakirby5/codi.vim'
    Plug 'norcalli/nvim-colorizer.lua'
    Plug 'chrisbra/csv.vim'
    Plug 'tpope/vim-commentary' " line (gcc) / motion (gc)
    Plug 'elixir-lang/vim-elixir'
    Plug 'voldikss/vim-floaterm'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'yuki-ycino/fzf-preview.vim'
    Plug 'junegunn/fzf.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/goyo.vim'
    Plug 'nathanaelkane/vim-indent-guides'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'joshdick/onedark.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'luochen1990/rainbow'
    Plug 'rust-lang/rust.vim'
    Plug 'mhinz/vim-signify'
    Plug 'psliwka/vim-smoothie'
    Plug 'justinmk/vim-sneak'
    Plug 'honza/vim-snippets'
    Plug 'mhinz/vim-startify'
    Plug 'tpope/vim-surround'" change (cd)/ delete (ds) / add (ys)/ visual (S)
    Plug 'vim-syntastic/syntastic'
    Plug 'godlygeek/tabular'
    Plug 'mbbill/undotree'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'cj/vim-webdevicons'
    Plug 'liuchengxu/vim-which-key'
call plug#end()

" {{{ Airline Settings }}}
let g:airline_powerline_fonts = 1

" {{{ Codi Settings }}}
" Windows not supported yet: https://github.com/metakirby5/codi.vim/issues/14
" let g:codi#virtual_text_prefix = "❯ "
" let g:codi#aliases = {
"                    \ 'javascript.jsx': 'javascript',
"                    \ }

" {{{ ChooseWin Settings }}}
let g:choosewin_overlay_enable = 1

" {{{ Colorizer Settings }}}
if exists("loaded_colorizer")
    lua require'colorizer'.setup()
endif

" {{{ Floaterm Settings }}}
let g:floaterm_title = ''
let g:floaterm_gitcommit = 'floaterm'
let g:floaterm_autoinsert = 1
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8
let g:floaterm_wintitle = 0
let g:floaterm_autoclose = 1

" {{{ Indent-guides Settings }}}
let g:indent_guides_guide_size = 1

" {{{ Rainbow Settings }}}
let g:rainbow_active = 1

" {{{ Sneak Settings }}}
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1 " case insensitive sneak
let g:sneak#s_next = 1
highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow
let g:sneak#prompt = '🔎 '

" {{{ Startify Settings }}}
let s:startify_ascii_header = [
\ '███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗',
\ '████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║',
\ '██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║',
\ '██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║',
\ '██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║',
\ '',
\]
let g:startify_custom_header = map(s:startify_ascii_header + startify#fortune#quote(), '"   ".v:val')
let g:webdevicons_enable_startify = 1
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

"{{{ Syntastic Settings }}}
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cs_checkers = ['cs']
let g:syntastic_css_checkers = ['css']
let g:syntastic_dockerfile_checkers = ['dockerfile']
let g:syntastic_elixir_checkers = ['elixir']
let g:syntastic_html_checkers = ['html']
let g:syntastic_javascript_checkers = ['javascript']
let g:syntastic_json_checkers = ['json']
let g:syntastic_markdown_checkers = ['markdown']
let g:syntastic_python_checkers = ['python']
let g:syntastic_text_checkers = ['text', 'proselint']
let g:syntastic_vim_checkers = ['vim']
let g:syntastic_xml_checkers = ['xml']
let g:syntastic_yaml_checkers = ['yaml']