"tip
" W,B在html时很有用
" qk ... 记录宏
" "kp  打印宏

" 通用设置 {{{
fixdel
set nocompatible
set backspace=2
set fencs=ucs-bom,utf-8,gb18030,cp936   
setglobal fileencoding=utf-8
set mouse=a
set nobomb
set ruler   "显示当前行位置
set showcmd
set showmatch "显示括号匹配
set ambiwidth=double	"全角"
set completeopt=menu,longest,preview   "补全窗口"
set display=lastline,uhex	"显示长内容最后一行和不识别字符"
set ignorecase		"忽略大小写"
set smartcase		"自动使用大小写区分"
set autoindent		"自动缩近"
set cindent		"缩近使用C方式"
set formatoptions+=M    "在连接行时，不要在多字节字符之前或之后插入空格。
set laststatus=2	"总是显示状态"
set hlsearch		"搜索高亮"
set helplang=cn
set statusline=%<%#SignColumn#%F%m\ \ %r%<%#DiffAdd#%{getcwd()}%h\ \ %#DiffDelete#(%(%l,%c%))\ %#DiffChange#%p%% "状态显示内容"
"}}}

" 切换到当前路径:cd.
command! CD cd %:p:h
" 使用F2切换utf8和cp936
"nmap <F2> :call ToggleCHS()<cr>  

function! VisualSearch(direction) range
" 在块选择模式下使用搜索 {{{
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
endfunction "}}}

" 在块选择模式下按 * or # 自动搜索选择部分
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

function! ToggleCHS() 
" 切换utf-8和cp936 {{{
  let l:enc = &fileencoding
  if l:enc == "utf-8"
      execute "set nobomb"
      execute "set fileencoding=cp936"
      execute "w"
  else
      if l:enc == "cp936" || l:enc == "gb18030"
          execute "set fileencoding=utf-8"
          execute "w"
      endif
  endif
endfunction "}}}
command -nargs=0 ToggleCHS call ToggleCHS()

" 文件类型 {{{
filetype on
filetype plugin on
filetype indent on
syn on
" 设置语法着色分析的行数
let g:vimsyn_minlines=300
let g:vimsyn_maxlines=3000
au FileType * lcd %:p:h
set tags=./tags,tags;
autocmd Filetype *
	    \	if &omnifunc == "" |
	    \		setlocal omnifunc=syntaxcomplete#Complete |
	    \	endif
" 提示菜单快捷键 忽略，翻页
inoremap <expr> <C-J>	   pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K>	   pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-X><C-K>"

" vim {{{
au FileType vim set foldmethod=marker
au FileType vim CUstomdictsetoption custom_dict_enableduplicate 0
au FileType vim CUstomdictsetoption custom_dict_usestartmatch 0
au FileType vim CUstomdictsetoption custom_dict_usesortbykind 1
au FileType vim CUstomdictadd ~/.vim/vim.dict
au FileType vim set completefunc=g:Custom_dict_complete
" }}}

" html and javascript  {{{
au FileType javascript set makeprg=/home/zn/bin/jsl\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -conf\ '/home/zn/bin/jsl.conf'\ -proess\ %
au FileType javascript set errorformat=%f(%l):\ %m
au FileType javascript map <F5> :!js %
au FileType javascript CUstomdictsetoption custom_dict_enableduplicate 1
au FileType javascript CUstomdictsetoption custom_dict_usestartmatch 0
au FileType javascript CUstomdictsetoption custom_dict_usesortbykind 1
au FileType javascript CUstomdictsetoption custom_dict_ignorecase 1
au FileType javascript CUstomdictadd ~/.vim/javascript.dict
au FileType javascript set completefunc=g:Custom_dict_complete
au FileType css set dictionary=~/.vim/css.dict
au FileType html set shiftwidth=4 "(自动) 缩进使用的步进单位，以空白数目计
au FileType html set smarttab   "插入 <Tab> 时使用 'shiftwidth'
au FileType html set tabstop=4     "<Tab> 在文件里使用的空格数
" }}}

" python {{{
au FileType python map <F5> :!python %
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
"au FileType python set complete+=k/path/to/pydiction 
"au FileType python set iskeyword+=.
au FileType python set noignorecase "区分大小写
au FileType python set dictionary=~/.vim/pydiction.dict
" pydoc <leader>pw <leader>pW
"}}}

" c {{{
au FileType c,cpp set tags=~/.vim/c.tags,tags;
au FileType cpp,c set shiftwidth=4 "(自动) 缩进使用的步进单位，以空白数目计
au FileType cpp,c set smarttab   "插入 <Tab> 时使用 'shiftwidth'
au FileType cpp,c set tabstop=4     "<Tab> 在文件里使用的空格数
au FileType cpp,c set smartindent  "C 程序智能自动缩进
au FileType cpp,c set number   "显示行号
au FileType cpp,c set foldmethod=syntax   
au FileType cpp,c set foldenable
au FileType cpp,c set noignorecase 
au FileType cpp,c set ambiwidth=single

" 需指定目录，该工程目录已生成tags和cscope.out
" cscope -bkq -i cscope.files
function! Ctagadd(filename)
  if has("gui_running")
	  execute "cs add " . a:filename 
	  set cscopequickfix=s-,c-,d-,i-,t-,e-
	  set csto=0
	  set cst
	  set csverb
	  menu cscope.查找符号\ Alt-m :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  nmap <M-m> :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  menu cscope.查找定义 :cs find g <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  menu cscope.查找调用 :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  menu cscope.反查调用\ Alt-n :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  nmap <M-n> :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  menu cscope.查找字串 :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  menu cscope.查找字串egrep :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	  menu cscope.查找文件 :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
	  menu cscope.反查文件 :cs find i <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
	  execute "set tags+="  . a:dirname . "/tags"
  endif
endfunction
au FileType c,cpp command  -nargs=1 -complete=file CTAGadd call Ctagadd(<q-args>)
" echofunc  next alt+= alt+-
let g:EchoFuncLangsUsed=["c","cpp"]
" }}}
"}}}
 
" 插件 {{{
" minibuf
let g:miniBufExplMapWindowNavVim = 1      " Ctrl+hjkl
let g:miniBufExplMapWindowNavArrows = 1   " Ctrl+<up><left>..
let g:miniBufExplMapCTabSwitchBufs = 1    " Ctrl+tab
let g:miniBufExplModSelTarget=1
let g:miniBufExplForceSyntaxEnable=1

" F3 TLIST
"let Tlist_Ctags_Cmd='/usr/bin/ctags'
let g:Tlist_Show_Menu = 1
let g:Tlist_Use_Right_Window = 1
let g:Tlist_Exit_OnlyWindows = 1
nmap <F3> :TlistToggle<cr>

" F4 NERD
nmap <F4> :NERDTreeToggle<cr>
let g:NERDTreeQuitOnOpen=1

" :help vimwiki
" <leader> ww ----> index.wiki at ~/vimwiki
let g:vimwiki_use_mouse=1

" vimim的模糊拼音和云输入设定
"let g:vimim_fuzzy_search=1
"let g:vimim_static_input_style=1
"let g:vimim_cloud_sogou=1
 
" wmgraphviz dot
" <leader> lv ----> view
" <leader> ll ----> compile to graph
" let g:WMGraphviz_dot="dot"   " 有向图
" let g:WMGraphviz_dot="neato"   " 无向图
" let g:WMGraphviz_dot="fdp"   " 紧凑无向图
" let g:WMGraphviz_dot="twopi"   " 辐射图
" let g:WMGraphviz_dot="circo"   " 环状图
let g:WMGraphviz_output="png"
let g:WMGraphviz_viewer="gthumb"
 
" 利用google翻译单词
nmap gh :Trans<CR>

" <Alt+x> <Alt+c> 切换注释
let g:EnhCommentifyUseAltKeys = 'yes'

" AlignCtrl 设置对齐方式
" w去掉每行的开始空白 W保留开始空白 I以首行为基线
" l左对齐 r右对齐 lr中间对齐 -跳过 :其余的不对齐 每一项可以指定一列 如 -lrll-	
let g:Align_xstrlen=3 "对齐中文和tab
" Tabularize /匹配项（一字符）/命令l[x]c[x]r[x] x为距离

"let g:ConqueTerm_SendVisKey = '<F9>'

" disable eclim
let g:EclimDisabled=1
" }}}
" vim: set et sts=4 sw=4 fdm=marker:
