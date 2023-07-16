"nmap <Leader>f :Ag "function\s<C-r><C-w>\b<CR>"
"nmap <Leader>f :Ag "function "<C-r><C-w> -wQ<CR><CR>
"nmap <Leader>s :Ag "struct\s<C-r><C-w>\b<CR>"
"nmap <Leader>s :Ag "struct "<C-r><C-w> -wQ<CR><CR>
nmap <Leader>f :Ggrep "function <C-r><C-w>"<CR><CR>
nmap <Leader>F :Ggrep "function 
nmap <Leader>s :Ggrep "struct <C-r><C-w>"<CR><CR>
nmap <Leader>S :Ggrep "struct 
nmap <Leader>a :Ggrep "abstract type <C-r><C-w>"<CR><CR>
nmap <Leader>A :Ggrep "abstract type 
nmap <Leader>c ^i#<Esc>
nmap <Leader>C ^x
set expandtab
set tabstop=4
set shiftwidth=4
set number
set colorcolumn=93


"let g:default_julia_version = 'current'

nnoremap <leader>jf :JuliaFormatterFormat<CR>
vnoremap <leader>jf :JuliaFormatterFormat<CR>
let g:JuliaFormatter_use_sysimage=1

"lua << EOF
"    require'nvim_lsp'.julials.setup{}
"EOF
"
"setlocal omnifunc=v:lua.vim.lsp.omnifunc

"let g:LanguageClient_autoStart = 1
"\       env_path = ".";
"let g:LanguageClient_serverCommands = {
"\   'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
"\       using LanguageServer;
"\       using Pkg;
"\       import StaticLint;
"\       import SymbolServer;
"\       env_path = dirname(Pkg.Types.Context().env.project_file);
"\       debug = true; 
"\       server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "", Dict());
"\       server.runlinter = true;
"\       run(server);
"\   ']
"\ }
"let s:julia_exe = '/sbin/julia'
"let s:julia_lsp_startscript = '/home/dthom/startlanguageserver.jl'
"
"if executable('julia')
"  autocmd User lsp_setup call lsp#register_server({
"  \ 'name': 'julia',
"  \ 'cmd': {server_info->[s:julia_exe, '--startup-file=no', '--history-file=no', s:julia_lsp_startscript]},
"  \ 'whitelist': ['julia'],
"  \ })
"endif

"nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
"nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
"let g:lsp_log_file = '/home/dthom/lsp.log'

set makeprg=./runtests.py
" if hidden is not set, TextEdit might fail.
"set hidden
"
"" Some servers have issues with backup files, see #649
"set nobackup
"set nowritebackup
"
"" Better display for messages
"set cmdheight=2
"
"" You will have bad experience for diagnostic messages when it's default 4000.
"set updatetime=300
"
"" don't give |ins-completion-menu| messages.
"set shortmess+=c
"
"" always show signcolumns
"set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
"
"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
"" Coc only does snippet and additional edit on confirm.
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"" Or use `complete_info` if your vim support it, like:
"" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"
"" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction
"
"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)
"
"" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
"
"augroup mygroup
"  autocmd!
"  " Setup formatexpr specified filetype(s).
"  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"  " Update signature help on jump placeholder
"  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end
"
"" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
"
"" Remap for do codeAction of current line
"nmap <leader>ac  <Plug>(coc-codeaction)
"" Fix autofix problem of current line
"nmap <leader>qf  <Plug>(coc-fix-current)
"
"" Create mappings for function text object, requires document symbols feature of
"" languageserver.
"
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)
"
"" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)
"
"" Use `:Format` to format current buffer
"command! -nargs=0 Format :call CocAction('format')
"
"" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
"" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
"
"" Add status line support, for integration with other plugin, checkout `:h coc-status`
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
"" Using CocList
"" Show all diagnostics
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
""" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
""" Show commands
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
""" Find symbol of current document
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
""" Search workspace symbols
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
