"
" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'kien/ctrlp.vim' " Ctrl+P für Regex Datei öffnen
Plugin 'shawncplus/phpcomplete.vim' " PHP Autocomplete
"Plugin 'ervandew/supertab' " Tab-Autocomplete
Plugin 'bling/vim-airline'  " Colored Statusbar
Plugin 'scrooloose/nerdtree' " File-Tree-Explorer

Plugin 'godlygeek/csapprox' " Farbschema-Dependency
Plugin 'vim-scripts/AfterColors.vim' " Farbschema-Customizing
"Plugin 'b0wter/spacecadet'  " Joes Farbschema
"Plugin 'sickill/vim-monokai' " Monokai Farbschema
"Plugin 'ajh17/Spacegray.vim' " Tottis Farbschema

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" jas
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set modeline
filetype plugin on
filetype indent on
set backspace=indent,eol,start  " Backspace fix: http://vim.wikia.com/wiki/Backspace_and_delete_problems
:syn on

" Keep Position between sessions
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Omni-Complete with tab
"let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"let g:SuperTabDefaultCompletionType = "context"

" Immediately Close Preview-Box
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"set completeopt-=preview  " Disable Preview-Box complete

" NerdTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary" && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1) | q | endif " AutoClose if only NerdTree open
nmap <F1> :bp!<CR>
imap <F1> <Esc>:bp!<CR>
nmap <F2> :bn!<CR>
imap <F2> <Esc>:bn!<CR>
nmap <F3> :bd!<CR>

" Vim Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
set laststatus=2

color spacecadet " modified
"color spacegray
"color monokai
