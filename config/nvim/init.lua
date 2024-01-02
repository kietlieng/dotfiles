local set = vim.opt

vim.cmd([[set runtimepath+=~/.nvim]]) --set.runtimepath:append { set.runtimepath .. "/.nvim" }

-- undo
set.undodir  = vim.env.HOME .. '/.nvim/undodir'
set.undofile = true

--set.background     = "dark" -- should be set in theme
--set.nrformats      = set.nrformats + 'alpha'                                          -- increase alpha letters. Want numbers for now
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
set.laststatus     = 2
set.lazyredraw     = true
set.number         = true
set.relativenumber = true
set.ruler          = true
set.scrolloff      = 8                                                                -- give at list X space before / after cursor
set.shiftwidth     = 2
set.showcmd        = true
set.showtabline    = 2
set.sidescrolloff  = 8                                                                -- scroll page when cursor is 8 spaces from left/right
set.signcolumn     = 'yes'
set.smartcase      = true
set.smartindent    = true
set.smarttab       = true
set.softtabstop    = 2
set.statusline     = "%F"
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
set.wrap           = true

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
    { "junegunn/fzf", build = "./install --bin", config = function() require('lua-fzf').setup() end, }, -- setup snippet engine
    { "junegunn/fzf.vim" },
    { "jremmen/vim-ripgrep", config = function() require('ripgrepper').setup() end, }, -- setup ripgrepper bang command to use register r
    { "mileszs/ack.vim" }, -- grep listing

    { "tpope/vim-surround" },

    { "tpope/vim-fugitive" }, -- git operations in git
    { "airblade/vim-gitgutter", config = function() require('gitgutter').setup() end }, -- Git gutter.  Different than fugitive
    { "vim-airline/vim-airline", config = function() require('airline').setup() end },
    --{ "feline-nvim/feline.nvim',  branch = '0.5-compat", config = function() require('lua-feline').setup() require('feline').winbar.setup() end, },
    { "godlygeek/tabular" }, -- sort table values

    -- THEMES

    -- { "blueshirts/darcula" },
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- { "challenger-deep-theme/vim" }, -- everything is too bright
    -- { "embark-theme/vim", as = 'embark' }, -- looks good but not functional
    -- { "ghifarit53/tokyonight-vim" },
    -- { "hardcoreplayers/oceanic-material", config = function() require('oceanic-material').setup() end },
    -- { "olimorris/onedarkpro.nvim", priority = 1000 },
    -- { "sainnhe/gruvbox-material", config = function() require('g-material').setup() end },
    -- { "tjdevries/colorbuddy.vim" }, { "tjdevries/gruvbuddy.nvim" }, -- don't really like
    -- { "morhetz/gruvbox", config = function() require('gruvbox').setup() end  }, -- it's morhetz fork but with support },
    { "gruvbox-community/gruvbox", config = function() require('gruvbox').setup() end  }, -- it's morhetz fork but with support

    -- coc for preview

    { "neoclide/coc.nvim", branch = 'release' },
    { "iamcco/markdown-preview.nvim", build = 'cd app && yarn install' },

    --{ "kana/vim-smartword" }, -- great for navigation of words with quotes
    { "wellle/targets.vim", config = function() require('targets').setup() end }, -- arguement text objects.

    { "skywind3000/asyncrun.vim" }, --  " run jobs in the background

    { "ryanoasis/vim-devicons" }, -- icons for plugin
    { "nvim-tree/nvim-web-devicons" }, -- icons to plugins
    { "nvim-lua/plenary.nvim" }, -- no idea what this does but it's required by other plugins
    { "ThePrimeagen/harpoon", config = function() require('lua-harpoon').setup() end, }, -- navigation
    { "nvim-telescope/telescope.nvim", tag = '0.1.3' },
    { "nvim-telescope/telescope-fzf-native.nvim", build = 'make', config = function() require('tele').setup() require('telescope').load_extension('fzf') end, },
    { "nvim-treesitter/nvim-treesitter", build = ':TSUpdate', config = function() require('treesitter').setup() end, }, -- setup syntax for treesitter

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

    { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("lua-oil").setup() end, }, -- oil setup

    -- useless but fun
    { "Eandrju/cellular-automaton.nvim" }, -- makes it look like sand droplets

    { "nvimtools/none-ls.nvim", config = function() require('none-ls').setup() end, requires = { "nvim-lua/plenary.nvim" } }, -- community supported null-ls
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
require('fun').setup()                              -- useless but fun
require('theme-dark').setup()                            -- needs to be last
