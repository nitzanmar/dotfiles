" vim: set foldmethod=marker:
"----------------------------------------------------------
" ENV setttings {{{1
"----------------------------------------------------------
"
" The function needs to be near the top since it has to be known for later use
" Sets only once the value of g:env to the running environment
function! Config_setEnv() abort
    if exists('g:env')
        return
    endif
    if has('win64') || has('win32') || has('win16')
        let g:env = 'WINDOWS'
    else
       let g:env = toupper(substitute(system('uname'), '\n', '', ''))
    endif
endfunction

call Config_setEnv()

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
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
" - Make sure you use single quotes
call plug#begin('~/.vim/plugged')

" themes
Plug 'morhetz/gruvbox'

" fancy open screen
Plug 'mhinz/vim-startify'

" text objects
Plug 'vim-scripts/argtextobj.vim'
Plug 'michaeljsmith/vim-indent-object'

" git plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" vim-vinegar
Plug 'tpope/vim-vinegar'

" fzf
" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  " Both options are optional. You don't have to install fzf in ~/.fzf
  " and you don't have to run the install script if you use fzf only in Vim.
Plug 'junegunn/fzf.vim'

" filetypes
Plug 'sheerun/vim-polyglot'

" LSP - coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" tagbar
Plug 'majutsushi/tagbar'

" statusline plugins
Plug 'itchyny/lightline.vim'

" python plugins
Plug 'Vimjas/vim-python-pep8-indent'

" Dockerfile syntax
Plug 'moby/moby' , {'rtp': '/contrib/syntax/vim/'}

" tmux compatibility
Plug 'tmux-plugins/vim-tmux-focus-events'

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
"----------------------------------------------------------
" Customizations {{{1
"----------------------------------------------------------
"----------------------------------------------------------

"----------------------------------------------------------
" Feels
"----------------------------------------------------------
set nowrap

" more natural splits
set splitbelow
set splitright

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



" highlisht current line
highlight LineNr ctermfg=grey

" font
set guifont=Menlo\ Regular:h13

" colorscheme
colorscheme gruvbox 

" cmdline height
set cmdheight=2

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
 
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200
 
" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" vim complete lookup order
set complete=".,t,w,b,u,i"

"----------------------------------------------------------
" global indentation options
"----------------------------------------------------------
set shiftwidth=4
set softtabstop=4
set expandtab

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
nnoremap <leader>c :let @+ = expand("%:p")<cr>

" save/load session
map <F2> :mksession! ~/.vim_session <cr> " Quick write session with F2
map <F3> :source ~/.vim_session <cr>     " And load session with F3

" Toggle number line from off -> absolute -> hybrid relative num -> off
nnoremap <F1> :call ToggleNumLine()<CR>

function! ToggleNumLine()
  if !&l:number && !&l:relativenumber
    set number!
  elseif &l:number && &l:relativenumber
    set number!
    set relativenumber!
  elseif &l:number && !&l:relativenumber
    set relativenumber!
  endif
endfunc

" count match of last search
map ,* *<C-O>:%s///gn<CR>

"----------------------------------------------------------
" General custom commands
"----------------------------------------------------------
" Tag current dir
command! CTags !ctags -R
  \ --exclude='build*' --exclude='venv/**' --exclude='**/site-packages/**' 
  \ --exclude='dist/**' --exclude='*.json' *

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

"-----------------------------------------------------------
" Ruler
"-----------------------------------------------------------
set colorcolumn=120
highlight ColorColumn ctermbg=green

"-----------------------------------------------------------
" autoreload files
"-----------------------------------------------------------
set autoread
" Triger `autoread` when files changes on disk
autocmd FileChangedShell,FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() != 'c' | checktime | endif
" Notification after file change
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

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
" Dockerfile
"----------------------------------------------------------
augroup filetypedetect
au! BufRead,BufNewFile *Dockerfile* setfiletype dockerfile
augroup END

"----------------------------------------------------------
" FZF
"----------------------------------------------------------
if executable('fzf') && PlugLoaded('fzf')
    command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number '.shellescape(<q-args>), 0,
      \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

    nmap <silent> <Leader>g :GGrep<CR>
    nmap <silent> <Leader>F :GFiles<CR>
    nmap <silent> <Leader>f :Files<CR>
    nmap <silent> <Leader>t :Tags<CR>
    nmap <silent> <Leader>b :Buffers<CR>
    nmap <silent> <leader>/ :BLines<CR>
    nmap <silent> <leader>C :Commands<cr>
endif

"----------------------------------------------------------
" Tagbar
"----------------------------------------------------------
nmap <silent> <F8> :TagbarToggle<CR>

"----------------------------------------------------------
" lightline
"----------------------------------------------------------
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [[ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' , 'method' ]]
    \ },
    \ 'component_function': {
    \   'filename': 'LightlineFilename',
    \   'gitbranch': 'fugitive#head',
    \ },
    \ 'component': {
    \   'method':'%{tagbar#currenttag("[%s]", "", "f")}',
    \ },
    \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"----------------------------------------------------------
" vim-coc
"----------------------------------------------------------
" less annoying highlights
hi default link CocErrorHighlight   Normal
hi default link CocWarningHighlight Normal
hi default link CocInfoHighlight    Noraml
hi default link CocHintHighlight    Noraml

hi default CocErrorSign    ctermfg=Red      guifg=#ff0000
hi default CocWarningSign  ctermfg=Yellow   guifg=#ffff00
hi default CocInfoSign     ctermfg=White    guifg=#ffffff
hi default CocHintSign     ctermfg=Blue     guifg=#15aabf

" Remap keys for gotos
nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>lt <Plug>(coc-type-definition)
nmap <silent> <leader>lc <Plug>(coc-declaration)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lf <Plug>(coc-references)

" Remap for rename current word
nmap <leader>lr <Plug>(coc-rename)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

