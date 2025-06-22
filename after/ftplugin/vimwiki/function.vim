nmap <buffer> st :call Convert_single_line_string_to_shell_string("<notion>")<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Utility
function Run_pomo_back_end() abort
	let l:sleep_time = 30*60
	sleep l:sleep_time 
	echo "Pomodoro for l:sleep_time"
	execute("!play ~/supervise/sound_effect/test.mp3")
endfunction

function Open_diary() abort
	let l:date = Get_date()
	let l:diary_path = "~/Computer/wiki/diary/".l:date.".md"
	if empty(glob(l:diary_path))
		Write_diary_header()
		execute "e "."~/Computer/wiki/diary/".l:date.".md"
	else
		execute "e "."~/Computer/wiki/diary/".l:date.".md"
	endif
endfunction

function Log_gen() abort
	let l:seprater = "---\\n\\\n"
	let l:discription = Get_discription()
	let l:finish_time = Get_time()
	let l:log = l:seprater."\<font size=\"3\"\>"."Discription:".l:discription."\\n\\\n"."\<font size=\"3\"\>"."Finish Time:".l:finish_time."\\n\\\n".l:seprater."\\n\\\n"
	let l:date = Get_date()
	let l:diary_path = "~/Computer/wiki/diary/".l:date.".md"
	let l:cmd = "echo"." \"".l:log."\""." >> ".l:diary_path
	call system(l:cmd)
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unfinished
function Write_diary_header() abort
	let l:header = "## Task Has Been Done:"
endfunction

function Write_a_line_to_file(line,file) abort
	let l:cmd = "echo"." \"".a:line."\""." >> ".a:file
	call system(l:cmd)
endfunction

function Convert_single_line_string_to_shell_string(line) abort
	let l:re_line = a:line
	let l:re_line = substitute(l:re_line,"<",'\\\<','g')
	let l:re_line = substitute(l:re_line,">",'\\\>','g')
	echo l:re_line
endfunction

function Print_time() abort
	call nvim_paste(Get_time(),0,-1)
endfunction

function Print_date() abort
	call nvim_paste(Get_date(),0,-1)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Internal Utility
function Get_time() abort
	let l:time = substitute(system('date +%H:%M'),'\n\+$','','')
	return l:time
endfunction

function Get_date() abort
	let l:date =  substitute(system("date +%F"),'\n\+$','','')
	return l:date
endfunction

function Get_discription() abort
	let l:whole_line = nvim_get_current_line()
	let l:strip_prefix = substitute(l:whole_line, '^\t* *\* \[.\] *','','')  ""get ride of * [ ]
	let l:discription = substitute(l:strip_prefix,' *\#\([0-9]\|[a-z]\)*$','','')
	return l:discription
endfunction

