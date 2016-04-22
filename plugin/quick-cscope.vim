" quick-cscope.vim:   For superfast Cscope results navigation using quickfix window
" Maintainer:         Ronak Gandhi <https://github.com/ronakg>
" Version:            0.5
" Website:            https://github.com/ronakg/vim-quick-cscope

" Setup {{
if exists("g:vim_quick_cscope_loaded") || !has("cscope")
  finish
endif
let g:vim_quick_cscope_loaded = 1
" }}

" Options {{
if !exists("g:vqc_default_maps")
  let g:vqc_default_maps = 1
endif

if !exists("g:vqc_autoload_db")
    let g:vqc_autoload_db = 1
endif
" }}

" s:autoload_db {{
function! s:autoload_db()
    if !empty($CSCOPE_DB)
        " Add database pointed to by enviorment variable
        let l:db = $CSCOPE_DB
    else
        " Add any database in current directory or any parent
        let l:db = findfile('cscope.out', '.;')
    endif
    if !empty(l:db)
        silent cs reset
        silent! execute 'cs add' l:db
    endif
endfunction
" }}

" s:quick_cscope {{
function! s:quick_cscope(str, query)
    " Close any open quickfix windows
    cclose

    " If the buffer that cscope jumped to is not same as current file, close the buffer
    let l:cur_file_name=@%
    echo "Searching for ".a:str
    execute "cs find ".a:query." ".a:str
    if l:cur_file_name != @%
        bd
    endif

    " Open quickfix window
    cwindow

    " Store the query string as search pattern for easy navigation
    " using n and N
    let @/ = a:str
endfunction
" }}

if g:vqc_autoload_db
    call s:autoload_db()
endif

" Plug mappings {{
nnoremap <silent> <plug>vim_quick_cscope_global :cs find g <cword><CR>
nnoremap <silent> <plug>vim_quick_cscope_symbols :call <SID>quick_cscope(expand("<cword>"), "s")<CR>
nnoremap <silent> <plug>vim_quick_cscope_callers :call <SID>quick_cscope(expand("<cword>"), "c")<CR>
nnoremap <silent> <plug>vim_quick_cscope_files :call <SID>quick_cscope(expand("<cfile>:t"), "f")<CR>
nnoremap <silent> <plug>vim_quick_cscope_includes :call <SID>quick_cscope(expand("<cfile>:t"), "i")<CR>
nnoremap <silent> <plug>vim_quick_cscope_text :call <SID>quick_cscope(expand("<cword>"), "t")<CR>
nnoremap <silent> <plug>vim_quick_cscope_functions :call <SID>quick_cscope(expand("<cword>"), "d")<CR>
nnoremap <silent> <plug>vim_quick_cscope_egrep :call <SID>quick_cscope(input('Enter egrep pattern: '), "e")<CR>
" }}

if g:vqc_default_maps
    nmap <leader>g <plug>vim_quick_cscope_global
    nmap <leader>c <plug>vim_quick_cscope_callers
    nmap <leader>s <plug>vim_quick_cscope_symbols
    nmap <leader>f <plug>vim_quick_cscope_files
    nmap <leader>i <plug>vim_quick_cscope_includes
    nmap <leader>t <plug>vim_quick_cscope_text
    nmap <leader>e <plug>vim_quick_cscope_egrep
    nmap <leader>d <plug>vim_quick_cscope_functions
endif

" Use quickfix window for cscope results. Clear previous results before the search.
set cscopequickfix=s-,c-,i-,t-,e-,f-,d-

" Modeline and Notes {{
" vim: set sw=4 ts=4 sts=4 et tw=99 foldmarker={{,}} foldlevel=10 foldlevelstart=10 foldmethod=marker:
" }}
