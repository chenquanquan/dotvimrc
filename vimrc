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
"set wrapscan               " Searches wrap around end-of-file.
set nowrapscan               " searches no wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.
set scrolloff =3

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('$HOME/.vim/plugged')

" Make sure you use single quotes
" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)

Plug 'https://github.com/dyng/ctrlsf.vim'
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/vim-scripts/a.vim'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

"" For c
""Plug 'WolfgangMehner/c-support'
""Plug 'w0rp/ale' "Check syntax in Vim asynchronously and fix files

"" New plugin
Plug 'airblade/vim-gitgutter'
Plug 'kshenoy/vim-signature'

"vim mark
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'

Plug 'Yggdroot/LeaderF', { 'do': './install.sh' } " File & buffer search
Plug 'https://github.com/easymotion/vim-easymotion' " Jump in window
Plug 'itchyny/lightline.vim' " Status line
Plug 'liuchengxu/vim-which-key' " Keymap prompts
Plug 'jlanzarotta/bufexplorer' " Buffer
Plug 'https://github.com/scrooloose/nerdtree' " File explorer
Plug 'https://github.com/majutsushi/tagbar' " Tag
Plug 'tpope/vim-fugitive' " Git tools
""""Plug 'frazrepo/vim-rainbow' " gives every pair of brackets a unique color
Plug 'mileszs/ack.vim' " File search
Plug 'lfv89/vim-interestingwords' " high light key word (<lead>k)
Plug 'rust-lang/rust.vim'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local configure
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number
set wildmenu

""
" theme
set background=dark
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
""""hi CursorLine   cterm=NONE ctermbg=60 ctermfg=white guibg=darkred guifg=white
""""hi CursorColumn cterm=NONE ctermbg=60 ctermfg=white guibg=darkred guifg=white

"highlight Pmenu ctermbg=gray guibg=gray
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE

autocmd! bufwritepost .vimrc source $HOME/.vimrc

""""
"" Local keymap
let mapleader=";"

""""
"" Local stype
highlight OverLength ctermbg=darkyellow ctermfg=white
match OverLength /\%81v.\+/
""""highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
""""augroup vimrc_autocmds
""""    autocmd!
""""    autocmd BufEnter,WinEnter * call matchadd('OverLength', '\%>80v.\+', -1)
""""augroup END

"" Search block
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Programe language settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C/C++
"autocmd BufNewFile,BufRead *.c setlocal noexpandtab tabstop=8 shiftwidth=8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugin & keymap settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""
" vim-rainbow
let g:rainbow_active = 1

""
" LeaderF
let g:Lf_WindowPosition = 'popup'
let g:Lf_PreviewInPopup = 1
let g:Lf_UseCache = 0

""
" vim-which-key - Start
let g:which_key_map =  {}
call which_key#register(mapleader, "g:which_key_map")
set timeoutlen=500
nnoremap <silent> <leader> :WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :WhichKeyVisual '<leader>'<CR>

"""""""""""""""""""""""""""""""""""""""
"" Uncategorized
"""""""""""""""""""""""""""""""""""""""
imap jj <Esc>
nnoremap <Leader>jj :<Esc>

nnoremap <Leader>w :w<cr>
nnoremap <Leader>wa :wa<cr>
nnoremap <Leader>q :q<cr>

nnoremap <Leader>cc :set cursorline! cursorcolumn!<CR>
nnoremap <silent> <Leader>ll ml:execute 'match Search /\%'.line('.').'l/'<CR>

nnoremap <C-n> :cnext<CR>
nnoremap <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

""
" vim-gitgutter
nnoremap ]c <Plug>GitGutterNextHunk
nnoremap [c <Plug>GitGutterPrevHunk
nnoremap <Leader>hs <Plug>GitGutterStageHunk
nnoremap <Leader>hu <Plug>GitGutterUndoHunk


"""""""""""""""""""""""""""""""""""""""
"" Buffer
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.b = { 'name' : '+Buffer' }
nnoremap <Leader>bj :<Esc>
nnoremap <leader>bb :buffers<CR>:buffer<Space>
""
" LeaderF
nnoremap <silent> <leader>bl :LeaderfBuffer<cr>
""
" bufexplorer
nnoremap <leader>be :BufExplorer<CR>
nnoremap <leader>bt :ToggleBufExplorer<CR>
nnoremap <leader>bs :BufExplorerHorizontalSplit<CR>
nnoremap <leader>bv :BufExplorerVerticalSplit<CR>
""
" match 80 column highlight
nnoremap <leader>bm :match OverLength /\%81v.\+/<CR>
nnoremap <leader>bu :match OverLength<CR>

""
" match 
"
nnoremap <leader>bl :set list<CR>
nnoremap <leader>bn :set nolist<CR>
nnoremap <leader>bu :match OverLength<CR>
nnoremap <leader>bu :match OverLength<CR>


"""""""""""""""""""""""""""""""""""""""
"" Edit
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.e = { 'name' : '+Edit' }
nnoremap <Leader>ej :<Esc>
nnoremap <silent> <leader>ep :e $HOME/.vimrc<cr>


"""""""""""""""""""""""""""""""""""""""
"" Load
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.l = { 'name' : '+load' }
nnoremap <Leader>lj :<Esc>
nnoremap <leader>lp :source $HOME/.vimrc<cr>

""
" ctags & cscope
" :cw/copen  - list all result
set cscopequickfix=s-,c-,d-,i-,t-,e-
noremap <leader>lt :set tags=tags<cr>
noremap <leader>lc :cs add cscope.out<cr>


"""""""""""""""""""""""""""""""""""""""
"" File
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.f = { 'name' : '+file' }
nnoremap <Leader>fj :<Esc>
nnoremap <silent> <leader>fe :Sexplore!<cr>
""
" LeaderF
nnoremap <leader>ff :LeaderfFile<cr>
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


"""""""""""""""""""""""""""""""""""""""
"" Tag
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.t = { 'name' : '+tag' }
nnoremap <Leader>tj :<Esc>
""
" tagbar
" 设置 tagbar 子窗口的位置出现在主编辑区的左边
let tagbar_left=0
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


"""""""""""""""""""""""""""""""""""""""
"" Jump
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.j = { 'name' : '+jump' }
nnoremap <Leader>jj :<Esc>
""
" vim-easymotion
" <Leader>f{char} to move to {char}
map  <Leader>jf <Plug>(easymotion-bd-f)
nmap <Leader>jf <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap <leader>js <Plug>(easymotion-overwin-f2)
" Move to line
map <Leader>jL <Plug>(easymotion-bd-jk)
nmap <Leader>eL <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>jw <Plug>(easymotion-bd-w)
nmap <Leader>jw <Plug>(easymotion-overwin-w)


"""""""""""""""""""""""""""""""""""""""
"" Search
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.s = { 'name' : '+search' }
nnoremap <Leader>sj :<Esc>

nnoremap <Leader>sa :Ack 
""
" ctrlsf
nmap     <leader>sf <Plug>CtrlSFPrompt
vmap     <leader>sf <Plug>CtrlSFVwordPath
vmap     <leader>sF <Plug>CtrlSFVwordExec
nmap     <leader>sn <Plug>CtrlSFCwordPath
nmap     <leader>sp <Plug>CtrlSFPwordPath
nnoremap <leader>so :CtrlSFOpen<CR>
nnoremap <leader>st :CtrlSFToggle<CR>
inoremap <leader>st <Esc>:CtrlSFToggle<CR>


"""""""""""""""""""""""""""""""""""""""
"" cscope
"""""""""""""""""""""""""""""""""""""""
let g:which_key_map.c = { 'name' : '+cscope' }
nnoremap <Leader>cj :<Esc>
" cscope
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>i :cs find i <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

nmap <Leader>cs :cs find s 
nmap <Leader>cg :cs find g 
nmap <Leader>cc :cs find c 
nmap <Leader>ct :cs find t 
nmap <Leader>ce :cs find e 
nmap <Leader>cf :cs find f 
nmap <Leader>ci :cs find i 
nmap <Leader>cd :cs find d 


"""""""""""""""""""""""""""""""""""""""
"" Mark
"""""""""""""""""""""""""""""""""""""""
nmap <Leader>M <Plug>MarkToggle
nmap <Leader>N <Plug>MarkAllClear
