syntax on
set noerrorbells

" increment alpha characters also
" set nrformats+=alpha
set termguicolors
" tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set showtabline=4
set smartindent

set lazyredraw
set expandtab
set number
"set relativenumber
"set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set nohlsearch
set incsearch
set hlsearch
set ignorecase
set ruler
set showcmd
set laststatus=2
" no delay on escape
set timeoutlen=1000 ttimeoutlen=0

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
""highlight ColorColumn ctermbg=NONE guibg=NONE

""" >>= Plug install directory =<<
" to run do :PlugInstall
call plug#begin('~/.vim/plugged')
  " search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'jremmen/vim-ripgrep'

  " coding
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  " Plug 'tpope/vim-dispatch' " need to find a reason to use this
  " Plug 'christoomey/vim-tmux-navigator'
  " Plug 'scrooloose/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-syntastic/syntastic'
  "Plug 'lyuts/vim-rtags'
  "Plug 'tpope/vim-markdown'
  Plug 'godlygeek/tabular'
  Plug 'romainl/vim-colortemplate'

  " themes
  Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
  "Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
  "Plug 'blueshirts/darcula', { 'as' : 'darcula' }
  "Plug 'dracula/vim', { 'as': 'dracula' }
  "Plug 'hardcoreplayers/oceanic-material'
  " Nah looks good but not functional
  " Plug 'embark-theme/vim', { 'as': 'embark' }
  Plug 'ghifarit53/tokyonight-vim'


  "" grep listing
  "Plug 'mileszs/ack.vim'

  " development
  "Plug 'fatih/vim-go'
  "Plug 'vim-utils/vim-man'
  Plug 'ycm-core/YouCompleteMe'

  "" documents
  " Plug 'vim-pandoc/vim-pandoc'
  " Plug 'vim-pandoc/vim-pandoc-syntax'
  " Plug 'xuhdev/vim-latex-live-preview'

  "" teach yourself vim
  "" requires neovim
  ":VimBeGood
  "Plug 'ThePrimeagen/vim-be-good'
  ":VimDeathmatch
  "Plug 'ThePrimeagen/vim-deathmatch'
  " great for navigation of words with quotes
  "Plug 'kana/vim-smartword'
call plug#end()

"""""""""""""""""""""""""""""""""""
colorscheme gruvbox
" terminal color
"" #10151a
"" #1E1E1E
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_termcolors=16
let g:gruvbox_contrast_dark = 'dark'
"let g:gruvbox_contrast_dark = 'hard'
"set bg=dark
"""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""
"" colorscheme tokyonight
"let g:tokyonight_style = 'night' " available: night, storm
"let g:tokyonight_enable_italic = 1
"""""""""""""""""""""""""""""""""""

"" youcompleteme: closes top preview window when you leave insert mode
"" let g:ycm_autoclose_preview_window_after_insertion = 1

" disable default commands
let mapleader=" "
nnoremap <SPACE> <Nop>
" nnoremap s <Nop>
nnoremap Q <Nop>

" Smartword ... this is so good!
"nmap w  <Plug>(smartword-w)
"nmap b  <Plug>(smartword-b)
"nmap e  <Plug>(smartword-e)
"nmap ge <Plug>(smartword-ge)

"xmap w  <Plug>(smartword-w)
"xmap b  <Plug>(smartword-b)
"xmap e  <Plug>(smartword-e)
"xmap ge <Plug>(smartword-ge)

" grep listing with ripgrep
" ack.vim --- {{{
" Use ripgrep for searching ⚡️
" Options include:
" --vimgrep -> Needed to parse the rg response properly for ack.vim
" --type-not sql -> Avoid huge sql file dumps as it slows down the search
" --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

" Auto close the Quickfix list after pressing '<enter>' or '<CR>' on a list item
let g:ack_autoclose = 1

" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!

" Maps <leader>/ so we're ready to type the search keyword
nnoremap <LEADER>/ :Ack!<SPACE>
"" fuzzy Find commands
nmap <LEADER>/ :FZF!<CR>
nmap <LEADER>f :Rg<CR><C-w><C-w>
" }}}

" kl don't really use
" Navigate quickfix list with ease
nnoremap <C-[> :cprevious<CR>
nnoremap <C-]> :cnext<CR>
nnoremap <LEADER>cc :cclose<CR>
nnoremap <LEADER>co :cope<CR>

""" >>= Plug install directory =<<
set runtimepath+=/Users/klieng/.vim

""" >>= KEYBINDING =<<
""" MODES
"" n  Normal mode map. Defined using ':nmap' or ':nnoremap'.
"" i  Insert mode map. Defined using ':imap' or ':inoremap'.
"" v  Visual and select mode map. Defined using ':vmap' or ':vnoremap'.
"" x  Visual mode map. Defined using ':xmap' or ':xnoremap'.
"" s  Select mode map. Defined using ':smap' or ':snoremap'.
"" c  Command-line mode map. Defined using ':cmap' or ':cnoremap'.
"" o  Operator pending mode map. Defined using ':omap' or ':onoremap'.

""" >>= TRICKS =<<
" duplicate lines and change the second line to == charecters
" :g/^\w/t.|s/./=/g
" double space every line pu (put text after the line)
" :g/^/pu =\"\n\"
"
" In order to double the number of spaces at the beginning of every line (and only at the beginning):
" :%s/^\s*/&&/g

" motions that you don't use often
" [count]]m ~ goes to the next function definition as in ]m
" [count]$ ~ moves to the count lines and places cursor at the end
" use f more to find characters

" run command and output to current buffer
" %! <some command>
"" >>= Navigation =<<
"" buffer navigation
"" shortcuts
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>
nmap <C-d> :bd<CR>
nmap <LEADER>l :Buffers<CR>
nmap <LEADER>ff :%!/usr/local/bin/python3 -m json.tool<CR>
vmap <LEADER>so :sort<CR>
nmap <LEADER>= gg=G<CR>

"" window navigation
nmap <C-l> :wincmd l<CR>
nmap <C-h> :wincmd h<CR>
"nmap <LEADER>l :wincmd l<CR>
"nmap <LEADER>h :wincmd h<CR>
"nmap <LEADER>k :wincmd k<CR>
"nmap <LEADER>j :wincmd j<CR>

"" nerdtree window
""nmap <LEADER>nt :NERDTreeToggle<CR>
"" quit without saving
nmap QQ :q!<CR>
"" overrides recentering
""nmap zz :w!<CR>

"" get out of insert mode
""inoremap jk <ESC>
" step through visual line mode
"nmap j gj
"nmap k gk

"" >>= misc =<<
"" source vimrc
nmap <LEADER>so :source ~/.vimrc<CR>

"" >>= Code Comment =<<
"" comment out code
""" only comment out for functions
" nmap <LEADER>cc mcvi}:s/^/<c-r>c/<CR>`c:nohlsearch<CR>
" xmap <LEADER>cc mc:s/^/<c-r>c/<CR>`c:nohlsearch<CR>
xmap <LEADER>cc mc:s/^/#/<CR>`c:nohlsearch<CR>

"" uncomment out code
" nmap <LEADER>cu mcvi}:s/^<c-r>c/<CR>`c:nohlsearch<CR>
" xmap <LEADER>cu mc:s/^<c-r>c/<CR>`c:nohlsearch<CR>
xmap <LEADER>uc mc:s/^#//<CR>`c:nohlsearch<CR>

"" copy to system clipboard when in select mode
xmap <LEADER>yy "*yy

"" copy all into system clipboard
"" I want the same key binding to copy everything into clip board in normal
"" mode
nmap <LEADER>yy mcggVG"*yy<CR>`c
nmap <LEADER>y'a "*yi'
nmap <LEADER>y"a "*yi"
nmap <LEADER>vv Vi}
nmap <LEADER>v= Vi}=<ESC>
nmap <LEADER>== gg=G<CR>``z.<ESC>

" selections in visual mode
"nnoremap <LEADER>v _vg_

" search and replace with prompt
nnoremap <LEADER>gR :%s///gc<Left><Left><Left>
" search and replace all
nnoremap <LEADER>gr :%s///g<Left><Left>

" move blocks of code around in visual mode
"vnoremap J :m '>+1<CR>gv=gv
"vnoremap K :m '<-2<CR>gv=gv

" Control maps reserved for out of vim commands
nmap <C-t> :bot terminal<CR>
"" make
nmap <LEADER>m :w<CR>:make<CR>

"" auto save
""" I don't think I need this yet!
"" nmap <LEADER>w :w<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""

"" make syntax yaml if no syntax is found
au BufNewFile,BufRead * if &syntax == '' | set syntax=yaml | endif

"" prewrite buffer
""autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre * call StripTrailingWhitespaces()

" keeps same position after call
function! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""
""" >>= play aroud with functions =<<
"" load files
":source ~/.vim/autoload/custom.vim

"" make calls
"map ,fr :call Refactor()<cr>
"map ,fc :call Comment()<cr>
"map ,fs :source ~/.vim/autoload/custom.vim<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Abbreviations in insert mode enter the character and <space>.
"" Diff from mapping: takes into account characters before and after keyword

"" create functions for bash
iab brac () {}<LEFT><CR><CR><Up><Up>function

"" latex
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'open -a Preview'

"" pandoc
"augroup pandoc_syntax
"    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
"augroup END

"" blob search
""command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
