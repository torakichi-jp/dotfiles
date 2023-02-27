scriptencoding utf-8

" init autocmd
augroup MyAutocmdGUI
    autocmd!
augroup END

" switching variables
let s:is_windows = has('win32') || has('win64')
let s:is_unix = has('unix')

set guioptions=mgtr             " gui menu, grayed menu, tearoff menu, right scroll bar
"set guioptions=                 " no GUI options
set browsedir=buffer            " browsing with current directry
"set nohlsearch                  " no search highlight
set cursorline                  " highlight the current line
set title                       " show title
"set mousefocus                 " window focus with mouse
"set mousemodel=popup_setpos    " 右クリックでカーソル移動＆メニュー表示
set ambiwidth=double            " show the wide character as twice as the half character
if s:is_windows && has('directx')
    " use the DirectX rendering
    set renderoptions=type:directx,renmode:5
endif

" transparency (kaoriya only)
" Note: must be autocmd
if exists('&transparency')
    if s:is_windows
        set transparency=215
        augroup MyAutocmd
            autocmd FocusGained * set transparency=215
            autocmd FocusLost * set transparency=180
        augroup END
    endif
endif

" メニューの表示切替
nnoremap <M-m> :<C-u>call <SID>toggle_menu()<CR>
function! s:toggle_menu()
    if &guioptions =~# 'm'
        set guioptions-=mgt
    else
        set guioptions+=mgt
    endif
endfunction

" カラースキーム
autocmd MyAutocmdGUI ColorScheme *
    \ if has('multi_byte_ime')
        \ | hi CursorIM guibg=#ff0000
    \ | endif

try
    colorscheme landscape
catch /^Vim(colorscheme):/
    colorscheme desert
endtry

" ビジュアルベル（使用しない）
set visualbell t_vb=

" 行数、列数、行間
" TODO: 環境に依存するので、ローカル設定ファイルに移動すべき？
set lines=32        " 行
set columns=99      " 列
set linespace=2     " 行間

" フォント設定
let fonts = []
if s:is_windows
    "call add(fonts, 'Ricty_NF:h12:cDEFAULT')
    "call add(fonts, 'Ricty_Diminished_for_Powerline:h12:cDEFAULT')
    call add(fonts, 'Cica:h12:cDEFAULT')
    call add(fonts, 'HackGen_Console_NFJ:h12:cDEFAULT')
    call add(fonts, 'ＭＳ_ゴシック:h12:cDEFAULT')
elseif s:is_unix
    call add(fonts, "Ricty\ for\ Powerline\ 12")
    call add(fonts, "UbuntuMono\ 11")
endif
let &guifont=join(fonts, ",")
unlet fonts


"*******************************************************************************
" Key Mappings:
"*******************************************************************************

" 保存
"nnoremap <C-s> :<C-u>update<CR>

" .gvimrc 編集
nnoremap <silent> <Space>gv :<C-u>edit $MYGVIMRC<CR>

" GUIウィンドウ最大化・元に戻す
nnoremap <silent> <M-x> :<C-u>ScreenMode 4<CR>
nnoremap <silent> <M-r> :<C-u>Revert<CR>

