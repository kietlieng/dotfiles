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
require('lazy').setup( {
    { import = "plugins" },
    { import = "themes" },
  },
  {

   ui = { border = 'rounded' },
   dev = { path = vim.g.projects_dir },
   install = {
       -- Do not automatically install on startup.
       missing = false,
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
