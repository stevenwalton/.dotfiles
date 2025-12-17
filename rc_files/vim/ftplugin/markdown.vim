" Operate on header of section. i.e. 'cih' = delete header and go to insert
" mode. 'dih' = delete header. Header defined by underline with == or --
onoremap ih :<c-u>execute "normal !?^\(==\|--\)\\+$\r:nohlsearch\rkvg_"<cr>
" MARKDOWN
syn match markdownIgnore "\$.*_.*\$" " Doesn't highlight _ while in latex
