" vim: set sw=4 ts=4 et fdm=marker:
set encoding=utf-8      " internal encoding
scriptencoding utf-8    " encoding of this script

" Vi-Improved
if &compatible
    set nocompatible
endif

" syntax
syntax enable

" initialize autocmd
augroup MyAutocmd
    autocmd!
augroup END

" switching variables
let s:is_gui         = has('gui_running')
let s:is_windows     = has('win32') || has('win64')
let s:is_windows_cui = s:is_windows && !s:is_gui
let s:is_unix        = has('unix')
let s:is_cygwin      = has('win32unix')
let s:is_starting    = has('vim_starting')

" set $DOTVIM ; path to .vim directory "{{{
if !exists('$DOTVIM')
    function! s:get_dotvimdir_var()
        " candidates of dotvim path ordered in priority
        let s:dotvimdir_candidates = [
            \ '~/vimfiles',
            \ '~/.vim',
            \ '~/dotvim/vimfiles',
            \ '~/dotvim/.vim',
            \ '~/dotvim',
        \ ]

        " return path that found first
        for item in s:dotvimdir_candidates
            let dotvim = expand(item)
            if isdirectory(dotvim)
                return dotvim
            endif
        endfor

        " if not found, return home directory
        return expand('~')
    endfunction

    let $DOTVIM = s:get_dotvimdir_var()
    delfunction s:get_dotvimdir_var
endif "}}}

" get word selected on visual mode
function! s:get_selected()
    let save_z = getreg('z', 1)
    let save_z_type = getregtype('z')

    try
        normal! gv"zy
        return @z
    finally
        call setreg('z', save_z, save_z_type)
    endtry
endfunction

" syntax folding setting
" required foldmethod=syntax
" augroup: a
" function: f
" lua: l
" perl: p
" ruby: r
" python: P
" tcl: t
" mzscheme: m
let g:vimsyn_folding = 'aflprPm'

" no error
let g:vimsyn_noerror = 1

" no indent backslash for VimScript
" (this is width of indentation)
let g:vim_indent_cont = 0

" set highlight of doxygen for c, cpp, and idl
let g:load_doxygen_syntax = 1
let g:doxygen_enhanced_color = 1

" lightline.vim "{{{
let g:lightline = {
    \ 'colorscheme': 'landscape',
    \ 'component': {
        \ 'readonly': '%{&readonly?"":""}',
        \ 'lineinfo': '%3l:%-2v',
    \ },
    \ 'component_function': {
        \ 'currentdir': 'MyCurrentDir',
        \ 'filetype': 'MyFiletype',
        \ 'fileformat': 'MyFileformat'
    \ },
    \ 'tab_component_function': {
        \ 'closetab': 'MyCloseTab'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ 'tabline': {
        \ 'left': [ [ 'tabs' ] ],
        \ 'right': [ [ 'close' ], [ 'currentdir' ] ]
    \ },
\ }

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
 
function! MyCurrentDir()
    let cur_dir = fnamemodify(getcwd(), ':~')
    if strlen(cur_dir) > &columns / 2
        let cur_dir = '.../' . fnamemodify(cur_dir, ':t')
    endif
    return cur_dir
endfunction

function! MyCloseTab(n)
    return '%' . a:n . 'X X'
endfunction
"}}}

" mouse behaves Windows
behave mswin


" specially color setting "{{{
" to override by autocmd before colorscheme setting
autocmd MyAutocmd ColorScheme *
        \ if s:is_gui | call s:set_my_gui_color()
        \ | else | call s:set_my_cterm_color()
        \ | endif

" color for GUI
function! s:set_my_gui_color()
    hi TabLine      guifg=#777798 guibg=#444477 gui=NONE
    hi TabLineFill  guifg=#666688 guibg=#CCCCFF
    hi TabLineSel   guifg=#CCCCFF guibg=#111155 gui=bold
    hi FoldColumn   guifg=#818698 guibg=#363946
    hi Folded       guifg=#cccccc guibg=#333366
    hi ColorColumn  guifg=NONE    guibg=#333333 gui=NONE
    hi SpecialKey   guifg=#444466 guibg=NONE    gui=NONE
    hi NonText      guifg=#ffffff
    hi LineNr       guifg=#999999 guibg=#222222
    hi CursorLineNr guifg=#9999ff guibg=#444444
    hi Cursor       guifg=#000000 guibg=#ffffff gui=NONE
    hi PmenuSel     guifg=#000000 guibg=#00cccc
endfunction

" color for cterm
function! s:set_my_cterm_color()
    hi TabLine      ctermfg=Black   ctermbg=DarkGray cterm=NONE
    hi TabLineFill  ctermfg=Black   ctermbg=Gray     cterm=NONE
    hi TabLineSel   ctermfg=Gray    ctermbg=Black    cterm=underline
    hi NonText      ctermfg=White
    hi Cursor       ctermfg=White   ctermbg=Black
endfunction
"}}}

" colorscheme settings
if !s:is_gui
    set t_Co=256
endif
try
    colorscheme landscape
catch /^Vim(colorscheme):/
    colorscheme desert
endtry


" file-encoding list ordered in priority
set fileencodings=utf-8,cp932,euc-jp,ucs-2le,default,latin1

" eol-format list ordered in priority
set fileformats=unix,dos

set number                      " show line numbers
"set ruler                       " show ruler
set showcmd                     " show inserted command
set wrap                        " wrap line of right edge
set display=lastline            " show lastline as much as possible
set laststatus=2                " show statusline always
set showtabline=2               " show tabline always
set textwidth=0                 " disable automaticaclly line break
set shortmess& shortmess+=I     " no launch message
set hidden                      " hide buffer instead to remove modified buffer
set confirm                     " show confirm dialog instead of error
set backspace=indent,eol,start  " can be deleted these characters for backspace
set cmdheight=2                 " command line height
set noequalalways               " disable automatical adjust window size
set autoindent                  " enable auto indent
set smartindent                 " enable smart indent
set cinoptions=:0,l1,g0,m1      " indent option for C/C++
set switchbuf=split,newtab      " switch buffer option
"set tabline=%!MakeTabLine()     " tabline string
set helpheight=0                " min height of help
set helplang=ja                 " help language priority
set pumheight=10                " max height of popup menu
set previewheight=5             " height of preview window
set cmdwinheight=5              " height of cmdwindow
set cpoptions& cpoptions+=n     " use number column for wrapped line
set showmatch                   " jump to match pair temporarily
set matchtime=1                 " time (0.1 sec) to jump match pair
set virtualedit=block           " virtual edit for visual block mode only
set matchpairs& matchpairs+=<:> " add pair <>
set winaltkeys=no               " not use Alt key for GUI menu
set path& path+=;/              " file path follows parent directory
set complete& complete-=t,i     " remove 'include, tag' from completion candidates
set completeopt=menuone,preview " option of completion
set showfulltag                 " show tag pattern when tag completion
set timeout                     " enable timeout of key mappings
set timeoutlen=3000             " wait time(ms) of key mappings
set selectmode=                 " not use select mode
set selection=inclusive         " last character of selection is included in operation
set scrolloff=2                 " offset around cursor in vertical scroll
set sidescroll=1                " steps of horizontal scroll
set sidescrolloff=1             " offset around cursor in horizontal scroll
set colorcolumn=81              " highlight column at 81
"set ambiwidth=double            " show wide character as twice as half character

" formatoptions setting
" when joining lines, don't insert a space between multi-byte characters
set formatoptions& formatoptions+=B
if v:version >= 704
    " when joining lines, remove a comment leader
    set formatoptions+=j
endif

" keep column as much as possible in the vertical movement
" (<C-d>, <C-u>, ...)
set nostartofline

" enable extend command line complete and setting
set wildmenu
set wildmode=longest,full

" non-printable characters display settings
" when enable unicode, use unicode character
set list
if &encoding =~? '^utf-\=8$'
    " tab: '￫   ', trailing space: '˽', extends: '»', precedes: '«'
    let &listchars="tab:\uffeb\ ,trail:\u02fd,extends:\u00bb,precedes:\u00ab"
else
    set listchars=tab:>\ ,trail:_,extends:>,precedes:<
endif

" width of number column
" and wrapped line head string which adjust according to numberwidth
" head: ' »»'
autocmd MyAutocmd BufEnter *
    \ let &l:numberwidth = len(line('$')) + 2
    \ | let &showbreak = "\u00bb\u00bb" . repeat(' ', len(line('$')))

" tab, indent options
set tabstop=4           " tab width to display
set expandtab           " tab expanding
set shiftwidth=4        " indent width
set softtabstop=4       " width when enter <Tab> or <BS>

" searching options
set incsearch           " enable incremental search
set hlsearch            " enable highlight the searched
nohlsearch              " turn off highlight temporarily
set ignorecase          " ignore case
set smartcase           " ignore case unless searching pattern include upper case
set wrapscan            " back for the first line when go to the end line
set grepprg=grep\ -nH   " grep command

" folding options
set foldenable          " enable folding
set foldcolumn=0        " width of folding indicate column
set foldmethod=marker   " fold using marker
set foldlevelstart=99   " all folding is opened when opening new buffer

" setting of title string
"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:~:h\")})%)%(\ %a%)%(\ -\ %{v:servername}%)

" use mouse
if has('mouse')
    set mouse=a
endif

" backup options
set writebackup                                 " create backup before file writing,
set nobackup                                    " but not keep
let &backupdir = '.,' . $DOTVIM . '/.backup'    " backup file directory list
set backupskip& backupskip+=*~                  " pattern list if not created the backup
if &backup && !isdirectory($DOTVIM . '/.backup')
    call mkdir($DOTVIM . '/.backup')            " create backup directory if not exist
endif

" swapfile options
set swapfile            " create swapfile
set directory-=.        " remove current directory from swapfile directory list

" undofile options
set undofile                        " create undofile
let &undodir = $DOTVIM . '/.undo'   " undofile directory
if !isdirectory(&undodir)
    call mkdir($DOTVIM . '/.undo')  " create undofile directory if not exist
endif

" matchit extension
runtime macros/matchit.vim


" User Commands:

" reopen with change encoding
command! -bang -bar -nargs=? -complete=file Utf8
    \ edit<bang> ++enc=utf-8 <args>
command! -bang -bar -nargs=? -complete=file Cp932
    \ edit<bang> ++enc=cp932 <args>
command! -bang -bar -nargs=? -complete=file Euc
    \ edit<bang> ++enc=euc-jp <args>
command! -bang -bar -nargs=? -complete=file Iso2022jp
    \ edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -nargs=? -complete=file Utf16
    \ edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -nargs=? -complete=file Utf16be
    \ edit<bang> ++enc=ucs-2 <args>

" aliases
command! -bang -bar -nargs=? -complete=file Jis
    \ Iso2022jp<bang> <args>
command! -bang -bar -nargs=? -complete=file Sjis
    \ Cp932<bang> <args>
command! -bang -bar -nargs=? -complete=file Unicode
    \ Utf16<bang> <args>

" Diff
command! -nargs=? -complete=file Diff
    \ if '<args>'=='' |
        \ browse vertical diffsplit |
    \ else |
        \ vertical diffsplit <args> |
    \ endif

" diff between loaded from this
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif

" help with tabpage
" with '!' force create tabpage
command! -bang -bar -nargs=? -complete=help Help
    \ call s:help_with_tabpage('help', <q-args>, <q-bang>)
" helpgrep (use location list) with tabpage
command! -bang -bar -nargs=? -complete=help HelpGrep
    \ call s:help_with_tabpage('lhelpgrep', <q-args>, <q-bang>)

" abbreviations for the above Help commands
cnoreabbrev h Help
cnoreabbrev hg HelpGrep

" open help with tabpage
" to use for the above commands
function! s:help_with_tabpage(cmd, word, bang) abort
    " save the current tabpage
    let cur_tab_nr = tabpagenr()
    let tab_nr = 0

    try
        if empty(a:bang)
            let tab_nr = s:search_help_tab()
        endif
        call s:execute_with_tabpage(a:cmd . ' ' . a:word, tab_nr)

    catch /^Vim(help):/
        " if error occured, back to tabpage
        execute 'tabnext ' . cur_tab_nr
        echoerr matchstr(v:exception, 'Vim(help):\zs.*$')
    endtry
endfunction

" search tabpage number which include help buffer
" return found first tabpage number
" or return 0 if not found
function! s:search_help_tab() abort
    for tab_nr in range(tabpagenr('$'))
        for buf_nr in tabpagebuflist(tab_nr + 1)
            if getbufvar(buf_nr, '&l:buftype') == 'help'
                return tab_nr + 1
            endif
        endfor
    endfor

    " not found when if reached
    return 0
endfunction

" execute command with tabpage
" if a:tab_nr is not 0 then open at this tabpage
" else open new tab and execute command
function! s:execute_with_tabpage(cmd, tab_nr)
    if a:tab_nr != 0
        execute join(['tabnext', a:tab_nr, '|', a:cmd])
    else
        execute 'tab ' . a:cmd
    endif
endfunction

" capture the messages such as :messages
command! -nargs=+ -complete=command Capture call s:CmdCapture(<q-args>)
function! s:CmdCapture(args) "{{{
    " redirect of commands
    redir => result
    silent execute a:args
    redir END

    " view on the new buffer with set specially options
    new
    setlocal bufhidden=unload
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal noswapfile
    let b:title = '[Capture: ' . a:args . ']'
    "silent file `='[Capture ('' . a:args . '')]'`
    silent put =result
    1,2delete _
    " press q with close window
    nnoremap <buffer> <silent> q :<C-u>close<CR>
endfunction "}}}

" Autocommands:
augroup MyAutocmd

    " close window with q
    autocmd FileType help,ref-*,qf nnoremap <buffer> <silent> q :<C-u>close<CR>

    " no backups when edit git commit message
    autocmd FileType gitcommit setlocal nobackup noundofile noswapfile

    " open as read-only if exist swapfile
    autocmd SwapExists * let v:swapchoice = 'o' |
        \ call confirm('Exists the swapfile for "' . expand('%') . "\".\n
            \ Open it as read-only.")

    " recover cursor position
    autocmd BufRead *
        \ if line('''"') > 1 && line('''"') <= line('$') |
            \ execute 'normal! g`"zz' |
        \ endif

    " do buffer local the previous search pattern and hightlight
    autocmd WinLeave *
        \ let b:prev_pattern = @/
        \ | let b:prev_hlsearch = &hlsearch
    autocmd WinEnter *
        \ let @/ = get(b:, 'prev_pattern', @/)
        \ | let &l:hlsearch = get(b:, 'prev_hlsearch', &l:hlsearch)
        \ | nohlsearch

augroup END

" Key Mappings:

" prefix
nmap        <Space>         [Space]
xmap        <Space>         [Space]
nnoremap    [Space]         <Nop>
xnoremap    [Space]         <Nop>

" has disabled
nnoremap Q <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" j, k mapping exchanges
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk
nnoremap gj j
xnoremap gj j
nnoremap gk k
xnoremap gk k

" turn off the highlight temporarily
nnoremap [Space]<Space> :<C-u>nohlsearch<CR>

" go to begin/end of line
nnoremap gh g0
xnoremap gh g0
onoremap gh 0
nnoremap gl g$
xnoremap gl g$
onoremap gl $

" grep
nnoremap gr :<C-u>lgrep <C-r><C-w> *
xnoremap gr :<C-u>lgrep <C-r>=<SID>get_selected()<CR> *

" 'Y' works between cursor and eol like 'D'
nnoremap Y y$

" put text no change the latest yanked on visual mode
xnoremap p "0p<CR>

" replace <cword> with yanked
" (by Vim テクニックバイブル:4-6; tiny edited to search and repeat)
" use operator-replace when visual mode
nnoremap <silent> cy ce<C-r>0<Esc>:let@/=getreg()<CR>:noh<CR>
nnoremap <silent> ciy ciw<C-r>0<Esc>:let@/=getreg()<CR>:noh<CR>

" keep visual mode after indented
xnoremap < <gv
xnoremap > >gv

" search <cword> with split window
nnoremap <C-w>*  <C-w>s*
nnoremap <C-w>#  <C-w>s#

" preview tags if it is more candidates
nnoremap <C-]> g<C-]>

" reverse <C-t> (jump to new entry of tagstack)
nnoremap g<C-t>  :<C-u>tag<CR>

" increment/decrement number
nnoremap + <C-a>
xnoremap + <C-a>
xnoremap g+ g<C-a>
nnoremap - <C-x>
xnoremap - <C-x>
xnoremap g- g<C-x>

" view the help for <cword>
nnoremap <silent> <F1> :<C-u>Help <C-r><C-w><CR>
xnoremap <silent> <F1> :<C-u>Help <C-r>=<SID>get_selected()<CR><CR>

" change directory at the buffer file
nnoremap <F2> :<C-u>cd %:p:h<Bar>echo 'cd :' expand('%:p:h')<CR>

" view directory at the buffer file
nnoremap <F3> :<C-u>echo expand('%:p:h')<CR>

" redraw window
nnoremap <F5> <C-l>

" go to specified line if count is exist
" else turn off search highlight temporarily
nnoremap <silent><expr> <CR> <SID>cr_behavior()
function! s:cr_behavior() "{{{
    if v:count == 0
        return ":\<C-u>nohlsearch\<CR>"
    else
        return ":\<C-u>normal! " . string(v:count) . "Gzz\<CR>"
    endif
    return ""
endfunction "}}}
" when in quickfix, use default behavior
autocmd MyAutocmd FileType qf nnoremap <buffer> <CR> <CR>

" tabpage
nnoremap <C-l> gt
nnoremap <C-h> gT
"nnoremap <C-t> :<C-u>tabedit<Space>
nnoremap <silent> <C-Right> :<C-u>tabmove +1<CR>
nnoremap <silent> <C-Left> :<C-u>tabmove -1<CR>
nnoremap <silent> Q :<C-u>tabclose<CR>
nnoremap <silent> <C-Tab> :<C-u>TabRecent<CR>

" open .vimrc / .gvimrc quickly
nnoremap <silent> [Space]v :<C-u>edit $MYVIMRC<CR>
"nnoremap <silent> [Space]gv :<C-u>edit $MYGVIMRC<CR>

" source current buffer file
nnoremap <silent> [Space]<CR> :<C-u>echo 'sourcing...'<bar>so %<bar>do FileType<CR>

" textobj mappings
" 'quote'
onoremap aq  a'
xnoremap aq  a'
onoremap iq  i'
xnoremap iq  i'

" "double quote"
onoremap ad  a"
xnoremap ad  a"
onoremap id  i"
xnoremap id  i"

