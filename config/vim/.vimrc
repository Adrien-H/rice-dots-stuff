let mapleader = " "

" ------
" PLUGINS
" ------

" Automatically install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Automatically run PlugInstall if missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugs
call plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary' " ex: gc4j
Plug 'tpope/vim-sleuth'

Plug 'junegunn/goyo.vim'

Plug 'terryma/vim-multiple-cursors'

Plug 'terryma/vim-multiple-cursors'

Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'sheerun/vim-polyglot'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'elixir-editors/vim-elixir'

Plug 'vim-airline/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'lervag/vimtex'
Plug 'kblin/vim-fountain'

Plug 'NLKNguyen/papercolor-theme'
call plug#end()


" ------
" GLOBAL CONFIG
" ------

set nocompatible

set number
set relativenumber
set ruler
set colorcolumn=0
set cursorline
set showcmd

" set keymap="/home/adrien/.vim/keymap/french-azerty.vim"
syntax on
set termguicolors
colorscheme PaperColor
set background=dark
if !has('gui_running')
    set t_Co=256
endif

filetype plugin on
filetype indent on

" Cursor shapes, block and blinking bar
let &t_EI = "\033[2 q"
let &t_SI = "\e[5 q"

" ------
" INDENT
" ------

set tabstop=4
set shiftwidth=4
set noexpandtab
set autoindent
set smartindent

" C
autocmd FileType c,h setlocal shiftwidth=4 tabstop=4 noexpandtab
" C++
autocmd FileType cpp,hpp setlocal shiftwidth=4 tabstop=4 noexpandtab
" PHP
autocmd FileType php setlocal shiftwidth=4 softtabstop=4 expandtab
" Elixir
autocmd FileType elixir,eelixir,heex setlocal shiftwidth=2 softtabstop=2 expandtab


" ------
" LEADER MAPPINGS
" ------

" FZF
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>

" Terminal
nnoremap <leader>t :term<CR>

" Focus
nnoremap <Leader>g :Goyo<CR>

" ------
" LANGUAGE SERVERS
" ------

" Register ElixirLS
if executable('~/.local/bin/elixir-ls/language_server.sh')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'elixir-ls',
        \ 'cmd': {server_info->['~/.local/bin/elixir-ls/language_server.sh']},
        \ 'allowlist': ['elixir', 'eelixir', 'heex'],
        \ })
endif

" Keymaps
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Autocomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

" Diagnostics
let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 500

highlight LspErrorText cterm=undercurl gui=undercurl guisp=Red
highlight LspWarningText cterm=undercurl gui=undercurl guisp=Yellow


" ------
" LaTeX
" ------

augroup LaTeX
    autocmd!

    autocmd FileType tex setlocal wrap linebreak breakindent conceallevel=2 concealcursor=n nocursorline
    autocmd Syntax tex syntax match Nbsp /\%u00a0/ containedin=ALL conceal cchar=⎵
    autocmd Syntax tex syntax match ThinSp /\%u202f/ containedin=ALL conceal cchar=·

    let g:vimtex_fold_enabled=0
    let g:vimtex_view_method='zathura'
augroup END


" ------
" Go
" ------

augroup Go
    autocmd!

    autocmd FileType go setlocal shiftwidth=4 tabstop=4 noexpandtab
augroup END

