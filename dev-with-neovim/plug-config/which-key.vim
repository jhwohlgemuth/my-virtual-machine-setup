" {{{ Which-key Settings }}}
let g:which_key_timeout = 100
let g:which_key_display_names = {'<CR>': '↵', '<TAB>': '⇆'}
let g:which_key_sep = '→'
let g:which_key_map =  {}
" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
let g:which_key_map['e'] = [ 'CocCommand explorer', 'explorer' ]
let g:which_key_map['w'] = [ 'ChooseWin', 'window' ]
let g:which_key_map['z'] = [ 'Goyo', 'zen' ]
let g:which_key_map.t = {
      \ 'name' : '+terminal' ,
      \ ';' : [':FloatermNew --wintype=normal --height=20 powershell', 'terminal'],
      \ 'd' : [':FloatermNew lazydocker', 'docker'],
      \ 'd' : [':CocCommand explorer', 'explorer'],
      \ 'f' : [':FloatermNew dotnet fsi', 'F#'],
      \ 'g' : [':FloatermNew lazygit', 'git'],
      \ 'm' : [':FloatermNew python', 'python'],
      \ 'n' : [':FloatermNew node', 'node'],
      \ 'p' : [':FloatermNew powershell', 'powershell'],
      \ 't' : [':FloatermToggle', 'toggle'],
      \ }
call which_key#register('<Space>', "g:which_key_map")