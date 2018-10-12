"
" A (not so) minimal vimrc.
"

" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitely to make our position clear!
set nocompatible

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop =4         " Tab key indents by 4 spaces.
set shiftwidth  =4         " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
"set wrapscan               " Searches wrap around end-of-file.
set nowrapscan               " searches no wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#handling-backup-swap-undo-and-viminfo-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap//
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo ='100,n$HOME/.vim/files/info/viminfo

""""""""""""
" vim-plug
"
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)


Plug 'tpope/vim-fugitive'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/dyng/ctrlsf.vim'
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/vim-scripts/a.vim'
Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
"Plug 'genutils'
"Plug 'lookupfile'
Plug 'ianva/vim-youdao-translater'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'chr4/nginx.vim'

"" For markdown
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'

"" recommand from vim-go
Plug 'AndrewRadev/splitjoin.vim'
Plug 'garyburd/go-explorer'
Plug 'joereynolds/vim-minisnip'
Plug 'Shougo/neocomplete.vim'

call plug#end()

""""""""""""
" Local configure
"
set number
set wildmenu

""""
"" Local keymap
let mapleader=";"
nnoremap <silent> <leader>fe :Sexplore!<cr>
nnoremap <leader>ss :source ~/.vimrc<cr>
nnoremap <silent> <leader>ee :e ~/.vimrc<cr>
autocmd! bufwritepost .vimrc source ~/.vimrc

nnoremap <leader>bf :buffers<CR>:buffer<Space>

nnoremap <C-n> :cnext<CR>
nnoremap <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
""""
"" Local stype
highlight OverLength ctermbg=darkyellow ctermfg=white
match OverLength /\%81v.\+/

""""
"" Programe language settings
""
" C/C++
autocmd BufNewFile,BufRead *.c setlocal noexpandtab tabstop=8 shiftwidth=8

""
" Go
" run :GoBuild or :GoTestCompile based on the go file
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1 
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_deadline = "5s"
let g:go_auto_type_info = 1
set updatetime=100
let g:go_auto_sameids = 1

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>bb :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>rr  <Plug>(go-run)
autocmd FileType go nmap <Leader>cc <Plug>(go-coverage-toggle)
autocmd FileType go nmap <Leader>ii <Plug>(go-info)
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 
au BufRead,BufNewFile *.gohtml set filetype=gohtmltmpl

""""
"" Plugin settings

""
" ctags & cscope
map <leader>ts :set tags+=./tags<cr> :cs add ./cscope.out<cr>

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>i :cs find i <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

""
" ycmd
" g:ycm_server_python_interpreter
" 开启 YCM 标签补全引擎
"let g:ycm_server_python_interpreter = '/usr/bin/python2'
let g:ycm_collect_identifiers_from_tags_files=0
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax=1
nnoremap <leader>ydd :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>ycc :YcmCompleter ClearCompilationFlagCache<CR>
nnoremap <leader>yfi :YcmCompleter FixIt<CR>
nnoremap <leader>ygd :YcmCompleter GetDoc<CR>
nnoremap <leader>ygI :YcmCompleter GetDocImprecise<CR>
nnoremap <leader>ygp :YcmCompleter GetParent<CR>
nnoremap <leader>ygt :YcmCompleter GetType<CR>
nnoremap <leader>ygi :YcmCompleter GetTypeImprecise<CR>
nnoremap <leader>ygT :YcmCompleter GoTo<CR>
nnoremap <leader>ygd :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>ygf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>ygp :YcmCompleter GoToImprecise<CR>
nnoremap <leader>ygi :YcmCompleter GoToInclude<CR>

""
" NERTree
" 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
nmap <Leader>fl :NERDTreeToggle<CR>
" 设置 NERDTree 子窗口宽度
let NERDTreeWinSize=22
" 设置 NERDTree 子窗口位置
let NERDTreeWinPos="right"
" 显示隐藏文件
let NERDTreeShowHidden=1
" NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1

""
" tagbar
" 设置 tagbar 子窗口的位置出现在主编辑区的左边
let tagbar_left=1
" 设置显示／隐藏标签列表子窗口的快捷键。速记：tag list
nnoremap <Leader>tl :TagbarToggle<CR>
" 设置标签子窗口的宽度
let tagbar_width=32
" tagbar 子窗口中不显示冗余帮助信息
let g:tagbar_compact=1
" 设置 ctags 对哪些代码元素生成标签
let g:tagbar_type_cpp = {
     \ 'ctagstype' : 'c++',
     \ 'kinds'     : [
         \ 'd:macros:1',
         \ 'g:enums',
         \ 't:typedefs:0:0',
         \ 'e:enumerators:0:0',
         \ 'n:namespaces',
         \ 'c:classes',
         \ 's:structs',
         \ 'u:unions',
         \ 'f:functions',
         \ 'm:members:0:0',
         \ 'v:global:0:0',
         \ 'x:external:0:0',
         \ 'l:local:0:0'
     \ ],
     \ 'sro'        : '::',
     \ 'kind2scope' : {
         \ 'g' : 'enum',
         \ 'n' : 'namespace',
         \ 'c' : 'class',
         \ 's' : 'struct',
         \ 'u' : 'union'
     \ },
     \ 'scope2kind' : {
         \ 'enum'      : 'g',
         \ 'namespace' : 'n',
         \ 'class'     : 'c',
         \ 'struct'    : 's',
         \ 'union'     : 'u'
     \ }
\ }

""
" vim-easymotion
" <Leader>f{char} to move to {char}
map  <Leader>ef <Plug>(easymotion-bd-f)
nmap <Leader>ef <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap <leader>es <Plug>(easymotion-overwin-f2)
" Move to line
map <Leader>eL <Plug>(easymotion-bd-jk)
nmap <Leader>eL <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>ew <Plug>(easymotion-bd-w)
nmap <Leader>ew <Plug>(easymotion-overwin-w)

""
" ctrlsf
nmap     <leader>cf <Plug>CtrlSFPrompt
vmap     <leader>cf <Plug>CtrlSFVwordPath
vmap     <leader>cF <Plug>CtrlSFVwordExec
nmap     <leader>cn <Plug>CtrlSFCwordPath
nmap     <leader>cp <Plug>CtrlSFPwordPath
nnoremap <leader>co :CtrlSFOpen<CR>
nnoremap <leader>ct :CtrlSFToggle<CR>
inoremap <leader>ct <Esc>:CtrlSFToggle<CR>

""
" Youdao
noremap <leader>yde :<C-u>Yde<CR>
noremap <leader>ydv :<C-u>Ydv<CR>
noremap <leader>ydc :<C-u>Ydc<CR>

""
" Translate-shell
let g:translate#default_languages = {
      \ 'zh': 'en',
      \ 'en': 'zh'
      \ }

""
" markdown preview
let g:mkdp_path_to_chrome = ""
" path to the chrome or the command to open chrome(or other modern browsers)
" if set, g:mkdp_browserfunc would be ignored
let g:mkdp_browserfunc = 'MKDP_browserfunc_default'
" callback vim function to open browser, the only param is the url to open
let g:mkdp_auto_start = 0
" set to 1, the vim will open the preview window once enter the markdown
" buffer
let g:mkdp_auto_open = 0
" set to 1, the vim will auto open preview window when you edit the
" markdown file
let g:mkdp_auto_close = 1
" set to 1, the vim will auto close current preview window when change
" from markdown buffer to another buffer
let g:mkdp_refresh_slow = 0
" set to 1, the vim will just refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
let g:mkdp_command_for_global = 0
" set to 1, the MarkdownPreview command can be use for all files,
" by default it just can be use in markdown file
let g:mkdp_open_to_the_world = 0
" set to 1, preview server available to others in your network
" by default, the server only listens on localhost (127.0.0.1)
nmap <silent> <F8> <Plug>MarkdownPreview        " for normal mode
imap <silent> <F8> <Plug>MarkdownPreview        " for insert mode
nmap <silent> <F9> <Plug>StopMarkdownPreview    " for normal mode
imap <silent> <F9> <Plug>StopMarkdownPreview    " for insert mode
