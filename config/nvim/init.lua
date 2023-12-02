local set = vim.opt

vim.cmd([[set runtimepath+=~/.nvim]]) --set.runtimepath:append { set.runtimepath .. "/.nvim" }
set.undodir = vim.env.HOME .. '/.nvim/undodir'

-- tabs
set.expandtab   = true
set.shiftwidth  = 2
set.showtabline = 2
set.smartindent = true
set.softtabstop = 2
set.tabstop     = 2

--set.nrformats     = set.nrformats + 'alpha' -- increase alpha letters. Want numbers for now
--set.termguicolors = true -- set if you want theme challenger deep, feline -- remove if using apple terminal
set.backup          = false
set.belloff         = "all"
set.colorcolumn     = "80"
set.cursorline      = true
set.hidden          = true
set.hlsearch        = false
set.hlsearch        = true
set.ignorecase      = true
set.incsearch       = true
set.laststatus      = 2
set.lazyredraw      = true
set.number          = true
set.relativenumber  = true
set.ruler           = true
set.scrolloff       = 10 -- give at list 10 space before / after cursor
set.showcmd         = true
set.signcolumn      = 'yes'
set.smartcase       = true
set.swapfile        = false
set.syntax          = 'on'
set.timeoutlen      = 1000 -- no delay on escape
set.ttimeoutlen     = 0    -- no delay on escape
set.undofile        = true
set.updatetime      = 100 -- gitgutter delay
set.viminfo         = "'100,f1" -- persistent marks up to 100
set.wrap            = true

vim.cmd([[

set statusline=%F
set title
set titlestring=%F

]])

--set.utf8 = true
vim.cmd([[highlight ColorColumn ctermbg=0 guibg=lightgrey]])

-- https://stackoverflow.com/questions/71152802/how-to-override-color-scheme-in-neovim-lua-config-file
--vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg=0, guibg=lightgrey })
----vim.api.nvim_set_hl(0, "Comment", { cterm=italic, gui=italic })
--vim.api.nvim_set_hl(0, "Comment", { cterm=strikethrough, gui=strikethrough })

--- LAZY START -----

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

set.rtp:prepend(lazypath)

require("lazy").setup({

    -- search
    { "junegunn/fzf", build = "./install --bin" }, -- build it internally to have it avaliable
    { "junegunn/fzf.vim" },
    { "jremmen/vim-ripgrep" },
    { "mileszs/ack.vim" }, -- grep listing

    { "tpope/vim-surround" },

    { "tpope/vim-fugitive" }, -- git operations in git
    { "airblade/vim-gitgutter" },
    { "vim-airline/vim-airline" },
    --{ "feline-nvim/feline.nvim',  branch = '0.5-compat" },

    { "godlygeek/tabular" }, -- sort table values

    -- THEMES
    { "morhetz/gruvbox" },
    -- { "sainnhe/gruvbox-material" },
    -- { "olimorris/onedarkpro.nvim", priority = 1000 },
    -- { "tjdevries/colorbuddy.vim" }, { "tjdevries/gruvbuddy.nvim" }, -- don't really like
    -- { "embark-theme/vim", as = 'embark' }, -- looks good but not functional
    -- { "challenger-deep-theme/vim" }, -- everything is too bright
    -- { "blueshirts/darcula" },
    -- { "hardcoreplayers/oceanic-material" },
    -- { "ghifarit53/tokyonight-vim" },
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },


    -- coc for preview
    { "neoclide/coc.nvim", branch = 'release' },
    { "iamcco/markdown-preview.nvim", build = 'cd app && yarn install' },

    --{ "kana/vim-smartword" }, -- great for navigation of words with quotes

    { "skywind3000/asyncrun.vim" }, --  " run jobs in the background

    { "ryanoasis/vim-devicons" }, -- icons for plugin
    { "nvim-tree/nvim-web-devicons" }, -- icons to plugins
    { "nvim-lua/plenary.nvim" }, -- no idea what this does but it's required by other plugins
    { "ThePrimeagen/harpoon" }, -- navigation
    { "nvim-telescope/telescope.nvim", tag = '0.1.3' },
    { "nvim-telescope/telescope-fzf-native.nvim", build = 'make' },
    { "nvim-treesitter/nvim-treesitter", build = ':TSUpdate' },
    { "lewis6991/tree-sitter-tcl", build = 'make' }, -- tcl syntax
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "rafamadriz/friendly-snippets" },

    ----- CMP begin -----

    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" }, -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

    ---- For vsnip users.
    --{ "hrsh7th/cmp-vsnip" },
    --{ "hrsh7th/vim-vsnip" },

    -- For luasnip users.
    { "L3MON4D3/LuaSnip", version = "2.*", build = "make install_jsregexp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },

    ---- For ultisnips users.
    --{ "SirVer/ultisnips" },
    --{ "quangnguyen30192/cmp-nvim-ultisnips" },

    ---- For snippy users.
    --{ "dcampos/nvim-snippy" },
    --{ "dcampos/cmp-snippy" },

    ----- CMP end -----

    { "prettier/vim-prettier", build =  'yarn install --frozen-lockfile --production', branch = 'release/0.x' },


    { "stevearc/oil.nvim",
      opts = {},
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- useless but fun
    { "Eandrju/cellular-automaton.nvim" }, -- makes it look like sand droplets

})

----- LAZY END -----

---- THEME BEGIN

---- onedark theme
--require("onedarkpro").setup({
--  highlights = {
--    Error = {
--      underline = false,
--    },
--  }
--})

--vim.cmd.colorscheme "catppuccin" -- catppuccin / catppuccin-latte / catppuccin-frappe / catppuccin-macchiato / catppuccin-mocha
--vim.cmd.colorscheme "challenger_deep"
--vim.cmd.colorscheme "gruvbox-material"
--vim.cmd.colorscheme "challenger_deep"
--vim.cmd.colorscheme "oceanic_material"
--require('colorbuddy').colorscheme('gruvbuddy')
--vim.cmd.colorscheme "onedark_dark" -- onedark / onelight / onedark_vivid / onedark_dark

vim.cmd.colorscheme "gruvbox"
set.background = "dark" -- vim.o.background = "dark" -- or "light" for light mode

---- THEME END


-- AUTO COMMANDS BEGIN

vim.api.nvim_create_autocmd( { "VimEnter" }, { pattern = "*", command = ":normal zz" })
vim.api.nvim_create_autocmd( { "BufNewFile", "BufRead" }, { pattern = "*.md", command = "call NotePreview()", }) --"" run the watch command when detecting markup
-- doesn't work all the time only on first buffer
-- vim.api.nvim_create_autocmd({"TextChanged", "textChangedI"}, { pattern = "<buffer>", command = "silent update" }) -- auto save

-- AUTO COMMANDS END

-- COMMAND BEGIN

vim.cmd([[


  ""g:fzf_vim.listproc = { list -> fzf#vim#listproc#quickfix(list) } "" currently not working

  "" Remember / Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

  "" airline
  ""let g:gruvbox_improved_strings         = 1 "" high contrast string (white text / grey background). Not great if alot of strings
  ""let g:gruvbox_invert_indent_guides     = 1 "" don't use indent guides
  ""let g:gruvbox_invert_signs             = 1 "" too jarring
  ""let g:gruvbox_material_background      = 'hard' "" hard / medium / soft
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_section_y                  = airline#section#create_left(['path'])
  let g:airline_theme                      = 'gruvbox'
  let g:gruvbox_bold                       = 1
  let g:gruvbox_contrast_dark              = 'hard'
  let g:gruvbox_improved_warnings          = 1
  let g:gruvbox_invert_tabline             = 1
  let g:gruvbox_italic                     = 1
  let g:gruvbox_italicize_strings          = 1
  let g:loaded_perl_provider               = 0  "" disable perl from checkhealth


  function! GetBufferList()
    redir =>buflist
    silent! ls!
    redir END
    return buflist
  endfunction

  function! ToggleList(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
      if bufwinnr(bufnum) != -1
        exec(a:pfx.'close')
        return
      endif
    endfor
    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        echo "Location List is Empty."
        return
    endif
    let winnr = winnr()
    exec(a:pfx.'open')
    if winnr() != winnr
      wincmd p
    endif
  endfunction

  " reposition the windows correctly
  function! NotePreview()
      let l:filename=tolower(expand('%:r'))
      let l:filePath=tolower(expand('%:p:h'))
      let l:previewing=0
  
      "" not in meeting
      if (stridx(l:filePath, 'lab/meetings') == -1) && (stridx(l:filePath, 'lab/notes') == -1)
          if stridx(l:filename, 'readme') > -1 || stridx(l:filename, 'license') > -1 || stridx(l:filename, '-no') > -1
              "":echo "Do nothing"
          elseif stridx(l:filename, '-mm') > -1
              "" preview mind map
              let l:previewing=1
              :CocCommand markmap.watch
              :AsyncRun callkittyfocus.sh
          else " preview markdown
              let l:previewing=1
              :MarkdownPreview
              :AsyncRun callkittyfocus.sh
          endif
      endif
  
      ":silent !callwin.sh md " reposition windows to reading
      ":silent !callopenbook.sh '%:r' " find the book and open it
      " :) I love this! Runs in the background with no hesitations whatsoever
      " requires asyncrun plugin
      if (l:previewing)
          :AsyncRun callopenbook.sh '%:r'
      endif
  
  endfunction
  
  function! StripTrailingWhitespaces()
      let l = line(".")
      let c = col(".")
      %s/\s\+$//e
      call cursor(l, c)
  endfunction
  
  function! CloseBufferOrVim(saveFirst)
  
      "" if more than 1 buffer close the current buffer only. Otherwise close vim
      if (len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1)
        if a:saveFirst == 1
          "" to avoid git commit window issue
          :w
          :bw
        else
          :bd!
        endif
      else
        if a:saveFirst == 1
          :wq!
        else
          :q!
        endif
      endif
  
  endfunction

  autocmd BufNewFile,BufRead * if &syntax == '' | set syntax=yaml | endif "" make syntax yaml if no syntax is found

  ""nnoremap <LEADER>R :Ack!<SPACE> -- don't actually like this command does not work properly
  ""autocmd BufWritePre * call StripTrailingWhitespaces() "" doesn't work with oil remap manually

]])

-- COMMAND END

--require('lua-feline').setup() feline
--require('feline').winbar.setup()

require('ripgrepper').setup()              -- setup ripgrepper bang command to use register r

require('tele').setup()                    -- telescope setup
require('telescope').load_extension('fzf')

require("lua-oil").setup()    -- oil setup
require('lua-fzf').setup()    -- setup snippet engine
require('lua-harpoon').setup()
require('quotes').setup()     -- yank / delete / change betweet quotes / brackets / parens
require('treesitter').setup() -- setup syntax for treesitter
require('snippet-luasnip').setup()                 -- setup snippet engine

require("luasnip.loaders.from_vscode").lazy_load() -- lead friendly-snippets support into luasnip
require('lua-mason-lspconfig').setup()             -- setup syntax for treesitter
require('lsp-setup').setup()                       -- setup all lsp

require('fun').setup()         -- useless but fun

require('keymap').setup()
