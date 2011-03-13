" complete plugin for user custom dict file
" 增强字典补全
" :CUstomdictadd filename 添加带注释的字典
" :CUstomdictclear 清除当前字典
" :CUstomdictsetoption 设置选项
" Last Change: 2011-3-15
" Maintainer: sunsol
" License:	This file is placed in the public domain.

if exists("g:custom_dict_plugin")
	finish
endif
let g:custom_dict_plugin = 1

" default option {{{
let g:custom_dict_comment_flags = ['--','//']
let g:custom_dict_usestartmatch=1
let g:custom_dict_usesort=1
let g:custom_dict_usesortbykind=1
let g:custom_dict_maxlen=5000
let g:custom_dict_enableduplicate=0
let g:custom_dict_ignorecase=1

let s:cmd_error_message='参数错误 请使用<tab>提示功能'
" }}}

function! g:Custom_dict_set(option, ...)"{{{
	if a:option == "custom_dict_comment_flags" && a:0
		let b:custom_dict_comment_flags=a:000
            elseif a:option == "custom_dict_usestartmatch"
		let b:custom_dict_usestartmatch= a:0==0 || a:1 == "1" 
            elseif a:option == "custom_dict_usesort"
		let b:custom_dict_usesort= a:0==0 || a:1 == "1"
            elseif a:option == "custom_dict_usesortbykind"
		let b:custom_dict_usesortbykind= a:0==0 || a:1=="1"
            elseif a:option == "custom_dict_maxlen" && a:0
		let b:custom_dict_maxlen=str2nr(a:1)
            elseif a:option == "custom_dict_enableduplicate"
		let b:custom_dict_enableduplicate=a:0==0 || a:1=="1"
                call s:Dup()
            elseif a:option == "custom_dict_ignorecase"
		let b:custom_dict_ignorecase=a:0==0 || a:1=="1"
                call s:Ignorecase()
            else
                echoe s:cmd_error_message
	endif
endfunc"}}}

function! s:Complete_command(A,L,P)"{{{
   let line=a:L[0:a:P] . 'aaa'
   if len(split(line,'\s\+')) == 2
       return ["custom_dict_comment_flags","custom_dict_usestartmatch","custom_dict_usesort","custom_dict_usesortbykind","custom_dict_maxlen","custom_dict_enableduplicate","custom_dict_ignorecase"]
   else
       return []
   endif
endfunc"}}}

function! s:Custom_dict_init() "{{{
        if exists("b:custom_dict_already_set")
                return
        endif
	if !exists("b:custom_dict_comment_flags")
		let b:custom_dict_comment_flags=g:custom_dict_comment_flags 
	endif
	if !exists("b:custom_dict_usestartmatch")
		let b:custom_dict_usestartmatch=g:custom_dict_usestartmatch
	endif
	if !exists("b:custom_dict_usesort")
		let b:custom_dict_usesort=g:custom_dict_usesort
	endif
	if !exists("b:custom_dict_usesortbykind")
		let b:custom_dict_usesortbykind=g:custom_dict_usesortbykind
	endif
	if !exists("b:custom_dict_maxlen")
		let b:custom_dict_maxlen=g:custom_dict_maxlen
	endif
	if !exists("b:custom_dict_enableduplicate")
		let b:custom_dict_enableduplicate=g:custom_dict_enableduplicate
	endif
	if !exists("b:custom_dict_ignorecase")
		let b:custom_dict_ignorecase=g:custom_dict_ignorecase
	endif
        let b:custom_dict_already_set=1
endfunc "}}}

function! s:Pygetdict(file) " {{{
" word在行首 空格或\t分割后面的menu和kind 可以没有menu或kind,info内容需要开头有空白 
python <<EOF

import vim

def getencs():
    encs = vim.eval('&fileencodings').split(',')
    enc = vim.eval('&fileencoding')
    if enc not in encs:
        encs.insert(0,enc)
    enc = vim.eval('&encoding')
    if  enc not in encs:
        encs.insert(1,enc)
    encs = filter(None,encs)
    return encs

def strtovim(lst): # {{{
    ''' list_ must is [{..},{..}]'''
    s = []
    enc='utf8'
    for onedict in lst:
        ss = []
        for keyword in onedict:
            ss.append('"' + repr(unicode(keyword,enc))[2:-1] + '":"'+
                repr(unicode(onedict.get(keyword).replace('"',"'"),enc))[2:-1] + '"')
        s.append('{' + ','.join(ss) + '}')
    return '[' + ','.join(s) + ']' # }}}


def parsefile(f): # {{{
    import re,codecs
    iscomment=lambda x:[y for y in vim.eval('b:custom_dict_comment_flags') if x.startswith(y)]
    
    for enc in getencs():
        try:
            results=[]
            word=menu=kind=info=''
            status='wordline'
            i=0
            for y in codecs.open(f,'r',enc):
                i+=1
                x=y.encode('utf8')
                if iscomment(x): continue
                if status=='info':
                    if not x.strip():
                        info=info+x
                        continue
                    elif  x[0] in ('\t',' '):
                        if not spaces:
                           spaces=x[:len(x)-len(x.lstrip())]
                        if x.startswith(spaces):
                            info=info+x[len(spaces):]
                        else:
                            info=info+x
                        continue
                    else:
                        status='wordline'
                if status=='wordline':
                    if not x.strip():
                        continue
                    elif x[0] in ('\t',' '):
                        vim.command("echom 'ERROR %s %d:"%(f,i)+x.replace("'",'"')+"'")
                        continue
                    elif word:
                        results.append({'word':word,'menu':menu,'info':info,'kind':kind})
                    l=re.split(r'\s+',x.strip())
                    word=l[0]
                    info=''
                    if len(l)>1 and len(l[1])==1:
                        kind=l[1]
                        menu=' '.join(l[2:]).strip()
                    elif len(l)>2 and len(l[-1])==1:
                        kind=l[-1]
                        menu=' '.join(l[1:-1]).strip()
                    else:
                        menu=' '.join(l[1:]).strip()
                        kind=''
                    status='info'
                    spaces=0
            if word:
                results.append({'word':word,'menu':menu,'info':info,'kind':kind})
            return results
        except LookupError:
            pass
        except UnicodeDecodeError:
            pass # }}}


r=parsefile(vim.eval('a:file'))
r=strtovim(r)
vim.command("let l:result=" + r)

EOF

    return result
endfun " }}}

function! g:Custom_dict_add(file)"{{{
    """ TODO 绝对路径？
    call s:Custom_dict_init()
    if exists("b:custom_dict_files")
        if index(b:custom_dict_files,a:file)>=0
            return
        else
            call add(b:custom_dict_files,a:file)
        endif
    else
        let b:custom_dict_files=[a:file]
    endif
    if ! exists("b:custom_dict")
        let b:custom_dict=[]
    endif
    call extend(b:custom_dict,s:Pygetdict(a:file))
    call s:Dup()
    call s:Ignorecase()
endfunc"}}}

function! g:Custom_dict_clear()"{{{
    if exists("b:custom_dict")
        unlet b:custom_dict
    endif
    if exists("b:custom_dict_files")
        unlet b:custom_dict_files
    endif
endfunc"}}}

function! s:Getpos()"{{{
    let pos=col('.')-1
    let line=getline('.')
    while pos>0 && line[pos-1] =~ '\k'
        let pos -= 1
    endwhile
    return pos
endfunc"}}}

function! s:Sortbykind(i1,i2)"{{{
    if a:i1.kind<a:i2.kind
        return 0
    elseif a:i1.kind>a:i2.kind
        return 1
    elseif a:i1.word<a:i2.word
        return 0
    else
        return 1
    endif
endfunc"}}}

function! s:Sortbyword(i1,i2)"{{{
    if a:i1.word<a:i2.word
        return 0
    else
        return 1
    endif
endfunc"}}}

function! s:Sort(lst)"{{{
    if ! b:custom_dict_usesort
        return a:lst
    endif
    if b:custom_dict_usesortbykind
        return sort(a:lst,function("s:Sortbykind"))
    else
        return sort(a:lst,function("s:Sortbyword"))
    endif
endfunc"}}}

function! s:Dup()"{{{
    if exists("b:custom_dict")
        let i=0
        while i<len(b:custom_dict)
            let b:custom_dict[i].dup = b:custom_dict_enableduplicate
            let i=i+1
        endwhile
    endif
endfunc"}}}

function! s:Ignorecase()"{{{
    if exists("b:custom_dict")
        let i=0
        while i<len(b:custom_dict)
            let b:custom_dict[i].icase = b:custom_dict_ignorecase
            let i=i+1
        endwhile
    endif
endfunc"}}}

function! s:Filter(base)"{{{
    if a:base != ""
        let s=a:base
    else
        let s=getline('.')[s:Getpos():col('.')-1]
        if s==""
            let s=".*"
        endif
    endif
    let l=[]
    let m=''
    if b:custom_dict_usestartmatch
        let m="^"
    endif
    if b:custom_dict_ignorecase
        let m='\c' . m
    endif
    let m= m . s
    for x in b:custom_dict
        if x.word =~ m 
            call add(l,x)   
        endif
    endfor
    return s:Sort(l)
endfunc"}}}

function! g:Custom_dict_pop_complete()"{{{
    if exists("b:custom_dict")
        call complete(s:Getpos(),s:Filter(''))
    endif
    return ''
endfunc"}}}

function! g:Custom_dict_complete(findstart,base)"{{{
    if a:findstart
        if exists("b:custom_dict")
            return s:Getpos()
        else
            return -1
        endif
    else
        if a:base==""
            let s=".*"
        else
            let s=a:base
        endif
        if len(b:custom_dict)<b:custom_dict_maxlen
            return s:Filter(s)
        else
            let m=''
            if b:custom_dict_usestartmatch
                let m="^"
            endif
            if b:custom_dict_ignorecase
                let m='\c' . m
            endif
            let m = m . s
            for x in b:custom_dict
                if x.word =~ m
                    call complete_add(x)
                endif
            endfor
        endif
    endif
endfun"}}}
	

command! -nargs=+ -complete=customlist,s:Complete_command CUstomdictsetoption call g:Custom_dict_set(<f-args>)
com! -nargs=1 -complete=file CUstomdictadd call g:Custom_dict_add(<f-args>)
com! -nargs=0 CUstomdictclear call g:Custom_dict_clear()
au BufEnter * call s:Custom_dict_init()

"set completefunc=g:Custom_dict_complete

" vim: set et sts=4 sw=4 fdm=marker:
