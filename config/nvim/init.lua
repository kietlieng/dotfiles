--vim.cmd([[
--
--  let &t_ut=''
--
--  "let &t_Co="256"
--  "let &t_SI.="\e[5 q" 
--  "let &t_SR.="\e[4 q" 
--  "let &t_EI.="\e[1 q" 
--
--  if $TERM == "xterm-kitty"
--      set mouse=a
--      try
--          " undercurl support
--          let &t_Cs = "\e[4:3m"
--          let &t_Ce = "\e[4:0m"
--      catch
--      endtry
--      " Change the cursor in different modes
--      let &t_SI = "\e[5 q"
--      let &t_SR = "\e[3 q"
--      let &t_EI = "\e[1 q"
--      " vim hardcodes background color erase even if the terminfo file does
--      " not contain bce. This causes incorrect background rendering when
--      " using a color theme with a background color.
--      let &t_ut=''
--      let &t_ti = &t_ti . "\e[1 q"
--  endif
--
--]])

require('settings')
require('keymap')

local set = vim.opt

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

set.rtp:prepend(lazypath)


-- lazystart
require('lazy').setup({
    { import = "plugins" },
    { import = "themes" },
  },
  {

    ui = { border = 'rounded' },
    dev = { path = vim.g.projects_dir },
    install = {
      -- Do not automatically install on startup.
      missing = true,
    },
    -- Don't bother me when tweaking plugins.
    change_detection = {
      notify = false
    },
    -- None of my plugins use luarocks so disable this.
    rocks = {
      enabled = false,
    },
    performance = {
      rtp = {

        -- Stuff I don't use.
        disabled_plugins = {

          -- 'theme-catppuccin',
          -- 'theme-challenger-deep',
          -- 'theme-cobalt2',
          -- 'theme-darcula',
          -- 'theme-darkvoid',
          -- 'theme-embark',
          -- 'theme-everforest',
          -- 'theme-material',
          -- 'theme-mellow',
          -- 'theme-neofusion',
          -- 'theme-oceanic-material',
          -- 'theme-onedark',
          -- 'theme-onedarkpro',

        },
      },
    },

  }
)

require('autocmd') -- needs to be on the bottom

----- LAZY END -----

--require('autosave-unnamed').setup()                  -- setup snippet engine
require('custom/snippet-luasnip').setup()                  -- setup snippet engine
-- require("luasnip.loaders.from_vscode").lazy_load()  -- lead friendly-snippets support into luasnip
-- require('mason-setup').setup()                      -- setup syntax for treesitter
-- require('lsp-setup').setup()                        -- setup all lsp
--require('fun').setup()                            -- useless but fun

-- theme setup

require('theme-gruvbox').setup()                  -- needs to be last
-- require('theme-alabaster').setup()                  -- needs to be last
