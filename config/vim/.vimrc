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
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'

Plug 'elixir-editors/vim-elixir'

Plug 'vim-airline/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()


" ------
" GLOBAL CONFIG
" ------

set nocompatible

set number
set relativenumber
set ruler
set colorcolumn=0

set tabstop=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

set cursorline

set showcmd

" set keymap="/home/adrien/.vim/keymap/french-azerty.vim"
syntax on
colorscheme elflord
filetype plugin on
filetype indent on

" Cursor shapes, block and blinking bar
let &t_EI = "\033[2 q"
let &t_SI = "\e[5 q"

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

" Autocomplete (close window after insert)
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview
"let g:lsp_diagnostics_enabled = 1
"let g:lsp_signs_enabled = 1
"let g:lsp_diagnostics_echo_cursor = 1

"let g:lsp_diagnostics_float_cursor = 1
"let g:lsp_diagnostics_float_delay = 500

"highlight LspErrorText cterm=undercurl gui=undercurl guisp=Red
"highlight LspWarningText cterm=undercurl gui=undercurl guisp=Yellow
