let g:ts_child = { 'magit': 'gitcommit' }
function! Splitjoin_split(type, ...) abort
  let save = @@
  let save_s = @s
  if a:type == 'line'
    let command = "'[V']"
  else
    if a:0
      let command = '`]ms`["sy$j0v`s'
    else
      let command = "`[v`]"
    endif
  endif
  exec 'normal '.command.'dms'
  let cbuff = bufnr('%')
  if a:0
    let cft = @s
    let cmdtype = 'line'
  elseif has_key(g:ts_child, &ft)
    let cft = g:ts_child[&ft]
    let cmdtype = a:type
  else
    let cft = &ft
    let cmdtype = a:type
  endif
  vnew
  let b:retbuff = cbuff
  let b:commandtype = cmdtype
  exec 'set filetype='.cft
  normal Vp
  nnoremap <buffer> q :call Splitjoin_join()<CR>
endfunction

function! Splitjoin_join() abort
  normal gg0vG$d
  if b:commandtype == 'line'
    let paste = "'sP"
  else
    let paste = "\`sp"
  endif
  let cbuff = b:retbuff
  bd! %
  normal <C-w>q
  exec 'buffer '.cbuff
  exec 'normal '.paste
endfunction

function! Splitjoin_inner_markdown(type) abort
  ?`
  normal k
  call Splitjoin_split(a:type, 1)
endfunction

if !exists('g:timeshift_markdown_mapping')
  let g:timeshift_markdown_mapping='cmd'
endif

if !exists('g:timeshift_mapping')
  let g:timeshift_mapping='csj'
endif

autocmd FileType markdown exec 'nmap <buffer> '.g:timeshift_markdown_mapping.' :set opfunc=Splitjoin_inner_markdown<CR>g@i`'
execute "nmap ".g:timeshift_mapping." :set opfunc=Splitjoin_split<CR>g@"
