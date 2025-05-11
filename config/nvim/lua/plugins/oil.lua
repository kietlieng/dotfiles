-- oil setup

return {
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require("oil").setup() -- default setup
    end
  }
}
