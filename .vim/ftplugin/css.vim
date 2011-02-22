" Css file plugin for .css file
" <C-X><C-U> 补全 :CSSaddhtml 添加关联的html文件增加选择器补全
" Last Change: 2011-2-21
" Maintainer: sunsol
" License:	This file is placed in the public domain.


if exists("b:cssdid_ftplugin")
	finish
endif
let b:cssdid_ftplugin = 1

let s:other_values = {
\	"$bd-style":	[
\			{"word": "none"},
\			{"word": "hidden",	 "menu": "不显示"},
\			{"word": "dotted",	 "menu": "点线"},
\			{"word": "dashed",	 "menu": "断线"},
\			{"word": "solid",	 "menu": "单线"},
\			{"word": "double",	 "menu": "双线"},
\			{"word": "groove",	 "menu": "内雕"},
\			{"word": "ridge",	 "menu": "外雕"},
\			{"word": "inset",	 "menu": "凹线"},
\			{"word": "outset",	 "menu": "凸线"}],
\	"$bd-width":	[
\			{"word": "2px",	 "menu": "宽度"},
\			{"word": "thin",	 "menu": "1px"},
\			{"word": "medium",	 "menu": "3px"},
\			{"word": "thick",	 "menu": "5px"}],
\	"$color":	[
\			{"word": "transparent",	 "menu": "透明"},
\			{"word": "black",	 "menu": "黑"},
\			{"word": "blue",	 "menu": "蓝"},
\			{"word": "green",	 "menu": "绿"},
\			{"word": "lime",	 "menu": "浅绿"},
\			{"word": "cyan",	 "menu": "浅蓝"},
\			{"word": "maroon",	 "menu": "褐色"},
\			{"word": "purple",	 "menu": "紫"},
\			{"word": "olive",	 "menu": "橄榄色"},
\			{"word": "gray",	 "menu": "灰色"},
\			{"word": "silver",	 "menu": "银色"},
\			{"word": "violet",	 "menu": "紫罗兰色"},
\			{"word": "red",	 "menu": "红"},
\			{"word": "orange",	 "menu": "橘色"},
\			{"word": "pink",	 "menu": "粉红"},
\			{"word": "gold",	 "menu": "金黄"},
\			{"word": "yellow",	 "menu": "黄色"},
\			{"word": "white",	 "menu": "白色"},
\			{"word": "#xxxxxx"},
\			{"word": "rgb(0,255,0)"},
\			{"word": "rgba(255,0,0,0.x)"},
\			{"word": "hsl(360,5%,55%)"}],
\	"$background-position-first":	[
\			{"word": "left"},
\			{"word": "center"},
\			{"word": "right"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"$background-position-second":	[
\			{"word": "top"},
\			{"word": "center"},
\			{"word": "bottom"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"$number":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"font-family":	[
\			{"word": "serif",	 "menu": "一般用字"},
\			{"word": "sans-serif",	 "menu": "标题字"},
\			{"word": "cursive",	 "menu": "手写字"},
\			{"word": "fantasy",	 "menu": "艺术字"},
\			{"word": "monospace",	 "menu": "等宽字"},
\			{"word": "宋体",	 "menu": "指定字型"}],
\	"$dir4":	[
\			{"word": "1个参数",	 "menu": "四边"},
\			{"word": "2个参数",	 "menu": "上下和左右"},
\			{"word": "3个参数",	 "menu": "上和左右和下"},
\			{"word": "4个参数",	 "menu": "上右下左"}]}

"let s:font=["caption","icon","menu","message-box","small-caption","status-bar"]
let s:background = ["background-image", "background-repeat", "background-attachment", "$background-position-first", "$background-position-second", "background-color"]
let s:list_style = ["list-style-type", "list-style-position", "list-style-image"]
let s:properties_value_border = ['border-top', 'border', 'border-bottom', 'border-right', 'border-left', 'outline']
let s:properties_value_other = {'margin':'$number', 'padding':'$number', 'border-style':'$bd-style', 'border-color':'$color', 'border-width':'$bd-width'}

let s:properties_value = {
\	"border-top-left-radius":	[
\			{"word": '1/1',	"menu": "number/number"}],
\	"border-bottom-right-radius":	[
\			{"word": '1/1',	"menu": "number/number"}],
\	"border-bottom-left-radius":	[
\			{"word": '1/1',	"menu": "number/number"}],
\	"border-top-right-radius":	[
\			{"word": '1/1',	"menu": "number/number"}],
\	"nav-right":	[
\			{"word": "#id",	 "menu": "需切换的元素id"},
\			{"word": "root"},
\			{"word": "auto"}],
\	"list-style-image":	[
\			{"word": "url(xxpath)"},
\			{"word": "none"}],
\	"outline-width":	[
\			{"word": "2px",	 "menu": "宽度"},
\			{"word": "thin",	 "menu": "1px"},
\			{"word": "medium",	 "menu": "3px"},
\			{"word": "thick",	 "menu": "5px"}],
\	"word-wrap":	[
\			{"word": "normal"},
\			{"word": "break-word",	 "menu": "主用于中文"}],
\	"text-indent":	[
\			{"word": "1em",	 "menu": "1字宽"},
\			{"word": "11px"},
\			{"word": "39%",	 "menu": "缩进整个宽度的39%"}],
\	"border-spacing":	[
\			{"word": "1to4",	 "menu": "四边间距"},
\			{"word": "2to4",	 "menu": "水平和纵向"}],
\	"list-style-type":	[
\			{"word": "decimal",	 "menu": "1.2.3"},
\			{"word": "decimal-leading-zero",	 "menu": "01.02.03"},
\			{"word": "lower-roman",	 "menu": "i.ii.iii"},
\			{"word": "upper-roman",	 "menu": "I.II.III"},
\			{"word": "lower-greek",	 "menu": "α.β.γ"},
\			{"word": "lower-alpha",	 "menu": "a.b.c"},
\			{"word": "upper-alpha",	 "menu": "A.B.C"},
\			{"word": "cjk-ideographic",	 "menu": "一.二.三"},
\			{"word": "none"}],
\	"nav-left":	[
\			{"word": "#id",	 "menu": "需切换的元素id"},
\			{"word": "root"},
\			{"word": "auto"}],
\	"text-align":	[
\			{"word": "left",	 "menu": "居左"},
\			{"word": "center",	 "menu": "居中"},
\			{"word": "right",	 "menu": "居右"},
\			{"word": "justify",	 "menu": "左右对齐"},
\			{"word": "start",	 "menu": "同left"},
\			{"word": "end",	 "menu": "right"}],
\	"line-height":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"padding-left":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"font-size":	[
\			{"word": "xx-small"},
\			{"word": "x-small"},
\			{"word": "small"},
\			{"word": "medium"},
\			{"word": "large"},
\			{"word": "x-large"},
\			{"word": "xx-larger"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"right":	[
\			{"word": "auto"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"word-spacing":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"padding-top":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"border-top-width":	[
\			{"word": "2px",	 "menu": "宽度"},
\			{"word": "thin",	 "menu": "1px"},
\			{"word": "medium",	 "menu": "3px"},
\			{"word": "thick",	 "menu": "5px"}],
\	"bottom":	[
\			{"word": "auto"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"border-right-style":	[
\			{"word": "none"},
\			{"word": "hidden",	 "menu": "不显示"},
\			{"word": "dotted",	 "menu": "点线"},
\			{"word": "dashed",	 "menu": "断线"},
\			{"word": "solid",	 "menu": "单线"},
\			{"word": "double",	 "menu": "双线"},
\			{"word": "groove",	 "menu": "内雕"},
\			{"word": "ridge",	 "menu": "外雕"},
\			{"word": "inset",	 "menu": "凹线"},
\			{"word": "outset",	 "menu": "凸线"}],
\	"padding-right":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"border-left-style":	[
\			{"word": "none"},
\			{"word": "hidden",	 "menu": "不显示"},
\			{"word": "dotted",	 "menu": "点线"},
\			{"word": "dashed",	 "menu": "断线"},
\			{"word": "solid",	 "menu": "单线"},
\			{"word": "double",	 "menu": "双线"},
\			{"word": "groove",	 "menu": "内雕"},
\			{"word": "ridge",	 "menu": "外雕"},
\			{"word": "inset",	 "menu": "凹线"},
\			{"word": "outset",	 "menu": "凸线"}],
\	"background-color":	[
\			{"word": "transparent",	 "menu": "透明"},
\			{"word": "black",	 "menu": "黑"},
\			{"word": "blue",	 "menu": "蓝"},
\			{"word": "green",	 "menu": "绿"},
\			{"word": "lime",	 "menu": "浅绿"},
\			{"word": "cyan",	 "menu": "浅蓝"},
\			{"word": "maroon",	 "menu": "褐色"},
\			{"word": "purple",	 "menu": "紫"},
\			{"word": "olive",	 "menu": "橄榄色"},
\			{"word": "gray",	 "menu": "灰色"},
\			{"word": "silver",	 "menu": "银色"},
\			{"word": "violet",	 "menu": "紫罗兰色"},
\			{"word": "red",	 "menu": "红"},
\			{"word": "orange",	 "menu": "橘色"},
\			{"word": "pink",	 "menu": "粉红"},
\			{"word": "gold",	 "menu": "金黄"},
\			{"word": "yellow",	 "menu": "黄色"},
\			{"word": "white",	 "menu": "白色"},
\			{"word": "#xxxxxx"},
\			{"word": "rgb(0,255,0)"},
\			{"word": "rgba(255,0,0,0.x)"},
\			{"word": "hsl(360,5%,55%)"}],
\	"border-bottom-color":	[
\			{"word": "transparent",	 "menu": "透明"},
\			{"word": "black",	 "menu": "黑"},
\			{"word": "blue",	 "menu": "蓝"},
\			{"word": "green",	 "menu": "绿"},
\			{"word": "lime",	 "menu": "浅绿"},
\			{"word": "cyan",	 "menu": "浅蓝"},
\			{"word": "maroon",	 "menu": "褐色"},
\			{"word": "purple",	 "menu": "紫"},
\			{"word": "olive",	 "menu": "橄榄色"},
\			{"word": "gray",	 "menu": "灰色"},
\			{"word": "silver",	 "menu": "银色"},
\			{"word": "violet",	 "menu": "紫罗兰色"},
\			{"word": "red",	 "menu": "红"},
\			{"word": "orange",	 "menu": "橘色"},
\			{"word": "pink",	 "menu": "粉红"},
\			{"word": "gold",	 "menu": "金黄"},
\			{"word": "yellow",	 "menu": "黄色"},
\			{"word": "white",	 "menu": "白色"},
\			{"word": "#xxxxxx"},
\			{"word": "rgb(0,255,0)"},
\			{"word": "rgba(255,0,0,0.x)"},
\			{"word": "hsl(360,5%,55%)"}],
\	"outline-color":	[
\			{"word": "invert",	 "menu": "反色"},
\			{"word": "transparent",	 "menu": "透明"},
\			{"word": "black",	 "menu": "黑"},
\			{"word": "blue",	 "menu": "蓝"},
\			{"word": "green",	 "menu": "绿"},
\			{"word": "lime",	 "menu": "浅绿"},
\			{"word": "cyan",	 "menu": "浅蓝"},
\			{"word": "maroon",	 "menu": "褐色"},
\			{"word": "purple",	 "menu": "紫"},
\			{"word": "olive",	 "menu": "橄榄色"},
\			{"word": "gray",	 "menu": "灰色"},
\			{"word": "silver",	 "menu": "银色"},
\			{"word": "violet",	 "menu": "紫罗兰色"},
\			{"word": "red",	 "menu": "红"},
\			{"word": "orange",	 "menu": "橘色"},
\			{"word": "pink",	 "menu": "粉红"},
\			{"word": "gold",	 "menu": "金黄"},
\			{"word": "yellow",	 "menu": "黄色"},
\			{"word": "white",	 "menu": "白色"},
\			{"word": "#xxxxxx"},
\			{"word": "rgb(0,255,0)"},
\			{"word": "rgba(255,0,0,0.x)"},
\			{"word": "hsl(360,5%,55%)"}],
\	"caption-side":	[
\			{"word": "top"},
\			{"word": "bottom"},
\			{"word": "left"},
\			{"word": "right"}],
\	"text-transform":	[
\			{"word": "none"},
\			{"word": "capitalize",	 "menu": "首字大写"},
\			{"word": "uppercase",	 "menu": "大写"},
\			{"word": "lowercase",	 "menu": "小写"}],
\	"border-right-width":	[
\			{"word": "2px",	 "menu": "宽度"},
\			{"word": "thin",	 "menu": "1px"},
\			{"word": "medium",	 "menu": "3px"},
\			{"word": "thick",	 "menu": "5px"}],
\	"border-top-style":	[
\			{"word": "none"},
\			{"word": "hidden",	 "menu": "不显示"},
\			{"word": "dotted",	 "menu": "点线"},
\			{"word": "dashed",	 "menu": "断线"},
\			{"word": "solid",	 "menu": "单线"},
\			{"word": "double",	 "menu": "双线"},
\			{"word": "groove",	 "menu": "内雕"},
\			{"word": "ridge",	 "menu": "外雕"},
\			{"word": "inset",	 "menu": "凹线"},
\			{"word": "outset",	 "menu": "凸线"}],
\	"border-collapse":	[
\			{"word": "separate",	 "menu": "双边框"},
\			{"word": "collapse",	 "menu": "单边框"}],
\	"border-bottom-width":	[
\			{"word": "2px",	 "menu": "宽度"},
\			{"word": "thin",	 "menu": "1px"},
\			{"word": "medium",	 "menu": "3px"},
\			{"word": "thick",	 "menu": "5px"}],
\	"float":	[
\			{"word": "none"},
\			{"word": "left"},
\			{"word": "right"}],
\	"height":	[
\			{"word": "auto"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"margin-right":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"outline-style":	[
\			{"word": "none"},
\			{"word": "hidden",	 "menu": "不显示"},
\			{"word": "dotted",	 "menu": "点线"},
\			{"word": "dashed",	 "menu": "断线"},
\			{"word": "solid",	 "menu": "单线"},
\			{"word": "double",	 "menu": "双线"},
\			{"word": "groove",	 "menu": "内雕"},
\			{"word": "ridge",	 "menu": "外雕"},
\			{"word": "inset",	 "menu": "凹线"},
\			{"word": "outset",	 "menu": "凸线"}],
\	"top":	[
\			{"word": "auto"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"width":	[
\			{"word": "auto"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"border-top-color":	[
\			{"word": "transparent",	 "menu": "透明"},
\			{"word": "black",	 "menu": "黑"},
\			{"word": "blue",	 "menu": "蓝"},
\			{"word": "green",	 "menu": "绿"},
\			{"word": "lime",	 "menu": "浅绿"},
\			{"word": "cyan",	 "menu": "浅蓝"},
\			{"word": "maroon",	 "menu": "褐色"},
\			{"word": "purple",	 "menu": "紫"},
\			{"word": "olive",	 "menu": "橄榄色"},
\			{"word": "gray",	 "menu": "灰色"},
\			{"word": "silver",	 "menu": "银色"},
\			{"word": "violet",	 "menu": "紫罗兰色"},
\			{"word": "red",	 "menu": "红"},
\			{"word": "orange",	 "menu": "橘色"},
\			{"word": "pink",	 "menu": "粉红"},
\			{"word": "gold",	 "menu": "金黄"},
\			{"word": "yellow",	 "menu": "黄色"},
\			{"word": "white",	 "menu": "白色"},
\			{"word": "#xxxxxx"},
\			{"word": "rgb(0,255,0)"},
\			{"word": "rgba(255,0,0,0.x)"},
\			{"word": "hsl(360,5%,55%)"}],
\	"empty-cells":	[
\			{"word": "hide"},
\			{"word": "show"}],
\	"direction":	[
\			{"word": "ltr"},
\			{"word": "rtl"}],
\	"visibility":	[
\			{"word": "visible"},
\			{"word": "hidden"},
\			{"word": "collapse",	 "menu": "用于table"}],
\	"background-attachment":	[
\			{"word": "fixed",	 "menu": "固定"},
\			{"word": "scroll",	 "menu": "不固定"}],
\	"overflow":	[
\			{"word": "visible",	 "menu": "溢出显示"},
\			{"word": "hidden",	 "menu": "多出的不显示"},
\			{"word": "scroll",	 "menu": "显示滚动条"},
\			{"word": "auto"}],
\	"border-bottom-style":	[
\			{"word": "none"},
\			{"word": "hidden",	 "menu": "不显示"},
\			{"word": "dotted",	 "menu": "点线"},
\			{"word": "dashed",	 "menu": "断线"},
\			{"word": "solid",	 "menu": "单线"},
\			{"word": "double",	 "menu": "双线"},
\			{"word": "groove",	 "menu": "内雕"},
\			{"word": "ridge",	 "menu": "外雕"},
\			{"word": "inset",	 "menu": "凹线"},
\			{"word": "outset",	 "menu": "凸线"}],
\	"cursor":	[
\			{"word": "auto"},
\			{"word": "url(xxpath)"},
\			{"word": "none"},
\			{"word": "default"},
\			{"word": "help",	 "menu": "?号"},
\			{"word": "pointer",	 "menu": "手"},
\			{"word": "progress",	 "menu": "漏斗指针"},
\			{"word": "wait",	 "menu": "漏斗"},
\			{"word": "cell",	 "menu": "红十字"},
\			{"word": "crosshair",	 "menu": "十字线"},
\			{"word": "text",	 "menu": "光标"},
\			{"word": "vertical-text",	 "menu": "平放光标"},
\			{"word": "alias",	 "menu": "快捷键"},
\			{"word": "copy",	 "menu": "复制"},
\			{"word": "move",	 "menu": "移动十字"},
\			{"word": "no-drop",	 "menu": "打叉的手"},
\			{"word": "not-allowed",	 "menu": "打叉"},
\			{"word": "all-scroll",	 "menu": "4向滚动"},
\			{"word": "col-resize",	 "menu": "左右移动"},
\			{"word": "row-resize",	 "menu": "上下移动"},
\			{"word": "n-resize",	 "menu": "上箭头"},
\			{"word": "e-resize",	 "menu": "右箭头"},
\			{"word": "s-resize",	 "menu": "下箭头"},
\			{"word": "w-resize",	 "menu": "左箭头"},
\			{"word": "nw-resize",	 "menu": "左上箭头"},
\			{"word": "se-resize",	 "menu": "右下箭头"},
\			{"word": "ne-resize",	 "menu": "右上箭头"},
\			{"word": "sw-resize",	 "menu": "左下箭头"}],
\	"display":	[
\			{"word": "none"},
\			{"word": "inline",	 "menu": "行模式"},
\			{"word": "block",	 "menu": "块模式"},
\			{"word": "list-item"},
\			{"word": "table"},
\			{"word": "table-caption"},
\			{"word": "table-column"},
\			{"word": "table-row"},
\			{"word": "table-cell"}],
\	"border-left-width":	[
\			{"word": "2px",	 "menu": "宽度"},
\			{"word": "thin",	 "menu": "1px"},
\			{"word": "medium",	 "menu": "3px"},
\			{"word": "thick",	 "menu": "5px"}],
\	"letter-spacing":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"vertical-align":	[
\			{"word": "top",	 "menu": "顶"},
\			{"word": "middle",	 "menu": "中"},
\			{"word": "bottom",	 "menu": "底"},
\			{"word": "sub"},
\			{"word": "super"},
\			{"word": "text-top"},
\			{"word": "text-bottom"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"clip":	[
\			{"word": "auto"},
\			{"word": "rect(top,right,bottom,left)",	 "menu": "部分显示"}],
\	"padding-bottom":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"nav-down":	[
\			{"word": "#id",	 "menu": "需切换的元素id"},
\			{"word": "root"},
\			{"word": "auto"}],
\	"margin-left":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"font-style":	[
\			{"word": "normal"},
\			{"word": "italic",	 "menu": "斜体"},
\			{"word": "oblique"}],
\	"border-left-color":	[
\			{"word": "transparent",	 "menu": "透明"},
\			{"word": "black",	 "menu": "黑"},
\			{"word": "blue",	 "menu": "蓝"},
\			{"word": "green",	 "menu": "绿"},
\			{"word": "lime",	 "menu": "浅绿"},
\			{"word": "cyan",	 "menu": "浅蓝"},
\			{"word": "maroon",	 "menu": "褐色"},
\			{"word": "purple",	 "menu": "紫"},
\			{"word": "olive",	 "menu": "橄榄色"},
\			{"word": "gray",	 "menu": "灰色"},
\			{"word": "silver",	 "menu": "银色"},
\			{"word": "violet",	 "menu": "紫罗兰色"},
\			{"word": "red",	 "menu": "红"},
\			{"word": "orange",	 "menu": "橘色"},
\			{"word": "pink",	 "menu": "粉红"},
\			{"word": "gold",	 "menu": "金黄"},
\			{"word": "yellow",	 "menu": "黄色"},
\			{"word": "white",	 "menu": "白色"},
\			{"word": "#xxxxxx"},
\			{"word": "rgb(0,255,0)"},
\			{"word": "rgba(255,0,0,0.x)"},
\			{"word": "hsl(360,5%,55%)"}],
\	"overflow-y":	[
\			{"word": "visible",	 "menu": "溢出显示"},
\			{"word": "hidden",	 "menu": "多出的不显示"},
\			{"word": "scroll",	 "menu": "显示滚动条"},
\			{"word": "auto"}],
\	"overflow-x":	[
\			{"word": "visible",	 "menu": "溢出显示"},
\			{"word": "hidden",	 "menu": "多出的不显示"},
\			{"word": "scroll",	 "menu": "显示滚动条"},
\			{"word": "auto"}],
\	"background-repeat":	[
\			{"word": "repeat",	 "menu": "平铺"},
\			{"word": "repeat-x",	 "menu": "横向平铺"},
\			{"word": "repeat-y",	 "menu": "纵向平铺"},
\			{"word": "no-repeat",	 "menu": "不平铺"}],
\	"margin-bottom":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	 "menu": "100%"}],
\	"nav-up":	[
\			{"word": "#id",	 "menu": "需切换的元素id"},
\			{"word": "root"},
\			{"word": "auto"}],
\	"font-weight":	[
\			{"word": "normal",	 "menu": "400"},
\			{"word": "bold",	 "menu": "700"},
\			{"word": "100",	 "menu": "最细"},
\			{"word": "200"},
\			{"word": "300"},
\			{"word": "400"},
\			{"word": "500"},
\			{"word": "600"},
\			{"word": "700"},
\			{"word": "800"},
\			{"word": "900",	 "menu": "最粗"}],
\	"opacity":	[
\			{"word": "0.x"}],
\	"border-right-color":	[
\			{"word": "transparent",	 "menu": "透明"},
\			{"word": "black",	 "menu": "黑"},
\			{"word": "blue",	 "menu": "蓝"},
\			{"word": "green",	 "menu": "绿"},
\			{"word": "lime",	 "menu": "浅绿"},
\			{"word": "cyan",	 "menu": "浅蓝"},
\			{"word": "maroon",	 "menu": "褐色"},
\			{"word": "purple",	 "menu": "紫"},
\			{"word": "olive",	 "menu": "橄榄色"},
\			{"word": "gray",	 "menu": "灰色"},
\			{"word": "silver",	 "menu": "银色"},
\			{"word": "violet",	 "menu": "紫罗兰色"},
\			{"word": "red",	 "menu": "红"},
\			{"word": "orange",	 "menu": "橘色"},
\			{"word": "pink",	 "menu": "粉红"},
\			{"word": "gold",	 "menu": "金黄"},
\			{"word": "yellow",	 "menu": "黄色"},
\			{"word": "white",	 "menu": "白色"},
\			{"word": "#xxxxxx"},
\			{"word": "rgb(0,255,0)"},
\			{"word": "rgba(255,0,0,0.x)"},
\			{"word": "hsl(360,5%,55%)"}],
\	"white-space":	[
\			{"word": "normal",	 "menu": "去除所有空白并折行"},
\			{"word": "pre",	 "menu": "保持原样"},
\			{"word": "nowrap",	 "menu": "去除空白不折行"},
\			{"word": "pre-wrap",	 "menu": "保留所有空白并折行"},
\			{"word": "pre-line",	 "menu": "去除空格保留换行并折行"}],
\	"nav-index":	[
\			{"word": "xx",	 "menu": "tab遍历索引数"}],
\	"background-image":	[
\			{"word": "url(xxpath)"}],
\	"clear":	[
\			{"word": "none"},
\			{"word": "left"},
\			{"word": "right"},
\			{"word": "both"}],
\	"z-index":	[
\			{"word": "xxx"}],
\	"text-decoration":	[
\			{"word": "none",	 "menu": "无"},
\			{"word": "underline",	 "menu": "下划线"},
\			{"word": "overline", 	 "menu": "中划线"},
\			{"word": "line-through", "menu": "上划线"},
\			{"word": "blink",	 "menu": "闪烁"}],
\	"margin-top":	[
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",	         "menu": "100%"}],
\	"position":	[
\			{"word": "static",	 "menu": "top等无用"},
\			{"word": "relative",	 "menu": "相对于前一元素"},
\			{"word": "absolute",	 "menu": "相对于父元素"},
\			{"word": "fixed",	 "menu": "固定"}],
\	"list-style-position":	[
\			{"word": "inside",	 "menu": "内"},
\			{"word": "outside",	 "menu": "外"}],
\	"left":	[
\			{"word": "auto"},
\			{"word": "150%"},
\			{"word": "16px",	 "menu": "像素"},
\			{"word": "1em",		 "menu": "100%"}]
\	}

let s:properties = [
\	{"word": "font",	 "menu": "字体"},
\	{"word": "font-style",	 "menu": "字体样式"},
\	{"word": "font-weight",	 "menu": "字体粗细"},
\	{"word": "font-size",	 "menu": "字体大小"},
\	{"word": "line-height",	 "menu": "一行的高度"},
\	{"word": "font-family",	 "menu": "字型"},
\	{"word": "letter-spacing",	 "menu": "单字间距"},
\	{"word": "word-spacing",	 "menu": "词间距"},
\	{"word": "word-wrap",	 "menu": "换行是否断词"},
\	{"word": "text-indent",	 "menu": "缩进"},
\	{"word": "text-decoration",	 "menu": "文字装饰"},
\	{"word": "text-transform",	 "menu": "大小写"},
\	{"word": "direction",	 "menu": "文字方向"},
\	{"word": "text-align",	 "menu": "对齐,用于<div>"},
\	{"word": "white-space",	 "menu": "空白处理"},
\	{"word": "outline-style",	 "menu": "文字外包线外观"},
\	{"word": "outline-width",	 "menu": "文字外包线宽度"},
\	{"word": "outline-color",	 "menu": "文字外包线颜色"},
\	{"word": "outline",	 "menu": "文字外包线"},
\	{"word": "content",	 "menu": "只用于:before和:after",	 "info": "只用于:before和:after"},
\	{"word": "list-style-type",	 "menu": "标签样式,用于<ul><li>",	 "info": "标签样式,用于<ul><li>"},
\	{"word": "list-style-position",	 "menu": "标签位置,用于<ol><ul><li>",	 "info": "标签位置,用于<ol><ul><li>"},
\	{"word": "list-style-image",	 "menu": "标签图标,用于<ol><ul><li>",	 "info": "标签图标,用于<ol><ul><li>"},
\	{"word": "list-style",	 "menu": "标签,用于<ol><ul><li>",	 "info": "标签,用于<ol><ul><li>"},
\	{"word": "background",	 "menu": "背景"},
\	{"word": "background-image",	 "menu": "背景图片"},
\	{"word": "background-repeat",	 "menu": "平铺方式"},
\	{"word": "background-attachment",	 "menu": "固定方式"},
\	{"word": "background-color",	 "menu": "背景色"},
\	{"word": "background-position",	 "menu": "背景图位置"},
\	{"word": "opacity",	 "menu": "透明度"},
\	{"word": "padding",	 "menu": "盒内边距"},
\	{"word": "padding-left",	 "menu": "盒内左边距"},
\	{"word": "padding-top",	 "menu": "盒内上边距"},
\	{"word": "padding-right",	 "menu": "盒内右边距"},
\	{"word": "padding-bottom",	 "menu": "盒内下边距"},
\	{"word": "margin",	 "menu": "盒外边距"},
\	{"word": "margin-left",	 "menu": "盒外左边距"},
\	{"word": "margin-top",	 "menu": "盒外上边距"},
\	{"word": "margin-right",	 "menu": "盒外右边距"},
\	{"word": "margin-bottom",	 "menu": "盒外下边距"},
\	{"word": "border-color",	 "menu": "边线颜色"},
\	{"word": "border-top-color",	 "menu": "上边线颜色"},
\	{"word": "border-left-color",	 "menu": "左边线颜色"},
\	{"word": "border-right-color",	 "menu": "右边线颜色"},
\	{"word": "border-bottom-color",	 "menu": "下边线颜色"},
\	{"word": "border-style",	 "menu": "边线外观"},
\	{"word": "border-top-style",	 "menu": "上边线外观"},
\	{"word": "border-right-style",	 "menu": "右边线外观"},
\	{"word": "border-left-style",	 "menu": "左边线外观"},
\	{"word": "border-bottom-style",	 "menu": "下边线外观"},
\	{"word": "border-width",	 "menu": "边线宽度"},
\	{"word": "border-top-width",	 "menu": "上边线宽度"},
\	{"word": "border-left-width",	 "menu": "左边线宽度"},
\	{"word": "border-right-width",	 "menu": "右边线宽度"},
\	{"word": "border-bottom-width",	 "menu": "下边线宽度"},
\	{"word": "border",	 "menu": "基本边线"},
\	{"word": "border-top",	 "menu": "上边线"},
\	{"word": "border-left",	 "menu": "左边线"},
\	{"word": "border-right",	 "menu": "右边线"},
\	{"word": "border-bottom",	 "menu": "下边线"},
\	{"word": "border-radius",	 "menu": "角弧度"},
\	{"word": "border-top-left-radius",	 "menu": "左上角"},
\	{"word": "border-top-right-radius",	 "menu": "右上角"},
\	{"word": "border-bottom-left-radius",	 "menu": "左下角"},
\	{"word": "border-bottom-right-radius",	 "menu": "右下角"},
\	{"word": "border-collapse",	 "menu": "表边形式,用于<table><th><tr>",	 "info": "表边形式,用于<table><th><tr>"},
\	{"word": "border-spacing",	 "menu": "表边间距,用于<table><th><tr>",	 "info": "表边间距,用于<table><th><tr>"},
\	{"word": "caption-side",	 "menu": "标题位置,用于<table><caption>",	 "info": "标题位置,用于<table><caption>"},
\	{"word": "vertical-align",	 "menu": "上下对齐,用于<span><th><td>",	 "info": "上下对齐,用于<span><th><td>"},
\	{"word": "empty-cells",	 "menu": "清除格子的背景和边,用于<th><td>",	 "info": "清除格子的背景和边,用于<th><td>"},
\	{"word": "position",	 "menu": "定位"},
\	{"word": "top",	 "menu": "position不能为静态",	 "info": "position不能为静态"},
\	{"word": "left",	 "menu": "position不能为静态",	 "info": "position不能为静态"},
\	{"word": "right",	 "menu": "position不能为静态",	 "info": "position不能为静态"},
\	{"word": "bottom",	 "menu": "position不能为静态",	 "info": "position不能为静态"},
\	{"word": "width",	 "menu": "应用于块状元素"},
\	{"word": "height",	 "menu": "应用于块状元素"},
\	{"word": "float",	 "menu": "浮动位置"},
\	{"word": "clear",	 "menu": "清除浮动"},
\	{"word": "visibility",	 "menu": "是否显示"},
\	{"word": "display",	 "menu": "呈现状态"},
\	{"word": "z-index",	 "menu": "数字高的置前"},
\	{"word": "clip",	 "menu": "position为absolute可用",	 "info": "position为absolute可用"},
\	{"word": "overflow",	 "menu": "是否有滚动条"},
\	{"word": "overflow-x",	 "menu": "是否有滚动条"},
\	{"word": "overflow-y",	 "menu": "是否有滚动条"},
\	{"word": "nav-index",	 "menu": "tab遍历定位"},
\	{"word": "nav-right",	 "menu": "按右的目标"},
\	{"word": "nav-up",	 "menu": "按上的目标"},
\	{"word": "nav-down",	 "menu": "按下的目标"},
\	{"word": "nav-left",	 "menu": "按左的目标"},
\	{"word": "cursor",	 "menu": "鼠标图示"}]

let s:pesudos = [
\	{"word": "first-letter",	 "menu": "首字符"},
\	{"word": "first-line",	 "menu": "首行"},
\	{"word": "before",	 "menu": "前置文字"},
\	{"word": "after",	 "menu": "后置文字"},
\	{"word": ":selection",	 "menu": "选择文字使用的颜色"},
\	{"word": "link",	 "menu": "只对<a>有效"},
\	{"word": "visited",	 "menu": "只对<a>有效"},
\	{"word": "hover",	 "menu": "滑过时效果 只对<a>有效",	 "info": "滑过时效果 只对<a>有效"},
\	{"word": "focus",	 "menu": "获得焦点时"},
\	{"word": "empty",	 "menu": "空span时效果 常配合after使用",	 "info": "空span时效果 常配合after使用"},
\	{"word": "target",	 "menu": "当url地址的#id为目标时",	 "info": "当url地址的#id为目标时"},
\	{"word": "enabled",	 "menu": "用于表单里可用状态"},
\	{"word": "disabled",	 "menu": "用于表单里不可用状态"},
\	{"word": "checked",	 "menu": "用于表单里选中的元素"},
\	{"word": "first-child",	 "menu": "只建议用于<li>"},
\	{"word": "last-child",	 "menu": "只建议用于<li>"},
\	{"word": "ntp-child(odd,even,3n+1)",	 "menu": "建议用于<tr><td><li> odd奇数",	 "info": "建议用于<tr><td><li>,odd奇数"},
\	{"word": "ntp-of-type(odd,even,3n+1)",	 "menu": "同级兄弟元素 odd奇数"},
\	{"word": "ntp-last-child(xx)",	 "menu": "建议用于<tr><td><li> 倒数第xx个",	 "info": "建议用于<tr><td><li> 倒数第xx个"},
\	{"word": "ntp-last-of-type(xx)",	 "menu": "同级兄弟元素 倒数第xx个",	 "info": "同级兄弟元素 倒数第xx个"},
\	{"word": "first-of-type",	 "menu": "同级兄弟元素的第一个"},
\	{"word": "last-of-type",	 "menu": "同级兄弟元素的最后一个"},
\	{"word": "only-child",	 "menu": "父元素里只包含这一个的"},
\	{"word": "only-of-type",	 "menu": "该类元素全局只有一个时"}]

function! s:Normal_values_complete(partstr) 
	let output = []
	for name in b:complete_suggest.suggest
		if name.word =~ '^' . a:partstr
			call add(output, name)
		endif
	endfor
	if empty(output)
		for x in b:complete_suggest.suggest
			call add(output, x)
		endfor
	endif
	return output
endfun

function! s:Dir4_values_complete(partstr)
	return b:complete_suggest.suggest
endfun

function! s:Dir4_values(dir, name) 
	let output = []
	for i in range(a:dir,3)
		call add(output, s:other_values['$dir4'][i])
	endfor
	for x in s:other_values[a:name]
		call add(output, x)
	endfor
	return output
endfun

function! s:Is_dir4(s,name)
	let values = split(a:s, '\s\+')
	if empty(values)
		let pos = col('.')
		let b:complete_suggest = {'suggest': s:Dir4_values(0, s:properties_value_other[a:name]), 'complete': function('s:Dir4_values_complete')}
		return pos
	else
		let endspace = a:s =~ '\s$'
		let l = len(values)
		if endspace
			let pos = col('.')
		else
			let pos =  col('.') - strlen(values[-1])
			if pos < 1
				return 0
			endif
			let l = l - 1
		endif
		if l < 4
			let b:complete_suggest = {'suggest': s:Dir4_values(l, s:properties_value_other[a:name]), 'complete': function('s:Dir4_values_complete')}
		else
			return 0
		endif
		return pos
	endif
endfun

function! s:Is_border(s, name)
	let values = split(a:s, '\s\+')
	if empty(values)
		let pos = col('.')
		let b:complete_suggest = {'suggest': s:other_values['$bd-width'] + s:other_values['$bd-style'] + s:other_values['$color'], 'complete': function('s:Normal_values_complete')}
		return pos
	else
		let endspace = a:s =~ '\s$'
		if endspace
			let pos = col('.')
		else
			let pos =  col('.') - strlen(values[-1])
			if pos < 1
				return 0
			endif
		endif
		let l = len(values)
		if (l > 3) || ( (l == 3) && endspace )
			return 0
		endif
		if (l == 1) && !endspace
			let b:complete_suggest = {'suggest': s:other_values['$bd-width'] + s:other_values['$bd-style'] + s:other_values['$color'], 'complete': function('s:Normal_values_complete')}
		elseif ((l == 2) && !endspace) || ((l == 1) && endspace)
			let b:complete_suggest = {'suggest': s:other_values['$bd-style'] + s:other_values['$color'], 'complete': function('s:Normal_values_complete')}
		elseif ((l == 3) && !endspace) || ((l == 2) && endspace)
			let b:complete_suggest = {'suggest': s:other_values['$color'], 'complete': function('s:Normal_values_complete')}
		endif
		return pos
	endif
endfun

function! s:Do_background_pos(s)
	let values = split(a:s, '\s\+')
	if empty(values)
		let pos = col('.')
		let b:complete_suggest = {'suggest': s:other_values['$background-position-first'], 'complete': function('s:Normal_values_complete')}
		return pos
	else
		let endspace = a:s =~ '\s$'
		if endspace
			let pos = col('.')
		else
			let pos =  col('.') - strlen(values[-1])
			if pos < 1
				return 0
			endif
		endif
		let l = len(values)
		if (l > 2) || ( (l == 2) && endspace )
			return 0
		endif
		if (l == 1) && !endspace
			let b:complete_suggest = {'suggest': s:other_values['$background-position-first'], 'complete': function('s:Normal_values_complete')}
		else
			let b:complete_suggest = {'suggest': s:other_values['$background-position-second'], 'complete': function('s:Normal_values_complete')}
		endif
		return pos
	endif
endfun

function! s:Do_liststyle(s)
	let values = split(a:s, '\s\+')
	if empty(values)
		let pos = col('.')
		let b:complete_suggest = {'suggest': s:properties_value[s:list_style[0]], 'complete': function('s:Normal_values_complete')}
		return pos
	else
		let endspace = a:s =~ '\s$'
		let l = len(values)
		if endspace
			let pos = col('.')
		else
			let pos =  col('.') - strlen(values[-1])
			if pos < 1
				return 0
			endif
			let l = l - 1
		endif
		if l < len(s:list_style) 
			let b:complete_suggest = {'suggest': s:properties_value[s:list_style[l]], 'complete': function('s:Normal_values_complete')}
			return pos
		else
			return 0
		endif
	endif
endfun

function! s:Do_background(s)
	let values = split(a:s, '\s\+')
	if empty(values)
		let pos = col('.')
		let b:complete_suggest = {'suggest': s:properties_value[s:background[0]], 'complete': function('s:Normal_values_complete')}
		return pos
	else
		let endspace = a:s =~ '\s$'
		let l = len(values)
		if endspace
			let pos = col('.')
		else
			let pos =  col('.') - strlen(values[-1])
			if pos < 1
				return 0
			endif
			let l = l - 1
		endif
		if l < len(s:background) 
			if s:background[l] =~ '\$'
				let b:complete_suggest = {'suggest': s:other_values[s:background[l]], 'complete': function('s:Normal_values_complete')}
			else
				let b:complete_suggest = {'suggest': s:properties_value[s:background[l]], 'complete': function('s:Normal_values_complete')}
			endif
			return pos
		else
			return 0
		endif
	endif
endfun

function! s:Do_border_radius(s)
	let values = split(s, '/')
	if len(values) > 2 
		return 0
	endif
	if empty(values)
		let pos = col('.')
		let b:complete_suggest = {'suggest': [{'word':'格式', 'menu':'number/number'}], 'complete': function('s:Dir4_values_complete')}
		return pos
	else
		return s:Is_dir4(values[-1], 'padding')
	endif
endfun

function! s:Do_font_family(s)
	if a:s == ''
		let pos = col('.')
	else 
		let pos = strridx(a:s, ',')
		if pos < 0
			let pos = col('.') - strlen(a:s)
		else
			let pos = col('.') - strlen(a:s) + pos + 1
		endif
		if pos < 1
			return 0
		endif
	endif
	let b:complete_suggest = {'suggest': s:other_values['font-family'], 'complete': function('s:Normal_values_complete')}
	return pos
endfun

function! s:In_values_is(s)
	let matchpart = matchlist(a:s, '\([a-zA-Z][a-zA-Z-]\+\)\s*:\s*\([^:}{;]*\)$')
	if ! empty(matchpart)
		let propertyname = tolower(matchpart[1])
		if has_key(s:properties_value, propertyname)
			let pos =  col('.') - strlen(matchpart[2])
			if pos < 1
				return 0
			endif
			let b:complete_suggest = {'suggest': s:properties_value[propertyname], 'complete': function('s:Normal_values_complete')}
			return pos
		elseif has_key(s:properties_value_other,propertyname)
			return s:Is_dir4(matchpart[2], propertyname)
		elseif index(s:properties_value_border, propertyname) > -1
			return s:Is_border(matchpart[2], propertyname)
		elseif propertyname == 'background-position'
			return s:Do_background_pos(matchpart[2])
		elseif propertyname == 'border-radius'
			return s:Do_border_radius(matchpart[2])
		elseif propertyname == 'font-family'
			return s:Do_font_family(matchpart[2])
		elseif propertyname == 'background'
			return s:Do_background(matchpart[2])
		elseif propertyname == 'list-style'
			return s:Do_liststyle(matchpart[2])
		endif
	endif
	return 0
endfun



function! s:In_properties_is(s)
	let matchpart = matchlist(a:s, '{\([^}{]*;\|\)\s*\(\w*\)$')
	if ! empty(matchpart)
		let pos =  col('.') - strlen(matchpart[2])
		if pos < 1
			return 0
		endif
		let b:complete_suggest = {'suggest': s:properties, 'complete': function('s:Normal_values_complete')}
		return pos
	endif
	return 0
endfun

function! s:In_pseudos_is(s)
	let matchpart = matchlist(a:s, '\(}\|^\)[^{}]\{-}\w\+:\(\w*\)$')
	if ! empty(matchpart)
		let pos =  col('.') - strlen(matchpart[2])
		if pos < 1
			return 0
		endif
		let b:complete_suggest = {'suggest': s:pesudos, 'complete': function('s:Normal_values_complete')}
		return pos
	endif
	return 0
endfun

function! s:Py_htmltag()
python << EOF
import re
class Myset(set):
    def add(self,item):
        if item:
            super(Myset,self).add(item)
    def __repr__(self):
        a=list(self)
	a.sort()
	return repr(a)
class Mydict(dict):
    def add(self,item,value):
        if value:
            if not self.has_key(item):
                self[item]=Myset()
            self[item].add(value)
    def union(self,other):
        for key in other:
            for x in other[key]:
                self.add(key,x)

class G(object):
    def __init__(self):
        self.tags=Mydict()
        self.idtags=Myset()
        self.idhtmltags=Mydict()
        self.classtags=Myset()
        self.classhtmltags=Mydict()
    def union(self,other):
        self.tags.union(other.tags)
        self.idtags=self.idtags.union(other.idtags)
        self.idhtmltags.union(other.idhtmltags)
        self.classtags=self.classtags.union(other.classtags)
        self.classhtmltags.union(other.classhtmltags)
    @staticmethod
    def getid():
        return list(G.g.idtags)

def taghtml(s):
    r=G()
    for x in re.findall(r'<\s*\w+[^>]*>',s):
        x=x[1:-1]
        tag=re.match(r'\s*(\w+)',x).group().lower()
        properties=dict(map(lambda x:(x[0].lower(),x[1]), re.findall(r'(\w+)\s*=\s*"([^"]*)"',x)))
        r.idtags.add(properties.get('id',''))
        r.idhtmltags.add(tag,properties.get('id',''))
        r.classtags.add(properties.get('class',''))
        r.classhtmltags.add(tag,properties.get('class',''))
        properties.pop('id','')
        properties.pop('class','')
        for x in properties:
            r.tags.add(tag,x)
    return r


def cssmain(*arg):
    from glob import glob
    import vim,os
    os.chdir(vim.eval('expand("%:p:h")'))
    g=G()
    for x in arg:
        for y in glob(x):
            a=taghtml(file(y).read())
            g.union(a)
    vim.command('let b:select_propertytags=' + repr(g.tags))
    vim.command('let b:select_idtags=' + repr(g.idtags))
    vim.command('let b:select_idwithnodetags=' + repr(g.idhtmltags))
    vim.command('let b:select_classtags=' + repr(g.classtags))
    vim.command('let b:select_classwithnodetags=' + repr(g.classhtmltags))
EOF
endfun

call s:Py_htmltag()

let b:select_pyrun = 0

function! g:Cssaddusehtml(f, ...)
    let s = '"' . a:f . '"'
    let i = 1
    while i <= a:0
	    let s = s . ',"' . a:{i} . '"'
	    let i = i + 1
    endwhile
    execute "python cssmain(" . s . ")"
    let b:select_pyrun = 1
endfun

function! s:Tag_values_complete(partstr) 
	let output = []
	for name in b:complete_suggest.suggest
		if name =~ '^' . a:partstr
			call add(output, name)
		endif
	endfor
	if empty(output)
		for x in b:complete_suggest.suggest
			call add(output, x)
		endfor
	endif
	return output
endfun

function! s:In_htmlproperty_is(s)
	let matchpart = matchlist(a:s, '\(}\|^\)[^{}]\{-}\(\w\+\)\[\(\w*\)$')
	if ! empty(matchpart)
		let pos =  col('.') - strlen(matchpart[3])
		if (pos < 1) || ! has_key(b:select_propertytags, matchpart[2])
			return 0
		endif
		let b:complete_suggest = {'suggest': b:select_propertytags[matchpart[2]], 'complete': function('s:Tag_values_complete')}
		return pos
	endif
	return 0
endfun

function! s:In_class_is(s)
	let matchpart = matchlist(a:s, '\(}\|^\)[^{}]\{-}\(\w\+\)\.\(\w*\)$')
	if ! empty(matchpart)
		let pos =  col('.') - strlen(matchpart[3])
		if (pos < 1) || ! has_key(b:select_classwithnodetags, matchpart[2])
			return 0
		endif
		let b:complete_suggest = {'suggest': b:select_classwithnodetags[matchpart[2]], 'complete': function('s:Tag_values_complete')}
		return pos
	endif
	return 0
endfun
    
function! s:In_class1_is(s)
	let matchpart = matchlist(a:s, '\(}\|^\)[^{}]*\.\(\w*\)$')
	if ! empty(matchpart)
		let pos =  col('.') - strlen(matchpart[2])
		if (pos < 1) || len(b:select_classtags) < 1
			return 0
		endif
		let b:complete_suggest = {'suggest': b:select_classtags, 'complete': function('s:Tag_values_complete')}
		return pos
	endif
	return 0
endfun

function! s:In_id_is(s)
	let matchpart = matchlist(a:s, '\(}\|^\)[^{}]\{-}\(\w\+\)#\(\w*\)$')
	if ! empty(matchpart)
		let pos =  col('.') - strlen(matchpart[3])
		if (pos < 1) || ! has_key(b:select_idwithnodetags, matchpart[2])
			return 0
		endif
		let b:complete_suggest = {'suggest': b:select_idwithnodetags[matchpart[2]], 'complete': function('s:Tag_values_complete')}
		return pos
	endif
	return 0
endfun
    
function! s:In_id1_is(s)
	let matchpart = matchlist(a:s, '\(}\|^\)[^{}]*#\(\w*\)$')
	if ! empty(matchpart)
		let pos =  col('.') - strlen(matchpart[2])
		if (pos < 1) || len(b:select_idtags) < 1
			return 0
		endif
		let b:complete_suggest = {'suggest': b:select_idtags, 'complete': function('s:Tag_values_complete')}
		return pos
	endif
	return 0
endfun

function! g:CssComplete(findstart, base)
    if a:findstart
	    let curline = strpart(getline('.'), 0, col('.'))
	    let pos = s:In_values_is(curline)
	    if ! pos
		    let pos = s:In_properties_is(curline)
	    endif
	    if ! pos
		    let pos = s:In_pseudos_is(curline)
	    endif
	    if b:select_pyrun
		    if ! pos
			    let pos = s:In_htmlproperty_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_class_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_id_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_class1_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_id1_is(curline)
		    endif
            endif
	    if ! pos
		    let curline = getline(prevnonblank(line('.') - 1)) . ' ' . curline
		    let pos = s:In_values_is(curline)
	    endif
	    if ! pos
		    let pos = s:In_properties_is(curline)
	    endif
	    if ! pos
		    let pos = s:In_pseudos_is(curline)
	    endif
	    if b:select_pyrun
		    if ! pos
			    let pos = s:In_htmlproperty_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_class_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_id_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_class1_is(curline)
		    endif
		    if ! pos
			    let pos = s:In_id1_is(curline)
		    endif
            endif
	    if ! pos
		    let b:complete_suggest = {'suggest': [], 'complete': function('s:Normal_values_complete')}
		    return -1
	    endif
            return pos-1
    else
	    return b:complete_suggest.complete(a:base)
    endif
endfun

set completefunc=g:CssComplete

com! -buffer -nargs=+ -complete=file CSSaddhtml call g:Cssaddusehtml(<f-args>)
