" complete plugin for user custom dict file
" <C-X><C-U> 补全
" :MYsetdict filename 添加带注释的字典
" Last Change: 2011-2-15
" Maintainer: sunsol
" License:	This file is placed in the public domain.


if exists("g:mycomplete_plugin")
	finish
endif
let g:mycomplete_plugin = 1

function! s:Pygetdict()
python <<EOF
class Mylist(list):
    def __str__(self):
    	import vim
    	enc=vim.eval('&fileencoding')
        if not enc:
            enc=vim.eval('&encoding')
	s=[]
	for x in self:
	    ss=[]
	    for y in x:
		ss.append('"'+repr(unicode(y,enc))[2:-1]+'":"'+repr(unicode(x.get(y).replace('"',"'"),enc))[2:-1]+'"')
	    s.append('{'+','.join(ss)+'}')
	return '['+','.join(s)+']'

def parsefile(f):
    import re,string
    r=Mylist()
    s=''
    for x in open(f):
        x=x.strip()
        if x.startswith('--') or x.startswith('//') or not x:
            continue
        if x[-1]=='/':
            s= s and s+"\n"+x[:-1] or x
            continue
        else:
            s=s+x
        d=re.split('\s+',s,1)
        if len(d)>1:
	    if len(d[1])>20:
		r.append({'word':d[0],'info':d[1]})
	    else:
		r.append({'word':d[0],'menu':d[1]})
        else:
            r.append({'word':d[0]})
        s=''
    return r
def gendict():
    import vim,os
    if vim.eval('exists("b:mycompletedictfile")'):
        d=vim.eval('b:mycompletedictfile')
        #os.chdir(vim.eval('expand("%:p:h")'))
        r=parsefile(d)
        vim.command('let b:mycompletedict=' + str(r))
gendict()
EOF
endfun

function! g:Mycomplete(findstart,base)
    if a:findstart
        let x=col('.')-1
        let l=getline('.')
        while x>0 && l[x-1] =~ '\w'
	    let x-=1
	endwhile
	return x
    else
	let r=[]
	for x in b:mycompletedict
	    if x.word =~ '^' . a:base
		call add(r,x)
	    endif
	endfor
	return r
    endif
endfun
	
function! g:Mysetdict(filename)
	let b:mycompletedictfile=expand(a:filename)
	call s:Pygetdict()
	set completefunc=g:Mycomplete
endfun

com! -nargs=1 -complete=file MYsetdict call g:Mysetdict(<q-args>)

" vim: set et sts=4 sw=4:
