local F = {}

function F.toClipboard(aTarget)

  local regValue = vim.fn.getreg(aTarget)
  regValue = regValue:gsub("\\<", "")
  regValue = regValue:gsub("\\>", "")
  vim.fn.setreg('*', regValue)

end

return F
