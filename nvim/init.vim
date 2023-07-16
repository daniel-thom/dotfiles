set nocompatible
filetype off

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

set rtp+=/Users/dthom/brew/opt/fzf

"Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'ervandew/supertab'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'GutenYe/json5.vim'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'fladson/vim-kitty'

" Colorschemes
Plug 'lifepillar/vim-solarized8'
Plug 'jacoborus/tender.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'morhetz/gruvbox'
Plug 'tomasiser/vim-code-dark'
Plug 'NLKNguyen/papercolor-theme'
Plug 'liuchengxu/space-vim-dark'
Plug 'ayu-theme/ayu-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'doums/darcula'

call plug#end()

set tabstop=4
set shiftwidth=4
set expandtab
let g:deoplete#enable_at_startup = 1
let g:SuperTabDefaultCompletionType = "<c-n>"

lua << EOF
	require'dt/lspconfig'
EOF

nnoremap <silent> <Leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <Leader>r <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0 <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> W :pclose<CR>

" This makes // search for whatever is visually selected.
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" This highlights the current word under cursors after 2s of inactivity.
"au CursorHold * :exec 'match IncSearch /\V\<' . expand('<cword>') . '\>/'
"set updatetime=2000

syntax on
let mapleader = ";"
set autowrite
set incsearch
set bs=2
filetype plugin on
set hlsearch
set ignorecase smartcase
set cindent
"set cino+=(0
set nobackup
set ruler
set cursorline
set hidden
set wildmenu
set wildmode=longest,full
set nowrapscan
set mouse=nv
set encoding=utf-8

" Jump to the last position when reopening a file.
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Mouse support
"set ttymouse=sgr
"set balloonevalterm
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
"execute "set <FocusGained>=\<Esc>[I"
"execute "set <FocusLost>=\<Esc>[O"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''

set termguicolors
"set background=dark

colorscheme codedark
set background=dark

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
nnoremap <Leader>w :w<cr>
nnoremap <C-s> :w<cr>
inoremap <C-s> <Esc>:w<cr>
"noremap <C-right> <Esc>:bn<CR>
"noremap <C-left> <Esc>:bp<CR>
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap gf :edit <cfile><CR>
nnoremap <F9> :noh<CR>
nnoremap <F10> :vimgrep /<C-R><C-W>/ %<CR>:cope<CR>
nnoremap <Leader>fb :Buffers<Enter>
nnoremap <Leader>fc :Colors<Enter>
nnoremap <Leader>ff :GFiles<Enter>
vnoremap <Leader>c "+y
nnoremap <Leader>n :cn<CR>
nnoremap <Leader>p :cp<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"map <A-DOWN> gj
"map <A-UP> gk
"imap <A-UP> <esc>gki
"imap <A-DOWN> <esc>gji
autocmd FileType perl nmap <Leader>c 0i#<Esc>
autocmd FileType vim nmap <Leader>c 0i"<Esc>
autocmd FileType sql nmap <Leader>c 0i--<Esc>
autocmd FileType json set tabstop=2
autocmd FileType json set shiftwidth=2
autocmd FileType json set expandtab
autocmd FileType json set number
autocmd FileType json5 set tabstop=2
autocmd FileType json5 set shiftwidth=2
autocmd FileType json5 set expandtab
autocmd FileType json5 set number
autocmd FileType text set wrap
autocmd FileType text set lbr
autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
"let g:ctags_statusline=1
"let g:ctags_title=1

nnoremap <Leader>h1 yypv$r*o
nnoremap <Leader>h2 yypv$r=o
nnoremap <Leader>h3 yypv$r-o

nnoremap <Leader>G :Ggrep "
nnoremap <Leader>t :Ggrep <C-r><C-w><CR><CR>

tnoremap <Esc> <C-\><C-n>
"nnoremap <Leader>jt :b term<CR>iinclude("test/runtests.jl")<CR>
"nnoremap <Leader>bt :b term<CR>
tnoremap ˙ <C-\><C-N><C-w>h
tnoremap ∆ <C-\><C-N><C-w>j
tnoremap ˚ <C-\><C-N><C-w>k
tnoremap ¬ <C-\><C-N><C-w>l
inoremap ˙ <C-\><C-N><C-w>h
inoremap ∆ <C-\><C-N><C-w>j
inoremap ˚ <C-\><C-N><C-w>k
inoremap ¬ <C-\><C-N><C-w>l
nnoremap ˙ <C-w>h
nnoremap ∆ <C-w>j
nnoremap ˚ <C-w>k
nnoremap ¬ <C-w>l

function! GotoLine()
lua << EOF
    local clipboard = vim.fn.getreg('*')
    -- python exceptions, including pytest AssertionError
    -- tests/test_file.py:10: AssertionError
    local filename, line = string.match(clipboard, "([%./%w_-]+):(%d+):")
    if filename ~= nil then
    	local cmd = string.format("edit +%s %s", line, filename)
    	vim.api.nvim_command(cmd)
    end
    
    -- python traceback
    --   File "/full/path/file.py", line 869, in function_name
    filename, line = string.match(clipboard, 'File "([%./%w_-]+)", line (%d+)')
    if filename ~= nil then
    	local cmd = string.format("edit +%s %s", line, filename)
    	vim.api.nvim_command(cmd)
    end
    
    -- ipython traceback
    -- File file/path/file.py:139, in function_call(*args, **kwargs)
    filename, line = string.match(clipboard, "File ([~%./%w_-]+):(%d+)")
    if filename ~= nil then
    	local cmd = string.format("edit +%s %s", line, filename)
    	vim.api.nvim_command(cmd)
    end

    -- julia stacktrace
    -- @ PowerSimulations ~/path/parameters.jl:170
    filename, line = string.match(clipboard, "@ [~%./%w%s_-]+ ([~%./%w_-]+):(%d+)")
    if filename ~= nil then
    	local cmd = string.format("edit +%s %s", line, filename)
    	vim.api.nvim_command(cmd)
    end

EOF
endfunction

nmap <Leader>gl :call GotoLine()<CR>
