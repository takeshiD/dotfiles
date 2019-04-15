if g:dein#_cache_version !=# 100 || g:dein#_init_runtimepath !=# '/home/takeshid/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim80,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,/home/takeshid/.vim/after,/home/takeshid/.vim/bundles/dein.vim' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/home/takeshid/.vimrc'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/home/takeshid/.vim/bundles'
let g:dein#_runtime_path = '/home/takeshid/.vim/bundles/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/home/takeshid/.vim/bundles/.cache/.vimrc'
let &runtimepath = '/home/takeshid/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/home/takeshid/.vim/bundles/dein.vim,/home/takeshid/.vim/bundles/.cache/.vimrc/.dein,/usr/share/vim/vim80,/home/takeshid/.vim/bundles/.cache/.vimrc/.dein/after,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,/home/takeshid/.vim/after'
