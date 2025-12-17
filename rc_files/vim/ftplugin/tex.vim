" MARKDOWN
syn match markdownIgnore "\$.*_.*\$" " Doesn't highlight _ while in latex
" tex compile on current file
nnoremap <buffer> <localleader>tex :!pdflatex %<CR>
" Ignore indenting when...
" https://vi.stackexchange.com/questions/20560/why-does-vim-still-auto-indent-latex-after-i-set-noai-noci-nosi
" Note that there are no help pages for these files 😡
" But do look at :h ft-tex
let g:vimtex_indent_ignored_envs = [
\ 'document', 
\ 'verbatim', 
\ 'lstlisting', 
\ 'frame',
\]
" Include these characters for completion (i.e. bibtex)
set iskeyword+=-
