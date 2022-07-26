" vim: set foldmethod=marker:

"----------------------------------------------------------
" ENV setttings {{{1
"----------------------------------------------------------
"
" The function needs to be near the top since it has to be known for later use
" Sets only once the value of g:env to the running environment
function! ConfigSetEnv() abort
    if exists('g:env')
        return
    endif
    if has('win64') || has('win32') || has('win16')
        let g:env = 'WINDOWS'
    else
       let g:env = toupper(substitute(system('uname'), '\n', '', ''))
    endif
endfunction

call ConfigSetEnv()

" neovim python paths
let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'

"----------------------------------------------------------
" General {{{1
"----------------------------------------------------------
if !(has('nvim'))
    set nocompatible  " be iMproved, required
endif

filetype off  " required

"----------------------------------------------------------
" Plugins {{{1
"----------------------------------------------------------
" plug vim-plug if needed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs 
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
" - Make sure you use single quotes
call plug#begin('~/.local/share/nvim/plugged')

" color schemes
Plug 'KeitaNakamura/neodark.vim'

" git plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" fzf
" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  " Both options are optional. You don't have to install fzf in ~/.fzf
  " and you don't have to run the install script if you use fzf only in Vim.
Plug 'junegunn/fzf.vim'

" editorconfig
Plug 'editorconfig/editorconfig-vim'

" cpp plugins
Plug 'vim-scripts/a.vim'

" python plugins
Plug 'Vimjas/vim-python-pep8-indent'

" comments
Plug 'tpope/vim-commentary'

" tree-sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " update parsers on plugin update

" Initialize plugin system
call plug#end()

"----------------------------------------------------------
" vim-plug helpers
"----------------------------------------------------------
function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction

"----------------------------------------------------------
" Customizations {{{1
"----------------------------------------------------------
"----------------------------------------------------------
" Feels
"----------------------------------------------------------
" don't break long lines
set formatoptions-=tc
set nowrap

" more natural splits
set splitbelow
set splitright

" lines visible when scrolling
set scrolloff=3

"----------------------------------------------------------
" Looks
"----------------------------------------------------------

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    set termguicolors
endif

if !has('nvim')
    set background=dark
endif

" colorscheme
colorscheme neodark

"----------------------------------------------------------
" General
"----------------------------------------------------------
" vim specific (nvim defaults)
if !(has('nvim'))
    " When opening a new line and no filetype-specific indenting is enabled, keep
    " the same indent as the line you're currently on. Useful for READMEs, etc.
    set autoindent

    " Highlight searches (use <C-L> to temporarily turn off highlighting)
    set hlsearch

    " Dynaimc search
    set incsearch

    " Display the cursor position on the last line of the screen or in the status
    " line of a window
    set ruler

    " Better command-line completion
    set wildmenu

    " Enable syntax highlighting
    syntax enable
endif

" filetype options
filetype indent plugin on

" hide windows (instead of close when they lose focus)
set hidden

" hide diff when winbdow lose focus
set diffopt+=hiddenoff

" Show partial commands in the last line of the screen
set showcmd

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
 
" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
 
" Always display the status line, even if only one window is displayed
set laststatus=2

" Always disaply tabline
" set showtabline=2
 
" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm
 
" Use visual bell instead of beeping when doing something wrong
set visualbell
 
" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=
 
" Enable use of the mouse for all modes
set mouse=a
 
" Display line numbers on the left
set number
 
" relative line numbers
set relativenumber

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
 
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" highlight currentline
set cursorline
highlight CursorLine guibg=#323940
set colorcolumn=120

" cmdline height
" set cmdheight=2

" tags files
set tags=./tags;,tags;

" don't use cscope in tags
" set nocscopetag

" consistent visual selection highlight
highlight Visual term=reverse cterm=reverse

" search highlight colors
highlight Search guibg=peru guifg=wheat

" interactive substitute command
if (has('nvim'))
    set inccommand=nosplit
endif

"----------------------------------------------------------
" global indentation options
"----------------------------------------------------------
set shiftwidth=4
set softtabstop=4
set expandtab

" c/cpp long arg indentation
set cino=(0

"----------------------------------------------------------
" General custom mappings
"----------------------------------------------------------
" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$
 
" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" multi paste form buffer in visual mode
xnoremap <silent> p p:if v:register == '"'<Bar>let @@=@0<Bar>endif<cr>

" copy current buffer path to clipboard
nnoremap <leader>c :let @+ = expand("%")<cr>

" count match of last search
map ,* *<C-O>:%s///gn<CR>

" yank file contents to system clipboard
nnoremap <leader>Y :%y+<CR>

" open tag under cursor in vertical split
nnoremap <silent> <c-w>] :vert winc ]<cr>

"----------------------------------------------------------
" General custom commands
"----------------------------------------------------------
" Tag current dir
command! CTags !ctags -R
  \ --exclude='build*' --exclude='venv/**' --exclude='**/site-packages/**' 
  \ --exclude='dist/**' --exclude='*.json' --python-kinds=-i *

" Hnadle trailing white spaces
function! ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function! TrimSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

command! -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command! -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()

"----------------------------------------------------------
" clipborad settings
"----------------------------------------------------------
if (g:env =~# 'DARWIN')
    set clipboard=unnamed
endif

"----------------------------------------------------------
" netrw
"----------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20

" Toggle Vexplore with F9
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

nmap <silent> <F9> :call ToggleVExplorer()<CR>

"----------------------------------------------------------
" FZF
"----------------------------------------------------------
if executable('fzf')
    command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number '.shellescape(<q-args>), 0,
      \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

    nmap <silent> <leader>g :GGrep<CR>
    nmap <silent> <leader>F :GFiles<CR>
    nmap <silent> <leader>f :Files<CR>
    nmap <silent> <leader>t :Tags<CR>
    nmap <silent> <leader>b :Buffers<CR>
    nmap <silent> <leader>/ :BLines<CR>
    nmap <silent> <leader>C :Commands<cr>
    nmap <silent> <leader>H :History<cr>
    nmap <silent> <leader>p :Commits<cr>
endif

" preview window disabled
let g:fzf_preview_window = ''

"----------------------------------------------------------
" EditorConfig
"----------------------------------------------------------
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

"----------------------------------------------------------
" a.vim
"----------------------------------------------------------
nmap <silent> <leader>a :A<cr>
nmap <silent> <leader>A :AV<cr>

"----------------------------------------------------------
" nvim-treesitter
"----------------------------------------------------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "python", "lua", "bash", "json", "yaml"},
  highlight = {
    enable = true,
  },
}
EOF

"----------------------------------------------------------
" cscope
"----------------------------------------------------------
" taken from http://cscope.sourceforge.net/cscope_maps.vim
" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    " set cscopetag
    set nocscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=1

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out  
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose  

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout 
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout 
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

    " fzf integration from https://gist.github.com/amitab/cd051f1ea23c588109c6cfcb7d1d5776
    function! Cscope(option, query)
      let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
      let opts = {
      \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
      \ 'options': ['--ansi', '--prompt', '> ',
      \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
      \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
      \ 'down': '40%'
      \ }
      function! opts.sink(lines) 
        let data = split(a:lines)
        let file = split(data[0], ":")
        execute 'e ' . '+' . file[1] . ' ' . file[0]
      endfunction
      call fzf#run(opts)
    endfunction
    
    function! CscopeQuery(option)
      call inputsave()
      if a:option == '0'
        let query = input('Assignments to: ')
      elseif a:option == '1'
        let query = input('Functions calling: ')
      elseif a:option == '2'
        let query = input('Functions called by: ')
      elseif a:option == '3'
        let query = input('Egrep: ')
      elseif a:option == '4'
        let query = input('File: ')
      elseif a:option == '6'
        let query = input('Definition: ')
      elseif a:option == '7'
        let query = input('Files #including: ')
      elseif a:option == '8'
        let query = input('C Symbol: ')
      elseif a:option == '9'
        let query = input('Text: ')
      else
        echo "Invalid option!"
        return
      endif
      call inputrestore()
      if query != ""
        call Cscope(a:option, query)
      else
        echom "Cancelled Search!"
      endif
    endfunction
    
    nnoremap <silent> <Leader>ca :call Cscope('0', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>cc :call Cscope('1', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>cd :call Cscope('2', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>ce :call Cscope('3', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>cf :call Cscope('4', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>cg :call Cscope('6', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>ci :call Cscope('7', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>cs :call Cscope('8', expand('<cword>'))<CR>
    nnoremap <silent> <Leader>ct :call Cscope('9', expand('<cword>'))<CR>
    
    nnoremap <silent> <Leader><Leader>ca :call CscopeQuery('0')<CR>
    nnoremap <silent> <Leader><Leader>cc :call CscopeQuery('1')<CR>
    nnoremap <silent> <Leader><Leader>cd :call CscopeQuery('2')<CR>
    nnoremap <silent> <Leader><Leader>ce :call CscopeQuery('3')<CR>
    nnoremap <silent> <Leader><Leader>cf :call CscopeQuery('4')<CR>
    nnoremap <silent> <Leader><Leader>cg :call CscopeQuery('6')<CR>
    nnoremap <silent> <Leader><Leader>ci :call CscopeQuery('7')<CR>
    nnoremap <silent> <Leader><Leader>cs :call CscopeQuery('8')<CR>
    nnoremap <silent> <Leader><Leader>ct :call CscopeQuery('9')<CR>

endif

"----------------------------------------------------------
" Filetype customizations {{{1
"----------------------------------------------------------
"----------------------------------------------------------
" Dockerfile
"----------------------------------------------------------
augroup filetypedetect
au! BufRead,BufNewFile *Dockerfile* setfiletype dockerfile
augroup END

"----------------------------------------------------------
" SConstruct
"----------------------------------------------------------
augroup filetypedetect
au! BufRead,BufNewFile *SConstruct* setfiletype python
augroup END

"----------------------------------------------------------
" vproto
"----------------------------------------------------------
augroup filetypedetect
au! BufRead,BufNewFile *vproto setfiletype c
augroup END

