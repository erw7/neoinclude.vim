"=============================================================================
" FILE: neoinclude.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:initialized = 0

function! neoinclude#initialize() abort "{{{
  if s:initialized
    return
  endif

  let g:neoinclude#ctags_command =
      \ get(g:, 'neoinclude#ctags_command', 'ctags')
  let g:neoinclude#ctags_arguments =
      \ get(g:, 'neoinclude#ctags_arguments', {})
  let g:neoinclude#_ctags_arguments = {}
  let g:neoinclude#max_processes =
        \ get(g:, 'neoinclude#max_processes', 20)
  let g:neoinclude#paths =
        \ get(g:, 'neoinclude#paths', {})
  let g:neoinclude#_paths = {}
  let g:neoinclude#patterns =
        \ get(g:, 'neoinclude#patterns', {})
  let g:neoinclude#_patterns = {}
  let g:neoinclude#exprs =
        \ get(g:, 'neoinclude#exprs', {})
  let g:neoinclude#_exprs = {}
  let g:neoinclude#exts =
        \ get(g:, 'neoinclude#exts', {})
  let g:neoinclude#_exts = {}
  let g:neoinclude#reverse_exprs =
        \ get(g:, 'neoinclude#reverse_exprs', {})
  let g:neoinclude#_reverse_exprs = {}
  let g:neoinclude#functions =
        \ get(g:, 'neoinclude#functions', {})
  let g:neoinclude#_functions = {}
  let g:neoinclude#delimiters =
        \ get(g:, 'neoinclude#delimiters', {})
  let g:neoinclude#_delimiters = {}
  let g:neoinclude#suffixes =
        \ get(g:, 'neoinclude#suffixes', {})
  let g:neoinclude#_suffixes = {}

  " Initialize include pattern. "{{{
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_patterns',
        \ 'java,haskell', '^\s*\<import')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_patterns',
        \ 'c,cpp', '^\s*#\s*include')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_patterns',
        \ 'cs', '^\s*\<using')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_patterns',
        \ 'ruby', '^\s*\<\%(load\|require\|require_relative\)\>')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_patterns',
        \ 'r', '^\s*source(')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_patterns',
        \ 'html,xhtml,xml,markdown,mkd', 'src="\ze[^"]*')
  "}}}
  " Initialize include suffixes. "{{{
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_suffixes',
        \ 'haskell', '.hs')
  "}}}
  " Initialize include functions. "{{{
  " call neoinclude#util#set_default_dictionary(
  "       \ 'g:neoinclude#_functions', 'vim',
  "       \ 'neoinclude#analyze_vim_include_files')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_functions', 'ruby',
        \ 'neoinclude#analyze_ruby_include_files')
  "}}}
  " Initialize filename include expr. "{{{
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_reverse_exprs',
        \ 'perl',
        \ 'substitute(v:fname, "/", "::", "g")')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_reverse_exprs',
        \ 'java,d',
        \ 'substitute(v:fname, "/", ".", "g")')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_reverse_exprs',
        \ 'ruby',
        \ 'substitute(v:fname, "\.rb$", "", "")')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_reverse_exprs',
        \ 'python',
        \ "substitute(substitute(v:fname,
        \ '\\v.*egg%(-info|-link)?$', '', ''), '/', '.', 'g')")
  "}}}
  " Initialize filename include extensions. "{{{
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_exts',
        \ 'c', ['h'])
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_exts',
        \ 'cpp', ['', 'h', 'hpp', 'hxx'])
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_exts',
        \ 'perl', ['pm'])
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_exts',
        \ 'java', ['java'])
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_exts',
        \ 'ruby', ['rb'])
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_exts',
        \ 'python', ['py', 'py3'])
  "}}}
  " Initialize filename include delimiter. "{{{
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_delimiters',
        \ 'c,cpp,ruby', '/')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_delimiters',
        \ 'html,xhtml,xml,markdown,mkd', '')
  "}}}

  " Initialize ctags arguments. "{{{
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_ctags_arguments',
        \ '_', '')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_ctags_arguments', 'vim',
        \ '--language-force=vim --extra=fq --fields=+ailmnSz --vim-kinds=-f '.
        \ '--regex-vim=''/function!?[ \t]+'.
        \ '(([bwtglsa]:)?\w+(\.\w+)+|(g:)?([A-Z]\w*|\w+(#\w+)+)|s:\w+)'.
        \ '[ \t]*\(/\1/function/''')
  if neoinclude#util#is_mac()
    call neoinclude#util#set_default_dictionary(
          \ 'g:neoinclude#_ctags_arguments', 'c',
          \ '--c-kinds=+p --fields=+iaS --extra=+q
          \ -I__DARWIN_ALIAS,__DARWIN_ALIAS_C,__DARWIN_ALIAS_I,__DARWIN_INODE64
          \ -I__DARWIN_1050,__DARWIN_1050ALIAS,__DARWIN_1050ALIAS_C,__DARWIN_1050ALIAS_I,__DARWIN_1050INODE64
          \ -I__DARWIN_EXTSN,__DARWIN_EXTSN_C
          \ -I__DARWIN_LDBL_COMPAT,__DARWIN_LDBL_COMPAT2')
  else
    call neoinclude#util#set_default_dictionary(
          \ 'g:neoinclude#_ctags_arguments', 'c',
          \ '-R --sort=1 --c-kinds=+p --fields=+iaS --extra=+q ' .
          \ '-I __wur,__THROW,__attribute_malloc__,__nonnull+,'.
          \   '__attribute_pure__,__attribute_warn_unused_result__,__attribute__+')
  endif
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#_ctags_arguments', 'cpp',
        \ '--language-force=C++ -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q '.
        \ '-I __wur,__THROW,__attribute_malloc__,__nonnull+,'.
        \   '__attribute_pure__,__attribute_warn_unused_result__,__attribute__+')
  "}}}

  augroup neoinclude
    autocmd!
  augroup END

  call neoinclude#include#initialize()

  let s:initialized = 1
endfunction"}}}

function! neoinclude#set_filetype_paths(bufnr, filetype) abort "{{{
  if a:filetype ==# 'python' || a:filetype ==# 'python3'
    " Initialize python path pattern.
    if executable('python3')
      call s:set_python_paths('python3')
    endif
    if executable('python')
      call s:set_python_paths('python')
    endif
  elseif a:filetype ==# 'cpp'
        \ && !has_key(g:neoinclude#paths, 'cpp')
        \ && isdirectory('/usr/include/c++')
    call s:set_cpp_paths(a:bufnr)
  endif
endfunction"}}}

function! neoinclude#get_path(bufnr, filetype) abort "{{{
  " Don't use global path if it is not C or C++
  let default = (a:filetype ==# 'c' || a:filetype ==# 'cpp'
        \ || getbufvar(a:bufnr, '&path') !=# &path) ?
        \ getbufvar(a:bufnr, '&path') : '.'
  return neoinclude#util#substitute_path_separator(
        \ neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_paths',
        \   g:neoinclude#paths, g:neoinclude#_paths,
        \   default))
endfunction"}}}
function! neoinclude#get_pattern(bufnr, filetype) abort "{{{
  return neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_patterns',
        \   g:neoinclude#patterns, g:neoinclude#_patterns,
        \   getbufvar(a:bufnr, '&include'))
endfunction"}}}
function! neoinclude#get_expr(bufnr, filetype) abort "{{{
  return neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_exprs',
        \   g:neoinclude#exprs, g:neoinclude#_exprs,
        \   getbufvar(a:bufnr, '&includeexpr'))
endfunction"}}}
function! neoinclude#get_reverse_expr(filetype) abort "{{{
  return neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_reverse_exprs',
        \   g:neoinclude#reverse_exprs, g:neoinclude#_reverse_exprs,
        \   '')
endfunction"}}}
function! neoinclude#get_exts(filetype) abort "{{{
  return neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_exts',
        \   g:neoinclude#exts, g:neoinclude#_exts,
        \   [])
endfunction"}}}
function! neoinclude#get_function(filetype) abort "{{{
  return neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_functions',
        \   g:neoinclude#functions, g:neoinclude#_functions,
        \   '')
endfunction"}}}
function! neoinclude#get_delimiters(filetype) abort "{{{
  return neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_delimiters',
        \   g:neoinclude#delimiters, g:neoinclude#_delimiters,
        \   '.')
endfunction"}}}
function! neoinclude#get_suffixes(bufnr, filetype) abort "{{{
  return neoinclude#util#get_default_buffer_config(
        \   a:filetype, 'b:neoinclude_suffixes',
        \   g:neoinclude#suffixes, g:neoinclude#_suffixes,
        \   getbufvar(a:bufnr, '&suffixesadd'))
endfunction"}}}

" Analyze include files functions.
function! neoinclude#analyze_vim_include_files(lines, path) "{{{
  let include_files = []
  let dup_check = {}
  for line in a:lines
    if line =~ '\<\h\w*#' && line !~ '\<function!\?\>'
      let filename = 'autoload/' . substitute(matchstr(line, '\<\%(\h\w*#\)*\h\w*\ze#'),
            \ '#', '/', 'g') . '.vim'
      if filename == '' || has_key(dup_check, filename)
        continue
      endif
      let dup_check[filename] = 1

      let filename = fnamemodify(findfile(filename, &runtimepath), ':p')
      if filereadable(filename)
        call add(include_files, filename)
      endif
    endif
  endfor

  return include_files
endfunction"}}}
function! neoinclude#analyze_ruby_include_files(lines, path) "{{{
  let include_files = []
  let dup_check = {}
  for line in a:lines
    if line =~ '\<autoload\>'
      let args = split(line, ',')
      if len(args) < 2
        continue
      endif
      let filename = substitute(matchstr(args[1], '["'']\zs\f\+\ze["'']'),
            \ '\.', '/', 'g') . '.rb'
      if filename == '' || has_key(dup_check, filename)
        continue
      endif
      let dup_check[filename] = 1

      let filename = fnamemodify(findfile(filename, a:path), ':p')
      if filereadable(filename)
        call add(include_files, filename)
      endif
    endif
  endfor

  return include_files
endfunction"}}}

function! s:set_python_paths(python_bin) "{{{
  let python_sys_path_cmd = a:python_bin .
        \ ' -c "import sys;sys.stdout.write(\",\".join(sys.path))"'
  let path = neoinclude#util#system(python_sys_path_cmd)
  let path = join(neoinclude#util#uniq(filter(
        \ split(path, ',', 1), "v:val != ''")), ',')
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#paths', a:python_bin, path)
endfunction"}}}

function! s:set_cpp_paths(bufnr) "{{{
  if exists('*vimproc#readdir')
    let files = vimproc#readdir('/usr/include/')
          \ + vimproc#readdir('/usr/include/c++/')
    for directory in filter(split(glob(
          \ '/usr/include/*/c++'), '\n'), 'isdirectory(v:val)')
      let files += vimproc#readdir(directory)
    endfor
  else
    let files = split(glob('/usr/include/*'), '\n')
          \ + split(glob('/usr/include/c++/*'), '\n')
          \ + split(glob('/usr/include/*/c++/*'), '\n')
  endif
  call filter(files, 'isdirectory(v:val)')

  " Add cpp path.
  call neoinclude#util#set_default_dictionary(
        \ 'g:neoinclude#paths', 'cpp',
        \ getbufvar(a:bufnr, '&path') .
        \ ','.join(files, ','))
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
