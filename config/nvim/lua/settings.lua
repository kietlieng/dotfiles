local set      = vim.opt
local swnumber = 2

vim.cmd([[set runtimepath+=~/.nvim]]) --set.runtimepath:append { set.runtimepath .. "/.nvim" }
vim.cmd([[set runtimepath+=~/.local/share/nvim/lazy/gitlab.vim]])
vim.cmd([[set runtimepath+=~/opt/homebrew/opt/fzf]])
--vim.cmd([[set runtimepath+=~/.luarocks/lib/luarocks/rocks-5.1]])

-- wrap
--set.wrap = true
set.wrap   = false

----tmux
--set.ft   = 'tmux'
--set.tw   = 0
--set.wrap = false
-- set.remap = true -- don't think I need it 

-- undo
set.undodir  = vim.env.HOME .. '/.nvim/undodir'
set.undofile = true

--set.background     = 'dark' -- should be set in theme
--set.nrformats      = set.nrformats + 'alpha'                                          -- increase alpha letters. Want numbers for now
--set.clipboard      = { 'unnamed', 'unnamedplus' } -- not what I want

set.backup         = false
set.belloff        = 'all'
set.colorcolumn    = '80'
set.cursorline     = true
set.expandtab      = true
set.fileencoding   = 'utf-8'                                                          -- encoding set to utf-8
set.foldlevel      = 99                                                               -- no folds
set.hidden         = true
set.hlsearch       = true
set.ignorecase     = true
set.incsearch      = true
set.lazyredraw     = true
--set.lazyredraw     = false
set.number         = true
set.relativenumber = true
set.ruler          = true
set.scrolloff      = 8                                                                -- give at list X space before / after cursor
set.shiftwidth     = swnumber
set.showcmd        = true
set.showtabline    = 2
set.sidescrolloff  = 8                                                                -- scroll page when cursor is 8 spaces from left/right
set.signcolumn     = 'yes'
set.smartcase      = true
set.smartindent    = true
set.smarttab       = true
set.softtabstop    = 2
set.statusline     = '%F'
set.laststatus     = 2
set.swapfile       = false
set.syntax         = 'ON'
set.tabstop        = 2
set.termguicolors  = true                                                             -- set if you want theme challenger deep, feline        -- remove if using apple terminal
set.timeoutlen     = 1000                                                             -- no delay on escape
set.title          = true
set.titlestring    = '%F'
set.ttimeoutlen    = 0                                                                -- no delay on escape
set.updatetime     = 100                                                              -- gitgutter delay
set.viminfo        = "'100,f1"                                                        -- persistent marks up to 100
set.wildignore     = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'  -- avoid
set.guicursor      = 'a:blinkon100'

vim.cmd([[

  let &t_ut=''

  "let &t_Co="256"
  "let &t_SI.="\e[5 q" 
  "let &t_SR.="\e[4 q" 
  "let &t_EI.="\e[1 q" 

]]) -- solves redraw issue with using gruvbox

--set.completeopt = 'menu,menuone' -- duo


--set.listchars.append = { -- doesn't seem to work?
--  tab = '│ ',
--  trail = '·',
--  extends = '»',
--  precedes = '«',
--  nbsp = '+',
--  eol = '↲',
--  space = '.',
--  conceal = '┊' ,
--  multispace = '│' .. string.rep(' ', swnumber - 1)
--}


