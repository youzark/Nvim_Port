" helper functions to deal with mapping stuff
function youzark#save_and_source()
    if &filetype == 'vim'
      :silent write
      :source %
    elseif &filetype == 'lua'
      :silent! write
      :luafile %
    endif
    return
endfunction

function youzark#executor() abort
  if &ft == 'lua'
    echom execute(printf(":lua %s", getline(".")))
  elseif &ft == 'vim'
    exe getline(".")
  endif
endfunction

function youzark#change_cwd() abort
	let l:file_name = @%
	let l:file_path = substitute(l:file_name,'[^/]*$','','')
	if !empty(l:file_path)
		execute("windo lcd ".l:file_path)
	endif
endfunction
