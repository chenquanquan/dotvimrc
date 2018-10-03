"
" A (not so) minimal vimrc.
"

" You want Vim, not vi. When Vim finds a vimrc, 'nocompatible' is set anyway.
" We set it explicitely to make our position clear!
set nocompatible

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set autoindent             " Indent according to previous line.
"set expandtab              " Use spaces instead of tabs.
set softtabstop =8         " Tab key indents by 4 spaces.
set shiftwidth  =8         " >> indents by 4 spaces.
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
set wrapscan               " Searches wrap around end-of-file.
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
" Bundle
"
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
Plugin 'tpope/vim-fugitive'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/dyng/ctrlsf.vim'
Plugin 'https://github.com/majutsushi/tagbar'
Plugin 'https://github.com/vim-scripts/a.vim'
Plugin 'https://github.com/easymotion/vim-easymotion'
Plugin 'https://github.com/kien/ctrlp.vim'
Plugin 'genutils'
Plugin 'lookupfile'
"Plugin 'youdao.dict'
Plugin 'VincentCordobes/vim-translate'

""""""""""""
" Local configure
"
let mapleader=";"
nnoremap <silent> <leader>fe :Sexplore!<cr>
nnoremap <leader>ss :source ~/.vimrc<cr>
nnoremap <silent> <leader>ee :e ~/.vimrc<cr>
autocmd! bufwritepost .vimrc source ~/.vimrc

nnoremap <leader>bf :buffers<CR>:buffer<Space>

set number
set wildmenu

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
" 开启 YCM 标签补全引擎
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
nnoremap <leader>ygf :YcmCompleter GoToDefinitionx<CR>
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
"vnoremap <silent> <C-T> :<C-u>Ydv<CR>
"nnoremap <silent> <C-T> :<C-u>Ydc<CR>
"noremap <leader>yd :<C-u>Yde<CR>

""
" Translate-shell
let g:translate#default_languages = {
      \ 'zh': 'en',
      \ 'en': 'zh'
      \ }
