### Xtabline

![pic](https://i.imgur.com/SN6FNnA.gif)

    Introduction
    Features
    Requirements
    Installation
    Interaction with vim-airline
    Tab Buffers navigation
    Toggling
    Persistance
    Bookmarks
    TabTodo
    fzf commands
    Customization
    Warnings
    Credits
    License


#### Introduction

*This README won't be updated as often as the main help file. If you install
the plugin, refer to that one instead.*

XTabline is an extension for *vim-airline*

Its main purpose is to provide a way to filter buffers in the tabline,
depending on the current working directory. Since switching tabs without
switching the CWD would cause wrong buffers to be displayed in the tabline,
XTabline also remembers the CWD for each tab, so that when you switch them,
the CWD is automatically set to the last path that specific tab was set to.

    Eg. you have 2 tabs, you set a CWD with `:cd` in the second tab; switching
    to #1 would set back the old CWD. Switching back to #2 would set the path
    you defined for that tab.

Since each tab has its own CWD, XTabline filters the buffers to be shown on
it, to display only the buffers whose path is within the CWD for that tab.


---

#### Features List

With *Tab Buffer* is meant a buffer that is associated with a tab, because its
path is within that tab's CWD.

* Per project/tab buffers filtering in the tabline

* Per project/tab CWD persistance

* Toggle display of tabs/buffers

* Toggle buffer filtering on/off

* Tab buffers quick navigation (next, previous, with *[count]*)

* Tab bookmarks: save and reload a tab with all its buffers and its CWD

* Session management: load/save sessions, with timestamping and descroiptions

* Reopen last closed tab (with buffers and CWD)

* Tab-todo: customizable command to open a todo file for that tab

* *fzf-vim* integration:
    - open/delete multiple *Tab Buffers* at once.
    - access *Tab Bookmarks* or *NERDTreeBookmarks*.
    - session management

* *vim-obsession* support for CWDs persistance across sessions


---

#### Requirements

[vim-airline](https://github.com/vim-airline/vim-airline) is required.  
[vim-obsession](https://github.com/tpope/vim-obsession) is required for persistance.  
[fzf-vim](https://github.com/junegunn/fzf.vim) is required for bookmarks commands.  


---

#### Installation

Use [vim-plug](https://github.com/junegunn/vim-plug) or any other Vim plugin manager.

With vim-plug:

    Plug 'mg979/vim-xtabline'


---

#### Interaction With Airline

XTabline exploits the built-in Airline 'excludes' list to achieve buffer
filtering. In any case, you should have this enabled:

    let g:airline#extensions#tabline#enabled = 1


---

#### Mapping prefix

Most of |xtabline| mappings can be associated to a prefix. Default is:

    let g:xtabline_map_prefix = '<leader>X'

This means that most commands will be mapped to \<leader>X + a modifier.
You can change the prefix and all mappings will be changed accordingly.


---

#### Tab Buffers Navigation

If you use the normal *:bnext* command, you still cycle among the default
(global) buffer list. If that buffer doesn't 'belong' to that tab, because its
path is outside the current CWD, the buffer will be loaded, but it won't be
shown in the tabline. Only the buffers that are relevant to that tab will be
shown there.

There are new commands that allow you to cycle *Tab Buffers*; these commands
also work when in *tabs mode* (see 'xtabline-toggle' ).

|Mapping                          | Default|
|---------------------------------|------------------------------------------|
|\<Plug>XTablineSelectBuffer       | [count]\<leader>l|
|\<Plug>XTablineNextBuffer         | \<S-PageDown>|
|\<Plug>XTablinePrevBuffer         | \<S-PageUp>|
|\<Plug>XTablineCloseBuffer        | \<prefix\>q|

*XTablineNextBuffer* and *XTablinePrevBuffer* accept a [count], to move to ±[N]
buffer, as they are shown in the tabline. If moving beyond the limit, it
will start from the start (or the end).

*XTablineSelectBuffer* works this way:

* it needs a *[count]* to work, eg. 2\<leader>l would bring you to buffer #2
* when not using a *[count]*, it will execute a command of your choice

Define this command by setting the *g:xtabline_alt_action* variable.
Default is `buffer #`

Examples:

    let g:xtabline_alt_action = "buffer #"    (switch to alternative buffer)
    let g:xtabline_alt_action = "Buffers"     (call fzf-vim :Buffers command)

*XTablineCloseBuffer* will close and delete the current buffer, but it will
not try to close the tab page, unless _g:xtabline_close_buffer_can_close_tab_
is set to 1.

---

#### Toggling Options

You can toggle both between tabs and buffers, and buffers filtering on and off
(going back to default behaviour). Default mappings are:

|Mapping                          | Default     |
|---------------------------------|------------------------------------------|
|\<Plug>XTablineToggleTabs         | \<F5>|
|\<Plug>XTablineToggleBuffers      | \<leader>\<F5>|



---

#### Persistance

If you use *vim-obsession* your tabs CWDs will be remembered inside a session
that is currently tracked. It's an automatic process and you don't need to do
or set anything.

 
---

#### Session Management

Both _vim-obsession_ and _fzf-vim_ are required.

|Command               |Mapping                          | Default     |
|----------------------|---------------------------------|-------------|
|XTabSessionLoad       |\<Plug>XTablineSessionLoad       | \<prefix\>L  |
|XTabSessionSave       |\<Plug>XTablineSessionSave       | \<prefix\>S  |

Both commands operate on sessions found in the specified directory. Default:

  let g:xtabline_sessions_path = '$HOME/.vim/session'

When saving sessions, you can add a description, that defaults to the current
one. Descriptions are saved in `$HOME/.vim/.XTablineSessions`.

When loading sessions, the last modification date will be shown, along with
the description and the symbol `[%]` that marks the active session (if any).



---

#### Options summary

You can add any of these to your *.vimrc*

|Option                           | Effect (defalult) |
|---------------------------------|----------------|
|g:xtabline_disable_keybindings      | (0)        |
|g:xtabline_cd_commands              | enable CWD selection commands (0)   |
|g:xtabline_autodelete_empty_buffers | remove empty unsaved buffers (0)    |
|g:xtabline_include_previews         | display fugitive logs buffers (1)   |
|g:xtabline_alt_action               | SelectBuffer alternative command    |
|g:xtabline_todo                     | todo command customization          |
|g:xtabline_sessions_path            | sessions directory                  |

---

#### Commands

Many of these commands require *fzf-vim*.
With most of them you can select multiple items by pressing `<Tab>`.
Default mappings are meant prefixed by `<leader>`. Personally I use lowercase
mappings for quicker access, but default mappings have uppercase X to lower
chance of conflicts.

|Command                | fzf | Map | Effect                                    |
|-----------------------|-----|-----|-------------------------------------------|
|XTabReopen             |  N  |  Xr | Reopen last closed tab|
|XTabRestrictCwd        |  N  |  R  | Restrict filtering to root directory only|
|XTabPurge              |  N  |  Xp | Purge orphaned buffers/previews|
|XTabBuffersOpen        |  Y  |  Xx | Open a list of *Tab Buffers* to choose from|
|XTabBuffersDelete      |  Y  |  Xd | Same list, but use `bdelete` command on them|
|XTabAllBuffersDelete   |  Y  |  XD | `bdelete`, but choose from the global buffers list|
|XTabBookmarksLoad      |  Y  |  Xl | Open the *Tab Bookmarks* list|
|XTabBookmarksSave      |  Y  |  Xs | Save the current tab as a bookmark (custom naming)|
|XTabNERDBookmarks      |  Y  |     | Open the list of *NERDTreeBookmarks*|


---

#### Purge Buffers

This command is handy to close all buffers that aren't bound to a physical
file (such vim-fugitive logs, vim-gitgutter previews, quickfix windows etc).
If the only window in the tab is going to be closed, the buffer switches
to the first tab buffer, so that you won't lose the tab.

Default mapping: `<prefix>p`



---

#### Tab-Todo

This command opens a todo file at the tab's CWD. Default mapping is <leader>TT

If you change the following options, make sure that both of them appear in
your *.vimrc* file.

You can define the filename (include the directory separator!):

    let g:xtabline_todo_file = "/.TODO"

And you can define other options:
```vim
    let g:xtabline_todo = {'path': getcwd().g:xtabline_todo_file,
                         \ 'command': 'sp', 'prefix': 'below',
                         \ 'size': 20, 'syntax': 'markdown'}
```
__*path*__    : you shouldn't change this, only change *g:xtabline_todo_file*
__*command*__ : can be `sp`, `vs`, `edit`, etc.
__*prefix*__  : will influence where the window appears (check `opening-window` for help)
__*size*__    : the height/width of the window
__*syntax*__  : the syntax that will be loaded

---

#### Cwd selection

Disabled by default, you can enable them by setting:

    let g:xtabline_cd_commands = 1

These commands allow you to quickly change your tab CWD, and update the
tabline at the same time.

|Mapping                          | Default        |
|---------------------------------|----------------|
|\<Plug>XTablineCdCurrent         | \<leader>cdc   |
|\<Plug>XTablineCdDown1           | \<leader>cdd   |
|\<Plug>XTablineCdDown2           | \<leader>cd2   |
|\<Plug>XTablineCdDown3           | \<leader>cd3   |
|\<Plug>XTablineCdHome            | \<leader>cdh   |
|\<Plug>XTablineRestrictCwd       | \<leader>cdr   |



#### Restrict Cwd

Run this command to temporarily restrict filter buffering to the files at the
root of the current cwd, ignoring not only the files that are outside of it,
but also the ones in subdirectories. This option is toggled on a per-tab basis
and is not persistent across sessions.

Default mapping: `<prefix>R`



#### Customization

To prevent previews (eg. vim-fugitive logs) from being displayed, add:

    let g:xtabline_include_previews = 0

(You'll still be able to purge them with XTabPurge)

You can remap commands individually. These are the customizable options with
their defaults. You can copy this section to your |.vimrc| and change the
values to ones you prefer.


```vim
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " xtabline
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    nmap <F5>             <Plug>XTablineToggleTabs
    nmap <leader><F5>     <Plug>XTablineToggleBuffers
    nmap <leader>l        <Plug>XTablineSelectBuffer
    nmap <S-PageDown>     <Plug>XTablineNextBuffer
    nmap <S-PageUp>       <Plug>XTablinePrevBuffer
    nmap {prefix}x        <Plug>XTablineBuffersOpen
    nmap {prefix}d        <Plug>XTablineBuffersDelete
    nmap {prefix}D        <Plug>XTablineAllBuffersDelete
    nmap {prefix}r        <Plug>XTablineReopen
    nmap {prefix}p        <Plug>XTablinePurge
    nmap {prefix}l        <Plug>XTablineBookmarksLoad
    nmap {prefix}s        <Plug>XTablineBookmarksSave
    nmap {prefix}L        <Plug>XTablineSessionLoad
    nmap {prefix}S        <Plug>XTablineSessionSave
    nmap {prefix}tt       <Plug>XTablineTabTodo

    let g:xtabline_map_prefix    = '<leader>X'
    let g:xtabline_alt_action    = "buffer #"

    let g:xtabline_bookmaks_file = expand('$HOME/.vim/.XTablineBookmarks')
    let g:xtabline_sessions_path = '$HOME/.vim/session'

    let g:xtabline_todo_file     = "/.TODO"
    let g:xtabline_todo          = {'path': getcwd().g:xtabline_todo_file, 'command': 'sp', 'prefix': 'below', 'size': 20, 'syntax': 'markdown'}

```


---

#### Credits

Braam Moolenaar for Vim  
[vim-airline](https://github.com/vim-airline/vim-airline) authors  
Junegunn Choi for [fzf-vim](https://github.com/junegunn/fzf.vim)  
Tim Pope for [vim-obsession](https://github.com/tpope/vim-obsession)  
Kana Natsuno for [tabpagecd](https://github.com/kana/vim-tabpagecd)  


---

#### License

MIT

