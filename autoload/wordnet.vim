function! wordnet#browse (word)
  call system(g:wordnet_path . "wnb " . a:word)
endfunction

function! wordnet#overviews (word)
  let definition = system(g:wordnet_path . "wn " . a:word . " -over")
  if definition == ""
    let definition = "Word not found: " . a:word
  endif
  call s:WordNetOpenWindow(definition)
endfunction

function! wordnet#synonyms (word)
  let synonyms = system(g:wordnet_path . "wn " . a:word . " -synsn -synsv -synsa -synsr")
  if synonyms == ""
    let synonyms = "Word not found: " . a:word
  endif
  call s:WordNetOpenWindow(synonyms)
endfunction


function! s:WordNetOpenWindow (text)

  " If the buffer is visible
  if bufwinnr("__WordNet__") > -1
    " switch to it
    exec bufwinnr("__WordNet__") . "wincmd w"
    hide
  endif

  if bufnr("__WordNet__") > -1
    exec bufnr("__WordNet__") . "bdelete!"
  endif

  exec 'silent! keepalt botright 20split'
  exec ":e __WordNet__"
  let s:wordnet_buffer_id = bufnr('%')

  call append("^", split(a:text, "\n"))
  exec 0
  " Mark the buffer as scratch
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nonumber
  setlocal nobuflisted
  setlocal readonly
  setlocal nomodifiable
  setlocal filetype=wordnet

  mapclear <buffer>
  nmap <buffer> q :q<CR>

  syn match overviewHeader      /^Overview of .\+/
  syn match definitionEntry  /\v^[0-9]+\. .+$/ contains=numberedList,word
  syn match numberedList  /\v^[0-9]+\. / contained
  syn match word  /\v([0-9]+\.[0-9\(\) ]*)@<=[^-]+/ contained
  hi link overviewHeader Title
  hi link numberedList Operator
  hi def word term=bold cterm=bold gui=bold
endfunction
