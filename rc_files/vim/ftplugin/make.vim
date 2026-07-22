" Makefiles can be annoying about tabs
setlocal noexpandtab
" Make >>, <<, <TAB> be consistent
setlocal shiftwidth=0
setlocal softtabstop=0

" Show whitespaces
setlocal list
setlocal listchars=tab:▸\ ,trail:·,nbsp:␣

" Treat '-' as part of identifiers
setlocal iskeyword+=-
