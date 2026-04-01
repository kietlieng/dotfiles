return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
	configs = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
				disable = { "tcl" },  -- disable highlighting for tcl
			},
		})
	end
}
