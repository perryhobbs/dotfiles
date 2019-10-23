if filereadable("/usr/facebook/ops/rc/master.vimrc")
  source /usr/facebook/ops/rc/master.vimrc
endif
" Big Grep (eg :FBGR)
if filereadable($LOCAL_ADMIN_SCRIPTS . "/vim/biggrep.vim")
  source $LOCAL_ADMIN_SCRIPTS/vim/biggrep.vim
endif

" Color Scheme.
syntax enable
:color peachpuff

" Indent style; override these explicitly to turn them off.
set shiftwidth=4        " two spaces per indent
set tabstop=4           " number of spaces per tab in display
set softtabstop=4       " number of spaces per tab when inserting
set expandtab           " substitute spaces for tabs
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%>81v.\+/

" Display.
set ruler           " show cursor position
set number          " show line numbers
set nolist          " hide tabs and EOL chars
set showcmd         " show normal mode commands as they are entered
set showmode        " show editing mode in status (-- INSERT --)
set showmatch       " flash matching delimiters

" Scrolling.
set scrolljump=5    " scroll five lines at a time vertically
set sidescroll=10   " minumum columns to scroll horizontally

" Search.
set nohlsearch      " don't persist search highlighting
set incsearch       " search with typeahead

" Indent.
set autoindent      " carry indent over to new lines

" Other.
set noerrorbells                " no bells in terminal
set backspace=indent,eol,start  " backspace over everything
set tags=tags;/                 " search up the directory tree for tags
set undolevels=1000             " number of undos stored
set viminfo='50,"50             " '=marks for x files, "=registers for x files
set modelines=0                 " modelines are bad for your health

" Jump to last known cursor position on file open
autocmd BufReadPost * silent! normal! g`"zv
