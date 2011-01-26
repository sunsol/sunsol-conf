set nocompatible
set fencs=utf-8,utf-16le,gb18030,cp936   "自动识别中文"
set mouse=a
set ruler   "显示当前行位置
set showcmd
set ambiwidth=double	"全角"
set completeopt=menu,longest,preview   "补全窗口"
set display=lastline,uhex	"显示长内容最后一行和不识别字符"
set ignorecase		"忽略大小写"
set smartcase		"自动使用大小写区分"
set autoindent		"自动缩近"
set cindent		"缩近使用C方式"
set formatoptions+=M    "在连接行时，不要在多字节字符之前或之后插入空格。
set laststatus=2	"总是显示状态"
"状态显示内容"
set statusline=%<%F%m\ \ %r%<%{getcwd()}%h\ \ (%(%l,%c%))\ %p%%
set hlsearch		"搜索高亮"

" From an idea by Michael Naumann
" 在块选择模式下使用搜索
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" 在块选择模式下按 * or # 自动搜索选择部分
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" 切换utf-8和cp936
function! ToggleCHS() 
  let l:enc = &fileencoding
  if l:enc == "utf-8"
      execute "set fileencoding=cp936"
      execute "w"
  else
      if l:enc == "cp936"
          execute "set fileencoding=utf-8"
          execute "w"
      endif
  endif
endfunction

filetype on
filetype plugin on
filetype indent on
syn on
" 设置语法着色分析的行数
let g:vimsyn_minlines=300
let g:vimsyn_maxlines=3000
au FileType * lcd %:p:h
set tags=./tags,tags;

au FileType python set shiftwidth=4 "(自动) 缩进使用的步进单位，以空白数目计
au FileType python set softtabstop=4   "编辑时 <Tab> 使用的空格数 
au FileType python set smarttab   "插入 <Tab> 时使用 'shiftwidth'
au FileType python set expandtab   "键入 <Tab> 时使用空格
au FileType python set tabstop=4     "<Tab> 在文件里使用的空格数
au FileType python set smartindent  "C 程序智能自动缩进
au FileType python set number   "显示行号
au FileType python set foldmethod=indent   "按缩近折叠
au FileType python set foldenable
au FileType python set ambiwidth=single
" http://vim.sourceforge.net/scripts/script.php?script_id=850
" pydiction  增加使用 pydiction.py module.py
"
au FileType python let g:pydiction_location = '~/.vim/pydiction.dict' 
au FileType python set complete+=k/path/to/pydiction 
au FileType python set iskeyword+=.


"............"
" 使用F2切换utf8和cp936
nmap <F2> :call ToggleCHS()<cr>  
" 切换到当前路径
nmap <leader>cd :cd %:p:h<cr>
" :help vimwiki
" <leader> ww ----> index.wiki at ~/vimwiki
let g:vimwiki_use_mouse=1
" vimim的模糊拼音和云输入设定
let g:vimim_fuzzy_search=1
"let g:vimim_static_input_style=1
"let g:vimim_cloud_sogou=1
