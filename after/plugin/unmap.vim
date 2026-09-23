" LeaderF maps <Leader>f and <Leader>b by default (g:Lf_ShortcutF/B).
" This config uses <Leader>ff / <Leader>bb / <Leader>bl instead, so remove them.
" silent! in case a future LeaderF version stops defining these.
silent! unmap <leader>b
silent! unmap <leader>f
