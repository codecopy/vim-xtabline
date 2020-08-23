let s:save_cpo = &cpo
set cpo&vim

"------------------------------------------------------------------------------

if exists("g:loaded_xtabline")
  finish
endif

silent! call XtablineStarted()

fun! xtabline#init#start() abort
  let g:loaded_xtabline = 1
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

com!                  XTabListBuffers         call xtabline#fzf#list_buffers()
com!                  XTabListTabs            call xtabline#fzf#list_tabs()
com!                  XTabDeleteBuffers       call xtabline#fzf#delete_buffers()
com!                  XTabLoadSession         call xtabline#fzf#load_session()
com!                  XTabDeleteSession       call xtabline#fzf#delete_session()
com!                  XTabLoadTab             call xtabline#fzf#load_tab()
com!                  XTabDeleteTab           call xtabline#fzf#delete_tab()
com!                  XTabNERDBookmarks       call xtabline#fzf#nerd_bookmarks()
com!                  XTabSaveTab             call xtabline#fzf#tab_save()
com!                  XTabSaveSession         call xtabline#fzf#session_save(0)
com!                  XTabNewSession          call xtabline#fzf#session_save(1)
com!                  XTabReopenList          call xtabline#fzf#closed_tabs()

com!                  XTabTodo                call xtabline#cmds#run('tab_todo')
com!                  XTabPurge               call xtabline#cmds#run('purge_buffers')
com!                  XTabReopen              call xtabline#cmds#run('reopen_last_tab')
com!                  XTabCloseBuffer         call xtabline#cmds#run('close_buffer')
com! -bang            XTabCleanUp             call xtabline#cmds#run('clean_up', <bang>0)
com! -nargs=1         XTabNameTab             call xtabline#cmds#run("name_tab", <q-args>)
com! -nargs=1         XTabNameBuffer          call xtabline#cmds#run("name_buffer", <q-args>)
com!                  XTabResetTab            call xtabline#cmds#run("reset_tab")
com!                  XTabResetBuffer         call xtabline#cmds#run("reset_buffer")
com!                  XTabResetAll            call xtabline#cmds#run("reset_all")
com! -nargs=? -bang   XTabPaths               call xtabline#cmds#run("paths_style", <bang>0, <q-args>)
com!                  XTabToggleLabels        call xtabline#cmds#run("toggle_tab_names")
com!                  XTabLock                call xtabline#cmds#run("lock_tab")
com! -nargs=?         XTabPinBuffer           call xtabline#cmds#run("toggle_pin_buffer", <q-args>)
com!                  XTabFiltering           call xtabline#cmds#run("toggle_filtering")

com!                  XTabMenu                call xtabline#maps#menu()
com!                  XTabLast                call xtabline#cmds#run('goto_last_tab')

com! -count           XTabNextBuffer          call xtabline#cmds#next_buffer(<count>, 0)
com! -count           XTabPrevBuffer          call xtabline#cmds#prev_buffer(<count>, 0)
com!                  XTabLastBuffer          call xtabline#cmds#next_buffer(1, 1)
com!                  XTabFirstBuffer         call xtabline#cmds#prev_buffer(1, 1)
com! -count           XTabMoveBufferNext      call xtabline#cmds#run('move_buffer', 1, <count>)
com! -count           XTabMoveBufferPrev      call xtabline#cmds#run('move_buffer', 0, <count>)
com! -count           XTabMoveBuffer          call xtabline#cmds#run('move_buffer_to', <count>)
com! -count           XTabHideBuffer          call xtabline#cmds#run('hide_buffer', <count>)
com!                  XTabLastTab             call xtabline#cmds#run('goto_last_tab')
com!                  XTabInfo                call xtabline#dir#info()
com!                  XTablineUpdate          call xtabline#update()

com! -nargs=? -bang  -complete=dir                   XTabCD              call xtabline#dir#cd(<q-args>, <bang>0)
com! -nargs=? -bang  -complete=dir                   XTabWD              call xtabline#dir#set('working', <bang>0, <q-args>)
com! -nargs=? -bang  -complete=dir                   XTabLD              call xtabline#dir#set('window-local', <bang>0, <q-args>)
com! -nargs=? -bang  -complete=customlist,<sid>icons XTabIconTab         call xtabline#cmds#run("tab_icon", <bang>0, <q-args>)
com! -nargs=? -bang  -complete=customlist,<sid>icons XTabIconBuffer      call xtabline#cmds#run("buffer_icon", <bang>0, <q-args>)
com! -nargs=? -bang  -complete=customlist,<sid>theme XTabTheme           call xtabline#hi#load_theme(<bang>0, <q-args>)
com! -nargs=?        -complete=customlist,<sid>mode  XTabMode            call xtabline#cmds#run("change_mode", <q-args>)

if exists(':tcd') == 2
  com! -nargs=? -bang  -complete=file XTabTD call xtabline#dir#set('tab-local', <bang>0, <q-args>)
endif

fun! s:icons(A,L,P) abort
  " Icons completions for commands.
  return filter(keys(g:xtabline_settings.icons), 'v:val=~#a:A')
endfun

fun! s:theme(A,L,P) abort
  " Theme names completion.
  return filter(xtabline#themes#list(), 'v:val=~#a:A')
endfun

fun! s:mode(A,L,P) abort
  " Tabline mode completion.
  if len(map(argv(), 'bufnr(v:val)'))
    let modes = ['tabs', 'buffers', 'arglist']
  else
    let modes = ['tabs', 'buffers']
  endif
  return filter(modes, 'v:val=~#a:A')
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variables
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:xtabline = {'Tabs': [], 'Vars': {}, 'Buffers': {}, 'Funcs': {},
                 \'pinned_buffers': [], 'closed_tabs': [],
                 \'_buffers': {}, 'last_tabline': ''}

let g:xtabline.Vars = {
      \'winOS': has("win16") || has("win32") || has("win64"),
      \}

let g:xtabline_highlight = get(g:, 'xtabline_highlight', {'themes': {}})

let s:S = {
      \ 'enabled':                    1,
      \ 'map_prefix' :                '<leader>x',
      \ 'tabline_modes':              ['tabs', 'buffers', 'arglist'],
      \ 'select_buffer_alt_action':   "buffer #",
      \ 'buffer_filtering':           1,
      \ 'wd_type_indicator':          0,
      \ 'theme':                      'default',
      \ 'show_right_corner':          1,
      \ 'tab_number_in_buffers_mode': 1,
      \ 'last_open_first':            0,
      \ 'enable_mappings':            1,
      \ 'no_icons':                   0,
      \ 'special_tabs':               0,
      \ 'buffers_paths':              1,
      \ 'current_tab_paths':          1,
      \ 'other_tabs_paths':           1,
      \ 'buffer_format':              2,
      \ 'recent_buffers':             10,
      \ 'unnamed_label':             '...',
      \ 'scratch_label':            '[Scratch]',
      \ 'tab_icon':                   ["📂", "📁"],
      \}


let s:S.indicators = {
      \ 'modified': s:S.no_icons ? '[+]'  : '*',
      \ 'readonly': s:S.no_icons ? '[RO]' : '🔒',
      \ 'scratch': s:S.no_icons ?  '[!]'  : '✓',
      \ 'pinned': s:S.no_icons ?   '[^]'  : '[📌]',
      \}


let s:datadir = has('nvim') ? expand(stdpath('data'))
      \      : !has('win32unix') && !has('win32') ? '$HOME/.vim'
      \      : isdirectory(expand('$HOME/vimfiles')) ? '$HOME/vimfiles' : '$HOME/.vim'

let s:S.sessions_path  = expand(s:datadir . '/session')
let s:S.sessions_data  = expand(s:datadir . '/.XTablineSessions')
let s:S.bookmarks_file = expand(s:datadir . '/.XTablineBookmarks')

let g:xtabline_settings  = extend(s:S, get(g:, 'xtabline_settings', {}))
let g:xtabline.Vars.tabline_mode = g:xtabline_settings.tabline_modes[0]
let g:xtabline.Vars.was_tab_mode = g:xtabline.Vars.tabline_mode == 'tabs'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Icons
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:xtabline_settings.icons = extend({
      \'pin':     '📌',     'star':    '★',     'book':    '📖',     'lock':    '🔒',
      \'hammer':  '🔨',     'tick':    '✔',     'cross':   '✖',      'warning': '⚠',
      \'menu':    '☰',      'apple':   '🍎',    'linux':   '🐧',     'windows': '❖',
      \'git':     '',      'git2':    '⎇ ',    'palette': '🎨',     'lens':    '🔍',
      \'flag':    '⚑',      'flag2':   '🏁',    'fire':    '🔥',     'bomb':    '💣',
      \'home':    '🏠',     'mail':    '✉ ',    'netrw':   '🖪 ',     'arrow':   '➤',
      \'terminal':'',
      \}, get(g:xtabline_settings, 'icons', {}))

" \'folder_open': '📂',
" \'folder_closed': '📁',

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TabTodo settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:xtabline_settings.todo = extend({
      \"command": 'sp',
      \"prefix":  'below',
      \"file":    ".TODO",
      \"size":    20,
      \"syntax":  'markdown',
      \}, get(g:xtabline_settings, 'todo', {}))

if !filereadable(g:xtabline_settings.bookmarks_file) | call writefile(['{}'], g:xtabline_settings.bookmarks_file) | endif
if !filereadable(g:xtabline_settings.sessions_data) | call writefile(['{}'], g:xtabline_settings.sessions_data) | endif

if v:vim_did_enter
  call xtabline#hi#init()
else
  au VimEnter * call xtabline#hi#init()
endif

if get(g:, 'xtabline_lazy', 0)
  silent! autocmd! xtabline_lazy
  silent! augroup! xtabline_lazy
  delcommand XTablineInit
  call xtabline#init()
  silent! delfunction XtablineStarted
  doautocmd BufEnter
  unlet g:xtabline_lazy
endif

"------------------------------------------------------------------------------

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: et sw=2 ts=2 sts=2 fdm=indent
