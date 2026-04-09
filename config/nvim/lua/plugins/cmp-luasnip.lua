return {
  'L3MON4D3/LuaSnip',
  -- event = "VeryLazy",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = '2.*',
  build = 'make install_jsregexp',
  config = function()

    local luasnip = require('luasnip')

    require("luasnip.loaders.from_vscode").lazy_load()  -- lead friendly-snippets support into luasnip
		require('luasnip.loaders.from_vscode').lazy_load({
      paths = { '~/.config/nvim/snippets' }
    })

		luasnip.config.set_config({
      history = true,  -- Keep last snippet for jumping back
      updateevents = "TextChanged,TextChangedI",  -- Update as you type
    })
  end
}
