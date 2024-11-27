local F = {}

function F.setup()

  vim.opt.termguicolors = true
  require("bufferline").setup{}

end

return F
