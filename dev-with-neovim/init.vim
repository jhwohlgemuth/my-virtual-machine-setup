let uname = substitute(system('uname'),'\n','','')
if uname == 'Linux'
  source ~/.config/nvim/general/settings.vim
  source ~/.config/nvim/general/plugins.vim
  source ~/.config/nvim/plug-config/coc.vim
  source ~/.config/nvim/plug-config/fzf.vim
  source ~/.config/nvim/plug-config/which-key.vim
  source ~/.config/nvim/themes/onedark.vim
else
  source ~/AppData/Local/nvim/general/settings.vim
  source ~/AppData/Local/nvim/general/plugins.vim
  source ~/AppData/Local/nvim/plug-config/coc.vim
  source ~/AppData/Local/nvim/plug-config/fzf.vim
  source ~/AppData/Local/nvim/plug-config/which-key.vim
  source ~/AppData/Local/nvim/themes/onedark.vim
endif