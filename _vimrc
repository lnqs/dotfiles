"A
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

" mode is displayed in powerline, we don't need it below again
set noshowmode


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     vimpager
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'rkitover/vimpager'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Ctrlp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'kien/ctrlp.vim'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     UltiSnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'vim-scripts/UltiSnips'

" no idea why I need to call this explicitly, but, well...
autocmd FileType * call UltiSnips_FileTypeChanged()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Gundo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'vim-scripts/Gundo'

nnoremap <F5> :GundoToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     bufexplorer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'c9s/bufexplorer'

nnoremap <F6> :BufExplorer<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'scrooloose/nerdtree'

nnoremap <F7> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'tpope/vim-fugitive'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     clang complete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'Rip-Rip/clang_complete'
let g:clang_auto_select=0
let g:clang_complete_auto=0
let g:clang_complete_copen=1
let g:clang_periodic_quickfix=1
let g:clang_hl_errors=1
let g:clang_snippets_engine='ultisnips'
let g:clang_trailing_placeholder=1
let g:clang_use_library=1
let g:clang_complete_macros=1
let g:clang_complete_patterns=1

autocmd FileType cpp let g:clang_user_options='-std=c++11'
autocmd FileType c let g:clang_user_options='-std=c99'

autocmd FileType c,cpp let g:SuperTabDefaultCompletionType='<c-x><c-u>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     ctags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'vim-scripts/taglist.vim'
Bundle 'vim-scripts/easytags.vim'

let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_Use_Right_Window=1
map <F4> :TlistToggle<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     SuperTab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'ervandew/supertab'

set completeopt=menu,menuone,longest
let g:SuperTabLongestHighlight=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Python-mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'klen/python-mode.git'

let g:pymode_folding=0
let g:pymode_lint_onfly=1

autocmd FileType python let g:SuperTabDefaultCompletionType='<c-x><c-o>'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"     Clojure
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Bundle 'guns/vim-clojure-static'
Bundle 'tpope/vim-classpath'
Bundle 'tpope/vim-fireplace'

