colorscheme slate

filetype plugin indent on
syntax enable

call plug#begin()

Plug 'lervag/vimtex', { 'tag': 'v2.17' }
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-omni.vim'

call plug#end()

set laststatus=2
highlight StatusLine   guifg=#ffffff guibg=#365f91 cterm=bold ctermfg=White ctermbg=DarkBlue
highlight StatusLineNC guifg=#aaaaaa guibg=#303030 cterm=NONE ctermfg=Grey  ctermbg=Black

set encoding=utf-8
set fileencoding=utf-8

set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround

set textwidth=80

set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap <silent> <Esc> :nohlsearch<CR>

set number

set showcmd
set ruler

set scrolloff=3

set wildmenu

set mouse=a

set history=1000

if has('persistent_undo')
	let s = expand('~/.vim/undo')
	if !isdirectory(s)
		call mkdir(s, 'p', 0700)
	endif
	if isdirectory(s) && filewritable(s) == 2
		let &undodir = s
		set undofile
	endif
endif

" Start: Python Settings

if executable('pyright-langserver')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyright',
                \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
                \ 'allowlist': ['python'],
                \ 'root_uri': {server_info->lsp#utils#path_to_uri(getcwd())},
                \ 'initialization_options': {},
                \ })

    autocmd FileType python setlocal omnifunc=lsp#complete

    autocmd FileType python nnoremap <buffer> gd <Plug>(lsp-definition)
    autocmd FileType python nnoremap <buffer> gh <Plug>(lsp-hover)
    autocmd FileType python nnoremap <buffer> gr <Plug>(lsp-references)
endif

" End: Python Settings

" Start: LaTeX Settings

if executable('latexmk')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
                \ 'name': 'vimtex',
                \ 'allowlist': ['tex'],
                \ 'completor': function('asyncomplete#sources#omni#completor'),
                \ 'config': {
                \     'show_source_kind': 1
                \ }
                \ }))
endif

" End: LaTeX Settings

" Start: Haskell Settings

if executable('haskell-language-server-wrapper')
    augroup vim_lsp_haskell
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'haskell-language-server',
                    \ 'cmd': {server_info -> ['haskell-language-server-wrapper', '--lsp']},
                    \ 'allowlist': ['haskell'],
                    \ })
    augroup END

    autocmd FileType haskell setlocal omnifunc=lsp#complete

    autocmd FileType haskell nnoremap <buffer> gd <Plug>(lsp-definition)
    autocmd FileType haskell nnoremap <buffer> gh <Plug>(lsp-hover)
    autocmd FileType haskell nnoremap <buffer> gr <Plug>(lsp-references)
endif

" End: Haskell Settings

" Start: C Settings

if executable('clangd')
    augroup vim_lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info -> ['clangd']},
                    \ 'allowlist': ['c'],
                    \ })
    augroup END

    autocmd FileType c setlocal omnifunc=lsp#complete

    autocmd FileType c nnoremap <buffer> gd <Plug>(lsp-definition)
    autocmd FileType c nnoremap <buffer> gh <Plug>(lsp-hover)
    autocmd FileType c nnoremap <buffer> gr <Plug>(lsp-references)
endif

" End: C Settings

