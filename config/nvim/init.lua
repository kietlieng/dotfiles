local set      = vim.opt
local swnumber = 2

vim.cmd([[set runtimepath+=~/.nvim]]) --set.runtimepath:append { set.runtimepath .. "/.nvim" }
vim.cmd([[set runtimepath+=~/.local/share/nvim/lazy/gitlab.vim]])
--vim.cmd([[set runtimepath+=~/.luarocks/lib/luarocks/rocks-5.1]])

-- wrap
--set.wrap = true
set.wrap   = false

----tmux
--set.ft   = 'tmux'
--set.tw   = 0
--set.wrap = false

-- undo
set.undodir  = vim.env.HOME .. '/.nvim/undodir'
set.undofile = true

--set.background     = "dark" -- should be set in theme
--set.nrformats      = set.nrformats + 'alpha'                                          -- increase alpha letters. Want numbers for now
--set.clipboard      = { "unnamed", "unnamedplus" } -- not what I want

set.backup         = false
set.belloff        = "all"
set.colorcolumn    = "80"
set.cursorline     = true
set.expandtab      = true
set.fileencoding   = "utf-8"                                                          -- encoding set to utf-8
set.foldlevel      = 99                                                               -- no folds
set.hidden         = true
set.hlsearch       = true
set.ignorecase     = true
set.incsearch      = true
set.lazyredraw     = true
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
set.statusline     = "%F"
set.laststatus     = 2
set.swapfile       = false
set.syntax         = 'ON'
set.tabstop        = 2
set.termguicolors  = true                                                             -- set if you want theme challenger deep, feline        -- remove if using apple terminal
set.timeoutlen     = 1000                                                             -- no delay on escape
set.title          = true
set.titlestring    = "%F"
set.ttimeoutlen    = 0                                                                -- no delay on escape
set.updatetime     = 100                                                              -- gitgutter delay
set.viminfo        = "'100,f1"                                                        -- persistent marks up to 100
set.wildignore     = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"  -- avoid
set.guicursor      = 'a:blinkon100'

--set.completeopt = 'menu,menuone' -- duo


--set.listchars.append = { -- doesn't seem to work?
--  tab = "│ ",
--  trail = "·",
--  extends = "»",
--  precedes = "«",
--  nbsp = "+",
--  eol = "↲",
--  space = ".",
--  conceal = "┊" ,
--  multispace = "│" .. string.rep(" ", swnumber - 1)
--}

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

-- lazystart
require("lazy").setup({

--    -- gitlab duo 
--    {
--      'git@gitlab.com:gitlab-org/editor-extensions/gitlab.vim.git',
--      event = { 'BufReadPre', 'BufNewFile' }, -- Activate when a file is created/opened
--      ft = { 'go', 'javascript', 'python', 'ruby', 'bash' }, -- Activate when a supported filetype is open
--      cond = function()
--        return vim.env.GITLAB_TOKEN ~= nil and vim.env.GITLAB_TOKEN ~= '' -- Only activate if token is present in environment variable (remove to use interactive workflow)
--      end,
--      opts = {
--        statusline = {
--          enabled = true, -- Hook into the builtin statusline to indicate the status of the GitLab Duo Code Suggestions integration
--        },
--      },
--    },

   -- multicursor implementation 
--   { "jake-stewart/multicursor.nvim", branch = "1.0", config = function() require("multi-cursor").setup() end, },

    -- syntax zellij
    { "imsnif/kdl.vim" },

    -- search
    { "junegunn/fzf", build = "./install --bin", }, -- setup snippet engine
    { "junegunn/fzf.vim" },
    { "vijaymarupudi/nvim-fzf" },
    { "jremmen/vim-ripgrep", config = function() require('ripgrepper').setup() end, }, -- setup ripgrepper bang command to use register r
    { "mileszs/ack.vim" }, -- grep listing

    { "tpope/vim-surround" }, -- surround functionality
    { "tpope/vim-fugitive" }, -- git operations in git
    --{ "tpope/vim-abolish" }, -- change variables.  abolish: change part of text, subvert substitution with parts of word, coercion change variable cases

    { "airblade/vim-gitgutter", config = function() require('gitgutter').setup() end }, -- Git gutter.  Different than fugitive

    { "vim-airline/vim-airline", config = function() require('airline').setup() end },
    --{ "feline-nvim/feline.nvim',  branch = '0.5-compat", config = function() require('lua-feline').setup() require('feline').winbar.setup() end, }, -- using airline
    { "godlygeek/tabular" }, -- sort table values

    -- coc for preview

    { "neoclide/coc.nvim", branch = 'release' },
    { "iamcco/markdown-preview.nvim", build = 'cd app && yarn install' },

--    { "3rd/image.nvim", config = function() require('image-lua').setup() end },
--    { "3rd/diagram.nvim",
--      dependencies = { "3rd/image.nvim", },
--      opts = { -- you can just pass {}, defaults below
--        renderer_options = {
--          mermaid = {
--            background = nil, -- nil | "transparent" | "white" | "#hex"
--            theme = nil, -- nil | "default" | "dark" | "forest" | "neutral"
--            scale = 1, -- nil | 1 (default) | 2  | 3 | ...
--          },
--          plantuml = {
--            charset = nil,
--          },
--          d2 = {
--            theme_id = nil,
--            dark_theme_id = nil,
--            scale = nil,
--            layout = nil,
--            sketch = nil,
--          },
--        }
--      },
--    },


    -- NAVIGATION ---
    --{ "kana/vim-smartword" }, -- great for navigation of words with quotes, haven't found a need to use it
    --{ "wellle/targets.vim", config = function() require('targets').setup() end }, -- arguement text objects.  Don't know if I'm using them enough

    { "skywind3000/asyncrun.vim" }, --  " run jobs in the background

    { "ryanoasis/vim-devicons" }, -- icons for plugin
    { "nvim-tree/nvim-web-devicons" }, -- icons to plugins
    { "nvim-lua/plenary.nvim" }, -- no idea what this does but it's required by other plugins
    --{ "ThePrimeagen/harpoon", config = function() require('lua-harpoon').setup() end, }, -- navigation.  Not really using it 
    { "nvim-telescope/telescope.nvim", tag = '0.1.3' },
    { "nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }, config = function() require('lua-tele-file-browser').setup() end,  },
    { "nvim-telescope/telescope-fzf-native.nvim", build = 'make', config = function() require('tele').setup() end, },
    { 'nvim-treesitter/nvim-tree-docs' }, -- never got it working
    { "nvim-treesitter/nvim-treesitter", build = ':TSUpdate', config = function() require('treesitter').setup() end, }, -- setup syntax for treesitter

    { "lewis6991/tree-sitter-tcl", build = 'make' }, -- tcl syntax
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "rafamadriz/friendly-snippets" },

    { "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
--        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
--        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },

    ----- CMP begin -----

    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" }, -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

    -- For luasnip users.
    { "L3MON4D3/LuaSnip", version = "2.*", build = "make install_jsregexp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },

    ---- For vsnip users.
    -- { "hrsh7th/cmp-vsnip" },
    -- { "hrsh7th/vim-vsnip" },
    ---- For ultisnips users.
    -- { "SirVer/ultisnips" },
    -- { "quangnguyen30192/cmp-nvim-ultisnips" },
    ---- For snippy users.
    -- { "dcampos/nvim-snippy" },
    -- { "dcampos/cmp-snippy" },

    ----- CMP end -----

    --{ "prettier/vim-prettier", build =  'yarn install --frozen-lockfile --production', branch = 'release/0.x' }, -- don't think I'm using at all
    { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("lua-oil").setup() end, }, -- oil setup

    -- THEMES

    -- { "blueshirts/darcula" },
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- { "challenger-deep-theme/vim" },                                                                               -- everything is too bright
    -- { "embark-theme/vim", as = 'embark' },                                                                         -- looks good but not functional
    -- { "ghifarit53/tokyonight-vim" },
    -- { "hardcoreplayers/oceanic-material", config = function() require('theme-oceanic-material').setup() end },           -- meh
    -- { "olimorris/onedarkpro.nvim", priority = 1000 },
    -- { "sainnhe/gruvbox-material", config = function() require('theme-material').setup() end },
    -- { "tjdevries/colorbuddy.vim" }, { "tjdevries/gruvbuddy.nvim" },                                                -- don't really like
    -- { "xero/miasma.nvim", lazy = false, priority = 1000, config = function() vim.cmd("colorscheme miasma") end, }, -- way too gloomy
    -- { "morhetz/gruvbox", config = function() require('gruvbox').setup() end  },                                    -- it's morhetz fork but with support },
    -- { "GlennLeo/cobalt2", config = function() require('theme-cobalt2').setup() end },                              -- try it
    -- { "diegoulloao/neofusion.nvim", config = function() require('theme-neofusion').setup() end  }, -- too dark

    { "gruvbox-community/gruvbox", config = function() require('theme-gruvbox').setup() end }, -- it's morhetz fork but with support.  Best thing around
--    { "joshdick/onedark.vim", config = function() require('theme-onedark').setup() end  }, -- it's morhetz fork but with support.  Best thing around

    -- messes with current customization settings.  Will try again later. mini suite of modules that might be handy
    -- { 'echasnovski/mini.nvim', version = false, config = function() require('mini').setup() end, },

    -- not enabled but has potential
    -- all in one lsp / prettier / diagnostics--{ "nvimtools/none-ls.nvim", config = function() require('none-ls').setup() end, requires = { "nvim-lua/plenary.nvim" } }, -- community supported null-ls.  Haven't really used it
    --{ 'heavenshell/vim-jsdoc', build = 'make install', { 'for': ['javascript', 'javascript.jsx','typescript']  } }, -- for docs

    -- useless but fun
    --{ "Eandrju/cellular-automaton.nvim" }, -- makes it look like sand droplets

})

----- LAZY END -----

-- AUTO COMMANDS BEGIN

-- vim.api.nvim_create_autocmd({"TextChanged", "textChangedI"}, { pattern = "<buffer>", command = "silent update" })  -- doesn't work all the time only on first buffer
vim.api.nvim_create_autocmd( { "BufNewFile", "BufRead" }, { pattern = "*.md", command = "call NotePreview()", })      -- run the watch command when detecting markup
vim.api.nvim_create_autocmd( { "VimEnter" }, { pattern = "*", command = ":normal zz" })

vim.api.nvim_create_autocmd( { "BufWinEnter" }, -- disable yaml if buf path has the following
  { pattern = { "*.yaml", "*.yml" },
  callback = function()

    local bufferRepo = vim.fn.expand('%:p')

    --vim.api.nvim_out_write(bufferRepo .. "\n") -- debug

    -- if you find it shut it down
    if (string.find(bufferRepo, "dns%-internal%-dev")) or
       (string.find(bufferRepo, "public%-dns%-repo")) or
       (string.find(bufferRepo, "dns%-internal%-prod")) then

      vim.cmd(':LspStop ' .. vim.fn.bufnr('%'))

    end
  end,

  }

)

-- AUTO COMMANDS END

-- COMMAND BEGIN

vim.cmd([[

  ""g:fzf_vim.listproc = { list -> fzf#vim#listproc#quickfix(list) } "" currently not working

  "" Remember / Return to last edit position when opening files (You want this!)
  autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

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

      "" not in meetings / notes / not a license or have a '-no'
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

require('snippet-luasnip').setup()                  -- setup snippet engine
require("luasnip.loaders.from_vscode").lazy_load()  -- lead friendly-snippets support into luasnip
require('mason-setup').setup()                      -- setup syntax for treesitter
require('lsp-setup').setup()                        -- setup all lsp
require('keymap').setup()                           -- key mapping
--require('fun').setup()                              -- useless but fun
--require('theme-gruvbox').setup()                    -- needs to be last
