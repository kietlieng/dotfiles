return {
  'L3MON4D3/LuaSnip',
  -- event = "VeryLazy",
  version = '2.*',
  build = 'make install_jsregexp',
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()  -- lead friendly-snippets support into luasnip
  end
}
