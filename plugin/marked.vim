if exists("g:loaded_markjump")
  finish
endif
let g:loaded_markjump = 1

let g:marks_file = expand("~/.vim/marks.json")
let g:marked_line = 0
let g:marked_file = ""

function! s:LoadMarks()
  if filereadable(g:marks_file)
    try
      return json_decode(join(readfile(g:marks_file), "\n"))
    catch
      return {}
    endtry
  endif
  return {}
endfunction

function! s:SaveMarks(marks)
  call writefile([json_encode(a:marks)], g:marks_file)
endfunction

function! s:LoadMarkForFile()
  let l:marks = s:LoadMarks()
  let l:file = expand('%:p')
  if has_key(l:marks, l:file)
    let g:marked_line = l:marks[l:file].line
    let g:marked_file = l:file
  endif
endfunction

function! s:SetMark()
  let l:marks = s:LoadMarks()
  let l:file = expand('%:p')
  let g:marked_line = line('.')
  let g:marked_file = l:file
  let l:marks[l:file] = {'line': g:marked_line}
  call s:SaveMarks(l:marks)
  echo "marked line ".g:marked_line
endfunction

function! s:JumpOrMark()
  let l:file = expand('%:p')
  if g:marked_line > 0 && g:marked_file == l:file
    execute g:marked_line
    echo "jumped to line ".g:marked_line
  else
    call s:SetMark()
  endif
endfunction

function! s:ClearMark()
  let l:marks = s:LoadMarks()
  let l:file = expand('%:p')
  if has_key(l:marks, l:file)
    call remove(l:marks, l:file)
    call s:SaveMarks(l:marks)
  endif
  let g:marked_line = 0
  let g:marked_file = ""
  echo "mark cleared"
endfunction

function! s:MarkList()
  let l:marks = s:LoadMarks()
  if empty(l:marks)
    echo "No marks saved"
    return
  endif
  echo "Saved Marks:"
  for [l:file, l:data] in items(l:marks)
    echo l:file . " → line " . l:data.line
  endfor
endfunction

nnoremap <silent> z :call <SID>JumpOrMark()<CR>
nnoremap <silent> Z :call <SID>ClearMark()<CR>

command! MarkList call <SID>MarkList()

augroup markjump
  autocmd!
  autocmd BufReadPost * call <SID>LoadMarkForFile()
augroup END
