"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lynx' vimrc
" Shamelessly stolen together from others on the internet
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" disable compatibility to old vi
set nocompatible

" allow backspacing over everything in insert mode
set backspace=2

" how many lines of history to keep
set history=500

" auto read when file is changed from outside
set autoread

" hide buffers when they are abandoned instead of unloading
set hidden

" allow h and l to switch to prev/next line
set whichwrap+=h,l

" no automatic backups
set nobackup
set nowritebackup

" don't create these annoying swapfiles
set noswapfile

" enable mouse
set mouse+=a

" utf8 as default encoding
set encoding=utf8

" disable sound
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Should be fast enough
set ttyfast

" use system-clipboard by default
set clipboard+=unnamedplus


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Syntax and filetypes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" enable syntax highlighting
syntax on

" enable filetype-specific indenting
filetype indent on

" enable filetype-specific plugins
filetype plugin on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" highlight searched strings
set hlsearch

" ignore case when searching
set ignorecase

" when everything in search-string is lowercase, ignore case
set smartcase

" start seaching while entering searchstring
set incsearch

" enable 'magic' interpretation of special chars in regexps
set magic


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Commandbar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" height of commandbar
set cmdheight=2

" complete in command-mode, but don't switch through alternatives
set wildmenu
set wildmode=longest,list


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" expand tabs to spaces
set expandtab

" indent four characters
set shiftwidth=4

" a tab is four characters
set tabstop=4

" try to be smart with tabs
set smarttab

" automatic indentation
set autoindent

" copy indent from other lines
set copyindent

" try to be smart when indenting
set smartindent


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" soft-wrap lines
set wrap

" show the cursor position all the time
set ruler

" show line numbers
set number

" show tabs and trailing spaces
set list listchars=tab:»\ ,trail:·

" show matching bracets when text indicator is over them
set showmatch

" how many tenths of a second to blink over matching bracet
set mat=2

" cursor stays away from top and button 5 lines always
set so=5


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     GUI and Colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_running")
    " set font
    set gfn=Monospace\ 10

    " disable toolbars
    set guioptions-=T

    " 256 color mode
    set t_Co=256

    " window background
    set background=dark
endif

" set overall colorscheme
colorscheme wombat256


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" cursor keys to switch buffers
map <right> :bn<cr>
map <left> :bp<cr>
map <up> <nop>
map <down> <nop>

" for some reason, we have to set these explicitly for urxvt
map Oa <C-Up>
map Ob <C-Down>
map Od <C-Left>
map Oc <C-Right>
imap Oa <C-Up>
imap Ob <C-Down>
imap Od <C-Left>
imap Oc <C-Right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" show overlong lines
highlight OverLength ctermfg=darkgray
match OverLength /\%81v.*/

" automatically close if quickfix is the only window
au BufEnter * call MyLastWindow()
function! MyLastWindow()
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

" move quickfix to the bottom as soon as it's opened
:autocmd FileType qf wincmd J

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Access to man pages
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

runtime ftplugin/man.vim
source $VIMRUNTIME/ftplugin/man.vim


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" call
"    git clone https://github.com/gmarik/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
" to install vundle,
"     vim +PluginInstall +qall
" to install configured bundles

" init it
set rtp+=~/.config/nvim/bundle/Vundle.vim/
call vundle#begin('~/.config/nvim/bundle')

" let vundle manage vundle
Plugin 'gmarik/Vundle.vim'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'bling/vim-airline'
let g:airline_powerline_fonts=1

" always show the statusline
set laststatus=2

" mode is displayed in powerline, we don't need it below again
set noshowmode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Bufferline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'bling/vim-bufferline'

let g:bufferline_echo=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     YouCompleteMe
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'Valloric/YouCompleteMe'

let g:ycm_path_to_python_interpreter='/usr/bin/python3'
let g:ycm_confirm_extra_conf=0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     NeoMake
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'benekastah/neomake'
autocmd! BufWritePost,BufEnter * Neomake
autocmd! QuitPre * let g:neomake_verbose = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Ctrlp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'kien/ctrlp.vim'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Gundo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'vim-scripts/Gundo'

nnoremap <F5> :GundoToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Vinegar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'tpope/vim-vinegar.git'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Python
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'lynxed/vim-virtualenv'

let g:PyFlakeOnWrite=1
let g:PyFlakeSigns=0
let g:PyFlakeDefaultComplexity=15
let g:PyFlakeDisabledMessages='E501'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     GLSL
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'beyondmarc/glsl.vim'

autocmd BufNewFile,BufRead *.vp,*.fp,*.gp,*.vs,*.fs,*.gs,*.tcs,*.tes,*.cs,*.vert,*.frag,*.geom,*.tess,*.shd,*.gls,*.glsl,*.*shader set ft=glsl430


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Hex-editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'vim-scripts/hexman.vim'

" Keep at bottom:
call vundle#end()

