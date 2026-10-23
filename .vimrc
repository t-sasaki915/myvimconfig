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

command! Dir execute 'edit %:p:h'
command! -nargs=1 DirEdit execute 'edit %:p:h/' . fnameescape(<q-args>)

" npm config set prefix "$HOME/.local"
" export PATH="$HOME/.local/bin:$PATH"

nnoremap <buffer> gd <Plug>(lsp-definition)
nnoremap <buffer> gh <Plug>(lsp-hover)
nnoremap <buffer> gr <Plug>(lsp-references)
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" Start: LaTeX Settings

" curl https://tex.org.uk/support/latexmk/latexmk.pl -o ~/.local/bin/latexmk &&
" chmod +x ~/.local/bin/latexmk
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

" Start: Python Settings

" npm install -g pyright
if executable('pyright-langserver')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyright',
                \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
                \ 'allowlist': ['python'],
                \ 'root_uri': {server_info->lsp#utils#path_to_uri(getcwd())},
                \ 'initialization_options': {},
                \ })

    autocmd FileType python setlocal omnifunc=lsp#complete
endif

" End: Python Settings

" Start: Haskell Settings

" Use ghcup
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
endif

" End: Haskell Settings

" Start: C Settings

" Use clangd
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
endif

" End: C Settings

" Start: JavaScript Settings

" npm install -g typescript@6 typescript-language-server
if executable('typescript-language-server')
    augroup vim_lsp_javascript
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'typescript-language-server',
                    \ 'cmd': {server_info -> ['typescript-language-server', '--stdio']},
                    \ 'allowlist': ['javascript'],
                    \ })
    augroup END

    autocmd FileType javascript setlocal omnifunc=lsp#complete
endif

" End: JavaScript Settings

" Start: HTML Settings

" npm install -g vscode-langservers-extracted
" Set 'snippetSupport': v:true in ~/.vim/plugged/vim-lsp/autoload/lsp.vim
if executable('vscode-html-language-server')
    augroup vim_lsp_html
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'html-language-server',
                    \ 'cmd': {server_info -> ['vscode-html-language-server', '--stdio']},
                    \ 'allowlist': ['html'],
                    \ })
    augroup END

    autocmd FileType html setlocal omnifunc=lsp#complete
endif

" End: HTML Settings

" Start: CSS Settings

" npm install -g vscode-langservers-extracted
" Set 'snippetSupport': v:true in ~/.vim/plugged/vim-lsp/autoload/lsp.vim
if executable('vscode-css-language-server')
    augroup vim_lsp_css
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'css-language-server',
                    \ 'cmd': {server_info -> ['vscode-css-language-server', '--stdio']},
                    \ 'allowlist': ['css'],
                    \ })
    augroup END

    autocmd FileType css setlocal omnifunc=lsp#complete
endif

" End: CSS Settings

