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

" when vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc


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

    " set overall colorscheme
    colorscheme codeschool
endif

" set overall colorscheme
colorscheme lynx


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" cursor keys to switch buffers
map <right> :bn<cr>
map <left> :bp<cr>
map <up> <nop>
map <down> <nop>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" automatically open quickfix window
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" show overlong lines
highlight OverLength ctermfg=darkgray
match OverLength /\%81v.*/


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Vundle
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" call
"    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" to install vundle,
"     vim +BundleInstall +qall
" to install configured bundles

" init it
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let vundle manage vundle
Bundle 'gmarik/vundle'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Powerline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'Lokaltog/powerline'
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" always show the statusline
set laststatus=2
