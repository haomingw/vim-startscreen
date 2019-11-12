if exists('g:loaded_startscreen') || &cp
  finish
endif
let g:loaded_startscreen = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:warn(msg) abort
  echohl WarningMsg
  echomsg 'startscreen: ' . a:msg
  echohl NONE
endfunction

function! startscreen#start()
  if !argc() && line2byte('$') == -1
    return
  endif
" Handle vim -y, vim -M.
  if &insertmode || !&modifiable
    return
  endif
  if !&hidden && &modified
    call s:warn('Save your changes first.')
    return
  endif

  noautocmd enew

  silent! setlocal
        \ bufhidden=wipe
        \ colorcolumn=
        \ foldcolumn=0
        \ matchpairs=
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ nonumber
        \ norelativenumber
        \ nospell
        \ noswapfile
        \ signcolumn=no
        \ synmaxcol&

  let l:version = split(execute(":version"), '\n')[0]
  call append('$', l:version)

  " No modifications to this buffer
  setlocal nomodifiable nomodified

  " Set mappings
  nnoremap <buffer><nowait><silent> <insert>: enew <bar> startinsert<cr>
  nnoremap <buffer><nowait><silent> i:        enew <bar> startinsert<cr>
  nnoremap <buffer><nowait><silent> a:        enew <bar> startinsert<cr>
  nnoremap <buffer><nowait><silent> o:        enew <bar> startinsert<cr><cr>
  nnoremap <buffer><nowait><silent> p:        enew<CR>p
  nnoremap <buffer><nowait><silent> P:        enew<CR>P

endfunction

augroup startscreen
  autocmd VimEnter * call startscreen#start()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
