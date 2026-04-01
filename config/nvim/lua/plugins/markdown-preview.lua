return {
  -- 'iamcco/markdown-preview.nvim', original but not up to date
  'UtkarshKunwar/markdown-preview.nvim',
  -- event = "VeryLazy",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    vim.fn["mkdp#util#install"]()
	-- "cd app && yarn install",
  end,
  init = function()

		-- vim.g.mkdp_filetypes = { "markdown", "text" }
		vim.g.mkdp_command_for_global = 1
    -- Other settings
    -- vim.g.mkdp_auto_start = 0
    -- vim.g.mkdp_auto_close = 1
    vim.g.mkdp_theme = "dark"

  end,
  ft = { "markdown", "text" },
}
