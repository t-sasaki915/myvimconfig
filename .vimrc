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

set wrap
set linebreak
set textwidth=0
autocmd FileType * set colorcolumn=0
highlight ColorColumn ctermbg=238 guibg=#444444

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

set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b

" Clipboard settings if +clipboard
if has('clipboard')
    " For gVIM on Windows
    if has('win32') && has('gui_running')
        set clipboard=unnamed

    " For other platforms
    else
        set clipboard=unnamedplus
    endif

" Clipboard settings if -clipboard
else
    " For WSL
    " Install https://github.com/equalsraf/win32yank to C:\Users\Public\bin
    if has('unix') && executable('/mnt/c/Users/Public/bin/win32yank.exe')
        let s:copyCommand = 'cd /mnt/c && /mnt/c/Users/Public/bin/win32yank.exe -i --crlf'
        let s:pasteCommand = 'cd /mnt/c && /mnt/c/Users/Public/bin/win32yank.exe -o --lf'

    " For Linux / Wayland
    " Install wl-clipboard
    elseif has('unix') && executable('wl-copy') && executable('wl-paste')
        let s:copyCommand = 'wl-copy --type text/plain;charset=utf-8'
        let s:pasteCommand = 'wl-paste --no-newline --type text/plain;charset=utf8'
    endif

    if exists('s:copyCommand') && exists('s:pasteCommand')
        function! s:CopyToOSClipboard() abort
            call system(s:copyCommand, getreg('"'))
        endfunction
        
        function! s:PasteFromOSClipboard(before) abort
            let l:clipboard = system(s:pasteCommand)
        
            call setreg('"', l:clipboard)
        
            execute 'normal! ' . (a:before ? 'P' : 'p')
        endfunction

        autocmd TextYankPost * if index(['y', 'd', 'c'], v:event.operator) >= 0 | call <SID>CopyToOSClipboard() | endif
    
        nnoremap <silent> p :<C-u>call <SID>PasteFromOSClipboard(0)<CR>
        nnoremap <silent> P :<C-u>call <SID>PasteFromOSClipboard(1)<CR>
    endif
endif

set history=1000

if has('persistent_undo')
    if has('win32')
	    let s = expand('~/vimfiles/undo')
    else
	    let s = expand('~/.vim/undo')
    endif

	if !isdirectory(s)
		call mkdir(s, 'p', 0700)
	endif
    
	if isdirectory(s) && filewritable(s) == 2
		let &undodir = s
		set undofile
	endif
endif

function! TermHere() abort
    if empty(bufname('%'))
        let l = expand('$HOME')
    else
        let l = expand('%:p:h')
    endif

    if !isdirectory(l)
        let l = expand('$HOME')
    endif

    if has('win32')
        let l:shell = executable('pwsh') ? 'pwsh' : 'powershell'
        call term_start([l:shell, '-NoLogo', '-NoExit'], {
                    \ 'curwin': 1,
                    \ 'cwd': l,
                    \ 'term_name': 'PowerShell',
                    \ })
    else
        call term_start(['bash', '-i'], {
                    \ 'curwin': 1,
                    \ 'cwd': l,
                    \ 'term_name': 'Bash',
                    \ })
    endif
endfunction

command! -bang Dir execute 'edit<bang> %:p:h'
command! -nargs=1 -bang DirEdit execute 'edit<bang> %:p:h/' . fnameescape(<q-args>)
command! TermHere call TermHere()
command! Home execute 'tabnew $HOME'

tnoremap <Esc> <C-\><C-n>

autocmd ColorScheme * call s:SetLspDiagnosticColours()

function! s:SetLspDiagnosticColours() abort
    highlight LspErrorVirtualText
                \ ctermfg=white ctermbg=darkred
                \ guifg=#ffffff guibg=#a00000 gui=NONE

    highlight LspWarningVirtualText
                \ ctermfg=white ctermbg=darkred
                \ guifg=#ffffff guibg=#a00000 gui=NONE

    highlight LspInformationVirtualText
                \ ctermfg=white ctermbg=darkred
                \ guifg=#ffffff guibg=#a00000 gui=NONE

    highlight LspHintVirtualText
                \ ctermfg=white ctermbg=darkred
                \ guifg=#ffffff guibg=#a00000 gui=NONE
endfunction

call s:SetLspDiagnosticColours()

" npm config set prefix "$HOME/.local"
" export PATH="$HOME/.local/bin:$PATH"

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

function! LspNodeExecutable(name) abort
    if has('win32')
        return a:name . '.cmd'
    endif

    return a:name
endfunction

" Start: LaTeX Settings

" curl https://tex.org.uk/support/latexmk/latexmk.pl -o ~/.local/bin/latexmk &&
" chmod +x ~/.local/bin/latexmk
"
" For word count use https://app.uio.no/ifi/texcount/download.html
"
" For Windows use miktex
if executable('latexmk')
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
                \ 'name': 'vimtex',
                \ 'allowlist': ['tex', 'bib'],
                \ 'completor': function('asyncomplete#sources#omni#completor'),
                \ 'config': {
                \     'show_source_kind': 1
                \ }
                \ }))

    if executable('zathura')
        let g:vimtex_view_method = 'zathura'
    endif

    if has('win32') && executable('SumatraPDF.exe')
        let s:sumatraPath = trim(split(system('where SumatraPDF.exe'), "\n")[0])

        if v:shell_error == 0 && filereadable(s:sumatraPath)
            let g:vimtex_view_method = 'general'
            let g:vimtex_view_general_viewer = s:sumatraPath
            let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
        endif
    endif

    autocmd FileType tex set colorcolumn=100
    autocmd FileType bib set colorcolumn=100
    
    autocmd FileType tex command! WordCount execute 'VimtexCountWords'
    
endif

" Use https://github.com/ltex-plus/ltex-ls-plus/releases
" Use https://github.com/t-sasaki915/LTeXConfigManipulator
if executable('ltex-ls-plus') && executable('LTeXConfigManipulator')
    function! s:LtexWorkspaceConfig(...) abort
        return json_decode(system('LTeXConfigManipulator workspaceConfig --texFile ' . shellescape(expand('%:p'))))
    endfunction

    function! s:LTeXCorrectWord() abort
        let l:word = expand('<cword>')
        if empty(l:word)
            echo 'No word under cursor.'
            return
        endif

        echo trim(system('LTeXConfigManipulator add dictionary.currentLang ' . shellescape(l:word) . ' --texFile ' . shellescape(expand('%:p'))))
    endfunction

    function! s:LTeXWrongWord() abort
        let l:word = expand('<cword>')
        if empty(l:word)
            echo 'No word under cursor.'
            return
        endif

        echo trim(system('LTeXConfigManipulator remove dictionary.currentLang ' . shellescape(l:word) . ' --texFile ' . shellescape(expand('%:p'))))
    endfunction

    function! s:LTeXSetLanguage(language) abort
        echo trim(system('LTeXConfigManipulator set language ' . shellescape(a:language) . ' --texFile ' . shellescape(expand('%:p'))))
    endfunction

    let s:ltexExecName = has('win32') ? 'ltex-ls-plus.bat' : 'ltex-ls-plus'
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'ltex-ls-plus',
                \ 'cmd': {server_info -> [s:ltexExecName]},
                \ 'allowlist': ['tex', 'bib'],
                \ 'workspace_config': function('s:LtexWorkspaceConfig'),
                \ })

    command! CorrectWord call s:LTeXCorrectWord()
    command! WrongWord call s:LTeXWrongWord()
    command! -nargs=1 LTeXSetLanguage call s:LTeXSetLanguage(<q-args>)
endif

" End: LaTeX Settings

" Start: Python Settings

" npm install -g pyright
if executable('pyright-langserver')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'pyright',
                \ 'cmd': {server_info->[LspNodeExecutable('pyright-langserver'), '--stdio']},
                \ 'allowlist': ['python'],
                \ 'root_uri': {server_info->lsp#utils#path_to_uri(getcwd())},
                \ 'initialization_options': {},
                \ })

    autocmd FileType python setlocal omnifunc=lsp#complete

    autocmd FileType python set colorcolumn=100

    autocmd FileType python nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType python nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType python nnoremap <buffer> gr :LspReferences<CR>
endif

" End: Python Settings

" Start: Haskell Settings

" Use ghcup
if executable('haskell-language-server-wrapper')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'haskell-language-server',
                \ 'cmd': {server_info -> ['haskell-language-server-wrapper', '--lsp']},
                \ 'allowlist': ['haskell'],
                \ 'root_uri': {server_info -> lsp#utils#path_to_uri(
                \     lsp#utils#find_nearest_parent_file_directory(
                \         lsp#utils#get_buffer_path(),
                \         ['cabal.project', 'stack.yaml', 'hie.yaml', '.git']
                \     )
                \ )},
                \ })

    autocmd FileType haskell setlocal omnifunc=lsp#complete

    autocmd FileType haskell set colorcolumn=100

    autocmd FileType haskell nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType haskell nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType haskell nnoremap <buffer> gr :LspReferences<CR>
endif

" End: Haskell Settings

" Start: C Settings

" Use clangd
if executable('clangd')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info -> ['clangd']},
                \ 'allowlist': ['c', 'cpp'],
                \ })

    autocmd FileType c setlocal omnifunc=lsp#complete
    autocmd FileType cpp setlocal omnifunc=lsp#complete

    autocmd FileType c set colorcolumn=100
    autocmd FileType cpp set colorcolumn=100

    autocmd FileType c nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType c nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType c nnoremap <buffer> gr :LspReferences<CR>
    autocmd FileType cpp nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType cpp nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType cpp nnoremap <buffer> gr :LspReferences<CR>
endif

" End: C Settings

" Start: JavaScript Settings

" npm install -g typescript@6 typescript-language-server
if executable('typescript-language-server')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'typescript-language-server',
                \ 'cmd': {server_info -> [LspNodeExecutable('typescript-language-server'), '--stdio']},
                \ 'allowlist': ['javascript'],
                \ })

    autocmd FileType javascript setlocal omnifunc=lsp#complete

    autocmd FileType javascript set colorcolumn=100

    autocmd FileType javascript nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType javascript nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType javascript nnoremap <buffer> gr :LspReferences<CR>
endif

" End: JavaScript Settings

" Start: HTML Settings

" npm install -g vscode-langservers-extracted
" Set 'snippetSupport': v:true in ~/.vim/plugged/vim-lsp/autoload/lsp.vim
if executable('vscode-html-language-server')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'html-language-server',
                \ 'cmd': {server_info -> [LspNodeExecutable('vscode-html-language-server'), '--stdio']},
                \ 'allowlist': ['html'],
                \ })

    autocmd FileType html setlocal omnifunc=lsp#complete

    autocmd FileType html set colorcolumn=100

    autocmd FileType html nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType html nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType html nnoremap <buffer> gr :LspReferences<CR>
endif

" End: HTML Settings

" Start: CSS Settings

" npm install -g vscode-langservers-extracted
" Set 'snippetSupport': v:true in ~/.vim/plugged/vim-lsp/autoload/lsp.vim
if executable('vscode-css-language-server')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'css-language-server',
                \ 'cmd': {server_info -> [LspNodeExecutable('vscode-css-language-server'), '--stdio']},
                \ 'allowlist': ['css'],
                \ })

    autocmd FileType css setlocal omnifunc=lsp#complete

    autocmd FileType css set colorcolumn=100

    autocmd FileType css nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType css nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType css nnoremap <buffer> gr :LspReferences<CR>
endif

" End: CSS Settings

" Start: PHP Settings

" Use https://github.com/jorgsowa/php-lsp
if executable('php-lsp')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'php-language-server',
                \ 'cmd': {server_info -> ['php-lsp']},
                \ 'allowlist': ['php'],
                \ })

    autocmd FileType php setlocal omnifunc=lsp#complete

    autocmd FileType php set colorcolumn=100

    autocmd FileType php nnoremap <buffer> gd :LspDefinition<CR>
    autocmd FileType php nnoremap <buffer> gh :LspHover<CR>
    autocmd FileType php nnoremap <buffer> gr :LspReferences<CR>
endif

" End: PHP Settings

