"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Sets how many lines of history VIM have to remember
set history=500

"Enable filetype plugin
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread
let g:isWin = 0
"Set mapleader
let mapleader = ";"
let g:mapleader = ";"

"Fast saving
imap <F2> <ESC> :w!<cr>
nmap <F2> <ESC> :w!<cr>

" Fast editing of the .vimrc
if has("win32")
    "Fast editing of _vimrc
    map <leader>e :e! $VIM/_vimrc<cr>

    "When .vimrc is edited, reload it
    autocmd! bufwritepost vimrc source /$VIM/_vimrc
elseif has("unix")
    "Fast editing of .vimrc
    map <leader>e :e! ~/.vimrc<cr>

    "When .vimrc is edited, reload it
    autocmd! bufwritepost vimrc source ~/.vimrc
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Toggle Menu and Toolbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set guioptions-=m
set guioptions-=T
map <silent> <leader>t :if &guioptions =~# 'T' <Bar>
        \set guioptions-=T <Bar>
        \set guioptions-=m <bar>
    \else <Bar>
        \set guioptions+=T <Bar>
        \set guioptions+=m <Bar>
    \endif<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" insert to normal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"hi StatusLine guifg=#FBFAFB  guibg=#755939  gui=bold
"autocmd InsertEnter * hi statusline guifg=#FBFAFB guibg=#44507F gui=bold
"autocmd InsertLeave * hi statusline guifg=#FBFAFB guibg=#755939 gui=bold
inoremap <C-c>  <ESC>`^
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"For Cope
map <silent> <leader><cr> :noh<cr>
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>cc :botright cope<cr>
map <leader>cn <ESC> :cn<cr>
map <leader>cp <ESC> :cp<cr>
autocmd FileType c,cpp  map <buffer> <leader><space> :w<cr>:make<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7

set nu
set ruler "Always show current position

set cmdheight=2 "The commandbar height

set hid "Change buffer - without saving

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase

set hlsearch "Highlight search things

set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don't redraw while executing macros

set magic "Set magic on, for regular expressions

set showmatch "Show matching bracets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"Highlight current
set cursorline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable syntax highlight
syntax enable

"set font
if has("win32")
  set guifont=Yahei\ Mono:h9
elseif has("unix")
  set guifont=Monospace\ 10
  set shell=/bin/bash
endif

if has("gui_running")
  if has("win32")
    "Auto Maximize when gvim startup in Window system.
    au GUIEnter * simalt ~x
  endif

  colorscheme desert
else
  set t_Co=256
  colorscheme wombat2
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
if has("win32")
  set ffs=dos,unix,mac
elseif has("unix")
  set ffs=unix,dos,mac
endif

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
    if MySys() == "windows"
      set undodir=C:\Windows\Temp
    else
      set undodir=~/.vim/undodir
    endif

    set undofile
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set lbr
set tw=500

set ai "Auto indent
set si "Smart indet
set wrap "Wrap lines

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<cr>
vnoremap <silent> # :call VisualSearch('b')<cr>

" When you press gv you vimgrep after the selected text
"vnoremap <silent> gv :call VisualSearch('gv')<cr>
"map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

func! Cwd()
  let cwd = getcwd()
  return "e " . cwd
endfunc

func! DeleteTillSlash()
  let g:cmd = getcmdline()
  if MySys() == "linux" || MySys() == "mac"
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  endif
  if g:cmd == g:cmd_edited
    if MySys() == "linux" || MySys() == "mac"
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    endif
  endif
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
map <C-right> :bn<cr>
map <C-left> :bp<cr>

" Tab configuration
map <leader>tn :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tn :tabnext<cr>
map <leader>tp :tabp<cr>

" When pressing <leader>cd switch to the directory of the open buffer
"map <leader>cd :cd %:p:h<cr>

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


function! CurDir()
    let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
"map 0 ^

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

set guitablabel=%t

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vnoremap $1 <esc>`>a)<esc>`<i(<esc>
"vnoremap $2 <esc>`>a]<esc>`<i[<esc>
"vnoremap $3 <esc>`>a}<esc>`<i{<esc>
"vnoremap $$ <esc>`>a"<esc>`<i"<esc>
"vnoremap $q <esc>`>a'<esc>`<i'<esc>
"vnoremap $e <esc>`>a"<esc>`<i"<esc>

"" Map auto complete of (, ", ', [
"inoremap $1 ()<esc>i
"inoremap $2 []<esc>i
"inoremap $3 {}<esc>i
"inoremap $4 {<esc>o}<esc>O
"inoremap $q ''<esc>i
"inoremap $e ""<esc>i
"inoremap $t <><esc>i

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab idate <c-r>=strftime("%Y-%m-%d")<CR>
iab itime <c-r>=strftime("%H:%M")<CR>
iab imail wy.wangyun@gmail.com
iab iname Yun Wang

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
"noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>
au BufRead,BufNewFile ~/buffer iab <buffer> xh1 ===========================================

map <leader>pp :setlocal paste!<cr>

map <leader>bb :cd ..<cr>

" restore the last file open position
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH
let s:PlugWinSize = 30
""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>

""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
map <leader>o :BufExplorer<cr>

""""""""""""""""""""""""""""""
" => Minibuffer plugin
""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1

let g:bufExplorerSortBy = "name"

autocmd BufRead,BufNew :call UMiniBufExplorer

map <leader>u :TMiniBufExplorer<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => taglist 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>t :TlistToggle<cr>
let Tlist_Show_One_File = 0
let Tlist_Exit_OnlyWindow = 1 
let Tlist_Use_Right_Window = 0
let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 0
let Tlist_WinWidth = s:PlugWinSize
let Tlist_Auto_Open = 0
let Tlist_Display_Prototype = 0
"let Tlist_Close_On_Select = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lookupfile 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LookupFile_MinPathLength = 2
let g:LookupFile_PreserveLastPattern = 0
let g:LookupFile_PreservePatternHistory = 1
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_AllowNewFiles = 0

if filereadable("./filenametags")
    let g:LookupFile_TagExp = '"./filenametags"'
endif

nmap <silent> <leader>lk :LUTags<cr>
nmap <silent> <leader>ll :LUBufs<cr>
nmap <silent> <leader>lw :LUWalk<cr>

" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc' 

""""""""""""""""""""""""""""""
" => BufExplorer
""""""""""""""""""""""""""""""
"let g:bufExplorerDefaultHelp = 0
"let g:bufExplorerShowRelativePath = 0
let g:bufExplorerSortBy = 'mru'
"let g:bufExplorerSplitRight = 0
"let g:bufExplorerSplitVertical = 1
"let g:bufExplorerSplitVertSize = 30
let g:bufExplorerUseCurrentWindow = 1
autocmd BufWinEnter \[Buf\ List\] setl nonumber

""""""""""""""""""""""""""""""
" => winmanager
""""""""""""""""""""""""""""""
let g:winManagerWindowLayout = 'BufExplorer|FileExplorer,TagList'
let g:winManagerWidth = 30
let g:defaultExplorer = 1
nmap <silent> <leader>wm :WMToggle<cr>
""""""""""""""""""""""""""""""
" => cscope and tag
""""""""""""""""""""""""""""""
map <F12> :call Do_CsTag()<cr>
function! Do_CsTag()
    let dir = getcwd()

    if ( DeleteFile(dir, "tags") ) 
        return 
    endif
    if ( DeleteFile(dir, "cscope.files") ) 
        return 
    endif
    if ( DeleteFile(dir, "cscope.out") ) 
        return 
    endif

    if(executable('ctags'))
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    
    if(executable('cscope') && has("cscope") )
        if(g:isWin)
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        else
            silent! execute "!find ./  -name '*.c' -o -name '*.h' -o -name '*.cpp' > cscope.files"
        endif
        silent! execute "!cscope -b -i cscope.files"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs kill -1"
            execute "cs add cscope.out"
        endif
    endif
    execute "redr!"
endfunction

function! DeleteFile(dir, filename)
    if filereadable(a:filename)
        if (g:isWin)
            let ret = delete(a:dir."\\".a:filename)
        else
            let ret = delete("./".a:filename)
        endif
        if (ret != 0)
            echohl WarningMsg | echo "Failed to delete ".a:filename | echohl None
            return 1
        else
            return 0
        endif
    endif
    return 0
endfunction

if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
    set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-,d-
    nmap <C-@>0 :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>1 :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>2 :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>3 :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>4 :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>6 :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
    nmap <C-@>7 :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
    nmap <C-@>8 :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
    "0 或 s: 查找本 C 符号
    "1 或 g: 查找本定义
    "2 或 d: 查找本函数调用的函数
    "3 或 c: 查找调用本函数的函数
    "4 或 t: 查找本字符串
    "6 或 e: 查找本 egrep 模式
    "7 或 f: 查找本文件
    "8 或 i: 查找包含本文件的文件
endif
""""""""""""""""""""""""""""""
" => xptemplate config
""""""""""""""""""""""""""""""
"let g:xptemplate_vars = "SParg="
" avoid key conflict
let g:SuperTabMappingForward = '<Plug>supertabKey'

" if nothing matched in xpt, try supertab
let g:xptemplate_fallback = '<Plug>supertabKey'

" xpt uses <Tab> as trigger key
let g:xptemplate_key = '<Tab>'

" use <tab>/<S-tab> to navigate through pum. Optional
" let g:xptemplate_pum_tab_nav = 1

" xpt triggers only when you typed whole name of a snippet. Optional
" let g:xptemplate_minimal_prefix = 'full'
""""""""""""""""""""""""""""""
" => c syntax section
""""""""""""""""""""""""""""""
"let c_syntax_for_h = 1
"let c_C94 = 1
"let c_C99_warn = 1
"let c_cpp_warn = 1
"let c_warn_8bitchars = 1
"let c_warn_multichar = 1
"let c_warn_digraph = 1
"let c_warn_trigraph = 1
"let c_no_octal = 1
"let c_c_vim_compatible = 1
"let c_C94 = 1
"let c_C99 = 1
"let c_posix = 1
"let c_math = 1
"let c_no_names = 1
"let c_ansi_typedefs = 1
"let c_ansi_constants = 1
"let c_impl_defined = 1
"""""""""""""""""""""""""""""""""
nmap <leader>co :QFix<CR>
nmap <leader>ct :call QFixToggle(1)<CR>
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
 
function! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced != 0
        cclose
    else
        if exists("g:my_quickfix_win_height")
            execute "copen ".g:my_quickfix_win_height
        else
            copen
        endif
    endif
endfunction
 
augroup QFixToggle
    autocmd!
    autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
    autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END
"
""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def

" my script func
vmap <leader><F3> y/<C-R>"<CR>
vmap <silent> <F3> y :grep -Inr '\<<C-R>"\>' *.c *.cpp *.h <CR><CR>:copen<CR>
""vmap <silent> <F3> y :!find . -name '*.[ch]' -o -name '*.cpp' | !xargs grep -InR "<C-R>""  <CR><CR>:copen<CR>
let g:vimrc_author='yun wang'
let g:vimrc_email='wangy@szreach.com'
let g:vimrc_homepage='www.szreach.com'

nmap <F4> :AuthorInfoDetect<cr>
"end
