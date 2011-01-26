
" Vim syntax file
" Language:    SQL, sqlite
" Maintainer:  sunsol
" Last Change: 2010.4.1
" Version:     0.0.1

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn case ignore

" The SQL reserved words, defined as keywords.

" syn keyword sqlSpecial  false null true

" common functions
syn keyword sqlFunction	 count sum avg min max group_concat round
syn keyword sqlFunction	 total abs changes coalesce rtrim soundex
syn keyword sqlFunction	 ifnull hex last_insert_rowid sqlite_compileoption_get
syn keyword sqlFunction	 length load_extension lower ltrim
syn keyword sqlFunction	 nullif quote random randomblob replace
syn keyword sqlFunction	 sqlite_compileoption_used sqlite_source_id
syn keyword sqlFunction	 sqlite_version substr total_changes trime
syn keyword sqlFunction	 typeof upper zeroblob date time datetime
syn keyword sqlFunction	 julianday strftime

syn keyword sqlKeyword abort action add after all alter analyze as asc attach autoincrement
syn keyword sqlKeyword before begin by cascade case cast check collate column commit
syn keyword sqlKeyword conflict constraint create cross current_date current_time current_timestamp
syn keyword sqlKeyword database default deferrable deferred delete desc detach drop
syn keyword sqlKeyword each else end except exclusive exists explain fail for foreign from
syn keyword sqlKeyword full group having if ignore immediate in index indexed initially
syn keyword sqlKeyword inner insert instead intersect into isnull join key left limit match
syn keyword sqlKeyword natural no notnull null of offset on order outer plan pragma primary
syn keyword sqlKeyword query raise references regexp reindex release rename replace restrict
syn keyword sqlKeyword right rollback row savepoint select set table temp temporary then to transaction
syn keyword sqlKeyword trigger union unique update using vacuum values view virtual when where

syn keyword sqlOperator	between like not and or glob distinct escape

syn keyword sqlType	 text integer real blob numeric

syn keyword sqlOption    echo load schema read restore backup
syn keyword sqlOption    databases dump headers import indices
syn keyword sqlOption    mode nullvalue output separator show
syn keyword sqlOption    tables timeout timer width

" Strings and characters:
syn region sqlString		start=+"+    end=+"+ contains=@Spell
syn region sqlString		start=+'+    end=+'+ contains=@Spell

" Numbers:
syn match sqlNumber		"-\=\<\d*\.\=[0-9_]\>"

" Comments:
syn region sqlDashComment	start=/--/ end=/$/ contains=@Spell
syn cluster sqlComment	contains=sqlDashComment,@Spell
syn sync ccomment sqlComment
syn sync ccomment sqlDashComment

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_sql_syn_inits")
    if version < 508
        let did_sql_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi link <args>
    endif

    HiLink sqlDashComment	Comment
    HiLink sqlNumber	        Number
    HiLink sqlOperator	        Operator
    "HiLink sqlSpecial	        Special
    HiLink sqlKeyword	        Keyword
    "HiLink sqlStatement	        Statement
    HiLink sqlString	        String
    HiLink sqlType	        Type
    HiLink sqlFunction	        Function
    HiLink sqlOption	        PreProc

    delcommand HiLink
endif

let b:current_syntax = "sqlite"

" vim:sw=4:
