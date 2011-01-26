" wmgraphviz.vim plugin
" Author: Wannes Meert
" Email: wannesm@gmail.com
" Version: 1.0.3

if exists('s:loaded')
	finish
endif
let s:loaded = 1

" Settings

if !exists('g:WMGraphviz_dot')
	let g:WMGraphviz_dot = 'dot'
endif

if !exists('g:WMGraphviz_output')
	let g:WMGraphviz_output = 'pdf'
endif

if !exists('g:WMGraphviz_viewer')
	if has('mac')
		let g:WMGraphviz_viewer = 'open'
	elseif has ('unix')
		if executable('xdg-open')
			let g:WMGraphviz_viewer = 'xdg-open'
		else
			if g:WMGraphviz_output == 'ps'
				let g:WMGraphviz_viewer = 'gv'
			else
				let g:WMGraphviz_viewer = 'acroread'
			endif
		endif
	else
		let g:WMGraphviz_viewer = 'open'
	endif
endif

if !exists('g:WMGraphviz_shelloptions')
	let g:WMGraphviz_shelloptions = ''
endif

if !exists('g:WMGraphviz_dot2tex')
	let g:WMGraphviz_dot2tex = 'dot2tex'
endif

if !exists('g:WMGraphviz_dot2texoptions')
	let g:WMGraphviz_dot2texoptions = '-tmath'
endif

" Compilation
" If argument given, use it as output
fu! GraphvizCompile(...)
	if !executable(g:WMGraphviz_dot)
		echoerr 'The "'.g:WMGraphviz_dot.'" executable was not found.'
		return
	endif

	let s:output = a:0 >= 1 ? a:1 : g:WMGraphviz_output
	let s:logfile = expand('%:p:r').'.log'
	" DOT command uses -O option instead of -o because this doesn't work if
	" there are multiple graphs in the file.
	let cmd = '!('.g:WMGraphviz_dot.' -O -T'.s:output.' '.g:WMGraphviz_shelloptions.' '.shellescape(expand('%:p')).' 2>&1) | tee '.shellescape(expand('%:p:r').'.log')
	exec cmd
	exec 'cfile '.escape(s:logfile, ' \"!?''')
endfu

fu! GraphvizCompileToLaTeX(...)
	if !executable(g:WMGraphviz_dot2tex)
		echoerr 'The "'.g:WMGraphviz_dot2tex.'" executable was not found.'
		return
	endif

	let s:logfile = expand('%:p:r').'.log'
	" DOT command uses -O option instead of -o because this doesn't work if
	" there are multiple graphs in the file.
	let cmd = '!(('.g:WMGraphviz_dot2tex.' '.g:WMGraphviz_dot2texoptions.' '.shellescape(expand('%:p')).' > '.shellescape(expand('%:p:r').'.tex').') 2>&1) | tee '.shellescape(expand('%:p:r').'.log')
	exec cmd
	exec 'cfile '.escape(s:logfile, ' \"!?''')
endfu

" Viewing
fu! GraphvizShow()
	if !filereadable(expand('%:p').'.'.g:WMGraphviz_output)
		call GraphvizCompile()
	endif

	if !executable(g:WMGraphviz_viewer)
		echoerr 'Viewer program not found: "'.g:WMGraphviz_viewer.'"'
		return
	endif

	exec '!'.g:WMGraphviz_viewer.' '.shellescape(expand('%:p').'.'.g:WMGraphviz_output)
endfu

" Available functions
com! -nargs=0 GraphvizCompile :call GraphvizCompile()
com! -nargs=0 GraphvizCompilePS :call GraphvizCompile('ps')
com! -nargs=0 GraphvizCompilePDF :call GraphvizCompile('pdf')
com! -nargs=0 GraphvizCompileToLaTeX :call GraphvizCompileToLaTeX()
com! -nargs=0 GraphvizShow : call GraphvizShow()

" Mappings
nmap <silent> <buffer> <LocalLeader>ll :GraphvizCompile<CR>
nmap <silent> <buffer> <LocalLeader>lt :GraphvizCompileToLaTeX<CR>
nmap <silent> <buffer> <LocalLeader>lv :GraphvizShow<CR>

" Completion
let s:completion_type = ''

" Completion dictionaries

let s:attrs = [
\	{'word': 'arrowhead=',     'menu': '线的起始的箭头图案 [E]'},
\	{'word': 'arrowsize=',     'menu': 'Scaling factor for arrowheads [E]'},
\	{'word': 'arrowtail=',     'menu': '线尾的箭头图案 [E]'},
\	{'word': 'bgcolor=',       'menu': '整个图的背景色 [G]'},
\	{'word': 'color=',         'menu': 'Node shape/edge/cluster color [E,G,N]'},
\	{'word': 'comment=',       'menu': 'Any string [E,G,N]'},
\	{'word': 'compound=',      'menu': '允许连线到子图边界,仅用于有向图 [G]'},
\	{'word': 'concentrate=',   'menu': 'Enables edge concentrators [G]'},
\	{'word': 'constraints=',   'menu': 'Use edge to affect node ranking [E]'},
\	{'word': 'decorate=',      'menu': 'If set, line between label and edge [E]'},
\	{'word': 'dir=',           'menu': '线的方向 [E]'},
\	{'word': 'distortion=',    'menu': 'Node distortion [N]'},
\	{'word': 'fillcolor=',     'menu': '填充色，用于子图和节点 [G,N]'},
\	{'word': 'fixedsize=',     'menu': '是否固定大小 [N]'},
\	{'word': 'fontcolor=',     'menu': 'Font face color [E,G,N]'},
\	{'word': 'fontname=',      'menu': 'Font family [E,G,N]'},
\	{'word': 'fontsize=',      'menu': 'Point size of label [E,G,N]'},
\	{'word': 'group=',         'menu': 'Name of node group [N]'},
\	{'word': 'headlabel=',     'menu': '线起始位置上的标签文字 [E]'},
\	{'word': 'headport=',      'menu': 'Location of label [E]'},
\	{'word': 'height=',        'menu': '单位为英寸 [N]'},
\	{'word': 'label=',         'menu': 'Any string [E,N]'},
\	{'word': 'labelangle=',    'menu': 'Ange in degrees [E]'},
\	{'word': 'labeldistance=', 'menu': 'Scaling factor for distance for head or tail label [E]'},
\	{'word': 'labelfontcolor=','menu': 'Type face color for head and tail labels [E]'},
\	{'word': 'labelfontname=', 'menu': 'Font family for head and tail labels [E]'},
\	{'word': 'labelfontsize=', 'menu': 'Point size for head and tail labels [E]'},
\	{'word': 'labeljust=',     'menu': 'Label justficiation [G]'},
\	{'word': 'labelloc=',      'menu': 'Label vertical justficiation [G]'},
\	{'word': 'layer=',         'menu': 'Overlay range [E,N]'},
\	{'word': 'lhead=',         'menu': '子图名称,表示连接到该子图的边界 [E]'},
\	{'word': 'ltail=',         'menu': '子图名称,表示连接到该子图的边界 [E]'},
\	{'word': 'minlen=',        'menu': '[E]'},
\	{'word': 'nodesep=',       'menu': 'Separation between nodes, in inches [G]'},
\	{'word': 'orientation=',   'menu': '旋转角度 [N]'},
\	{'word': 'peripheries=',   'menu': '边界线的数量 [N]'},
\	{'word': 'rank=',          'menu': '[G]'},
\	{'word': 'rankdir=',       'menu': '[G]'},
\	{'word': 'ranksep=',       'menu': 'Separation between ranks, in inches [G]'},
\	{'word': 'ratio=',         'menu': '设置高宽比例 [G]'},
\	{'word': 'regular=',       'menu': '规则多边形 用于shape=polygon [N]'},
\	{'word': 'rotate=',        'menu': 'If 90, set orientation to landscape [G]'},
\	{'word': 'samehead=',      'menu': '[E]'},
\	{'word': 'sametail=',      'menu': '[E]'},
\	{'word': 'shape=',         'menu': '节点形状 [N]'},
\	{'word': 'shapefile=',     'menu': 'External custom shape file [N]'},
\	{'word': 'sides=',         'menu': '边的数量 用于shape=polygon [N]'},
\	{'word': 'skew=',          'menu': '倾斜角度-1~1 用于shape=polygon [N]'},
\	{'word': 'style=',         'menu': '线条特性 [E,N]'},
\	{'word': 'taillabel=',     'menu': '线尾位置上的标签文字 [E]'},
\	{'word': 'tailport=',      'menu': '[E]'},
\	{'word': 'weight=',        'menu': '线的宽度 [E]'},
\	{'word': 'width=',         'menu': '单位为英寸 [N]'}
\	]

let s:shapes = [
\	{'word': 'box',		 	'menu': '矩形'},
\	{'word': 'circle',	  	'menu': '圆形'},
\	{'word': 'diamond',		'menu': '菱形'},
\	{'word': 'doublecircle',	'menu': '圆形(双层边界)'},
\	{'word': 'doubleoctagon',	'menu': '六边形(双层边界)'},
\	{'word': 'egg',			'menu': '蛋形状'},
\	{'word': 'ellipse',		'menu': '椭圆'},
\	{'word': 'hexagon',		'menu': '六边形'},
\	{'word': 'house',		'menu': '房子(五边形)'},
\	{'word': 'invhouse',		'menu': '倒立的房子(五边形)'},
\	{'word': 'invtrapezium',	'menu': '倒立的梯形'},
\	{'word': 'invtriangle',		'menu': '倒三角'},
\	{'word': 'octagon',		'menu': '八角形'},
\	{'word': 'plaintext',		'menu': '无边框'},
\	{'word': 'parallelogram',	'menu': '倾斜的矩形'},
\	{'word': 'point',		'menu': '大黑点'},
\	{'word': 'polygon',		'menu': '多边形'},
\	{'word': 'record',		'menu': '用|分割,<name>为锚点,如rec1:f1,内嵌用{}'},
\	{'word': 'traingle',		'menu': '三角'},
\	{'word': 'trapezium',		'menu': '梯形'},
\	{'word': 'tripleoctagon',	'menu': '六边形(三层边界)'},
\	{'word': 'Mcircle',		'menu': '圆,圆内上下各有一横线'},
\	{'word': 'Mdiamon',		'menu': '菱形,4个角内各有横竖一线'},
\	{'word': 'Mrecord',		'menu': '如record,不过左右变上下'},
\	{'word': 'Msquare',		'menu': '矩形,4个角内各有一斜线'}
\	]

let s:arrowheads =  [
\	{'word': 'box',			'menu': '方形箭头'},
\	{'word': 'crow',		'menu': '箭尾形'},
\	{'word': 'diamond',		'menu': '菱形箭头'},
\	{'word': 'dot',			'menu': '圆箭头'},
\	{'word': 'inv',			'menu': '反向三角箭头'},
\	{'word': 'invdot'},
\	{'word': 'invodot'},
\	{'word': 'none'},
\	{'word': 'normal',		'menu': '三角箭头'},
\	{'word': 'obox',		'menu': '空心方形箭头'},
\	{'word': 'odiamond',		'menu': '空心菱形箭头'},
\	{'word': 'odot',		'menu': '空心圆箭头'},
\	{'word': 'onormal',		'menu': '空心三角箭头'},
\	{'word': 'vee',			'menu': '箭头形箭头'}
\	]

" More colornames are available but make the menu too long.
let s:colors =  [
\	{'word': '#000000'},
\	{'word': '0.0 0.0 0.0'},
\	{'word': 'beige',		'menu': '淡黄'},
\	{'word': 'black',		'menu': '黑色'},
\	{'word': 'blue',		'menu': '蓝色'},
\	{'word': 'brown',		'menu': '褐色'},
\	{'word': 'cyan',		'menu': '浅蓝'},
\	{'word': 'gray',		'menu': '灰色'},
\	{'word': 'gray[0-100]',		'menu': '灰度'},
\	{'word': 'green',		'menu': '绿色'},
\	{'word': 'magenta',		'menu': '紫色'},
\	{'word': 'orange',		'menu': '橘色'},
\	{'word': 'orchid',		'menu': '粉色'},
\	{'word': 'red',			'menu': '红色'},
\	{'word': 'violet',		'menu': '浅粉色'},
\	{'word': 'white',		'menu': '白色'},
\	{'word': 'yellow',		'menu': '黄色'}
\	]

let s:fonts =  [
\	{'abbr': 'Courier'          , 'word': '"Courier"'},
\	{'abbr': 'Courier-Bold'     , 'word': '"Courier-Bold"'},
\	{'abbr': 'Courier-Oblique'  , 'word': '"Courier-Oblique"'},
\	{'abbr': 'Helvetica'        , 'word': '"Helvetica"'},
\	{'abbr': 'Helvetica-Bold'   , 'word': '"Helvetica-Bold"'},
\	{'abbr': 'Helvetica-Narrow' , 'word': '"Helvetica-Narrow"'},
\	{'abbr': 'Helvetica-Oblique', 'word': '"Helvetica-Oblique"'},
\	{'abbr': 'Symbol'           , 'word': '"Symbol"'},
\	{'abbr': 'Times-Bold'       , 'word': '"Times-Bold"'},
\	{'abbr': 'Times-BoldItalic' , 'word': '"Times-BoldItalic"'},
\	{'abbr': 'Times-Italic'     , 'word': '"Times-Italic"'},
\	{'abbr': 'Times-Roman'      , 'word': '"Times-Roman"'}
\	]

let s:style =  [
\	{'word': 'bold',	'menu': '粗线条 [E,N]'},
\	{'word': 'dasheh',	'menu': '断线条 [E,N]'},
\	{'word': 'dotted',	'menu': '点线条 [E,N]'},
\	{'word': 'filled',	'menu': '填充 [N]'},
\	{'word': 'rounded',	'menu': '圆角 [N]'},
\	{'word': 'solid',	'menu': '一般线条 [E,N]'}
\	]

let s:dir =  [
\	{'word': 'forward'},
\	{'word': 'back'},
\	{'word': 'both'},
\	{'word': 'none'}
\	]

let s:port =  [
\	{'word': '_',   'menu': 'appropriate side or center (default)' },
\	{'word': 'c',   'menu': 'center'},
\	{'word': 'e'},
\	{'word': 'n'},
\	{'word': 'ne'},
\	{'word': 'nw'},
\	{'word': 's'},
\	{'word': 'se'},
\	{'word': 'sw'},
\	{'word': 'w'},
\	]

let s:rank =  [
\	{'word': 'same'},
\	{'word': 'min'},
\	{'word': 'max'},
\	{'word': 'source'},
\	{'word': 'sink'}
\	]

let s:rankdir =  [
\	{'word': 'BT'},
\	{'word': 'LR'},
\	{'word': 'RL'},
\	{'word': 'TB'},
\	]

let s:just =  [
\	{'word': 'centered'},
\	{'word': 'l'},
\	{'word': 'r'}
\	]

let s:loc =  [
\	{'word': 'b', 'menu': 'bottom'},
\	{'word': 'c', 'menu': 'center'},
\	{'word': 't', 'menu': 'top'},
\	]

let s:boolean =  [
\	{'word': 'true'},
\	{'word': 'false'}
\	]

fu! GraphvizComplete(findstart, base)
	"echomsg 'findstart='.a:findstart.', base='.a:base
	if a:findstart
		" return the starting point of the word
		let line = getline('.')
		let pos = col('.') - 1
		while pos > 0 && line[pos - 1] !~ '=\|,\|\[\|\s'
			let pos -= 1
		endwhile
		let withspacepos = pos
		if line[withspacepos - 1] =~ '\s'
			while withspacepos > 0 && line[withspacepos - 1] !~ '=\|,\|\['
				let withspacepos -= 1
			endwhile
		endif

		if line[withspacepos - 1] == '='
			" label=...?
			let labelpos = withspacepos - 1
			" ignore spaces
			while labelpos > 0 && line[labelpos - 1] =~ '\s'
				let labelpos -= 1
				let withspacepos -= 1
			endwhile
			while labelpos > 0 && line[labelpos - 1] =~ '[a-z]'
				let labelpos -= 1
			endwhile
			let labelstr=strpart(line, labelpos, withspacepos - 1 - labelpos)

			if labelstr == 'shape'
				let s:completion_type = 'shape'
			elseif labelstr =~ 'fontname'
				let s:completion_type = 'font'
			elseif labelstr =~ 'color'
				let s:completion_type = 'color'
			elseif labelstr == 'arrowhead'
				let s:completion_type = 'arrowhead'
			elseif labelstr == 'arrowtail'
				let s:completion_type = 'arrowhead'
			elseif labelstr == 'rank'
				let s:completion_type = 'rank'
			elseif labelstr == 'port'
				let s:completion_type = 'port'
			elseif labelstr == 'rankdir'
				let s:completion_type = 'rankdir'
			elseif labelstr == 'style'
				let s:completion_type = 'style'
			elseif labelstr == 'labeljust'
				let s:completion_type = 'just'
			elseif labelstr == 'fixedsize' || labelstr == 'regular' || labelstr == 'constraint' || labelstr == 'labelfloat' || labelstr == 'center' || labelstr == 'compound' || labelstr == 'concentrate'
				let s:completion_type = 'boolean'
			elseif labelstr == 'labelloc'
				let s:completion_type = 'loc'
			else
				let s:completion_type = ''
			endif
		elseif line[withspacepos - 1] =~ ',\|\['
			" attr
			let attrstr=line[0:withspacepos - 1]
			" skip spaces
			while line[withspacepos] =~ '\s'
				let withspacepos += 1
			endwhile

			if attrstr =~ '^\s*node'
				let s:completion_type = 'attrnode'
			elseif attrstr =~ '^\s*edge'
				let s:completion_type = 'attredge'
			elseif attrstr =~ '\( -> \)\|\( -- \)'
				let s:completion_type = 'attredge'
			elseif attrstr =~ '^\s*graph'
				let s:completion_type = 'attrgraph'
			else
				let s:completion_type = 'attrnode'
			endif
		else
			let s:completion_type = ''
		endif

		return pos
	else
		" return suggestions in an array
		let suggestions = []

		if s:completion_type == 'shape'
			for entry in s:shapes
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'arrowhead'
			for entry in s:arrowheads
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'boolean'
			for entry in s:boolean
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'font'
			for entry in s:fonts
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'color'
			for entry in s:colors
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rank'
			for entry in s:rank
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'rankdir'
			for entry in s:rankdir
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'style'
			for entry in s:style
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'port'
			for entry in s:port
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'just'
			for entry in s:just
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'loc'
			for entry in s:loc
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attr'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/')
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrnode'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*N.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attredge'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*E.*\]'
					call add(suggestions, entry)
				endif
			endfor
		elseif s:completion_type == 'attrgraph'
			for entry in s:attrs
				if entry.word =~ '^'.escape(a:base, '/') && entry.menu =~ '\[.*G.*\]'
					call add(suggestions, entry)
				endif
			endfor
		endif
		if !has('gui_running')
			redraw!
		endif
		return suggestions
	endif
endfu

setlocal omnifunc=GraphvizComplete

" Quickfix list

setlocal errorformat=%EError:\ %f:%l:%m,%+Ccontext:\ %.%#,%WWarning:\ %m

" Comments

set commentstring="// %s"


