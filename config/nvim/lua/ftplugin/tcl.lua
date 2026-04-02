vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tcl' },
  callback = function() vim.treesitter.start() end,
})
