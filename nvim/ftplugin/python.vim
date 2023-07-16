se number
nmap <Leader>c ^i#<Esc>
nmap <Leader>C ^x
vnoremap <Leader>C <C-v>I#<Esc>
set colorcolumn=99
"colorscheme solarized8_flat
"set background=light

nmap <F8> :w<Enter>:cs kill 0<Enter>:!pycscope -R<Enter>:cs add GTAGS<Enter>
let g:black#settings = {
    \ 'fast': 0,
    \ 'line_length': 99
\}

"set completeopt-=preview

"autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
"let g:SuperTabDefaultCompletionType = "<c-n>"

"set omnifunc=lsp#omnifunc
