-- setup snippet engine

return {
  {
    'junegunn/fzf',
    event = "VeryLazy",
    build = './install --bin',
  }
}
