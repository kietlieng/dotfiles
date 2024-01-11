local F = {}

function F.word()

  local selectedText = vim.fn.getreg('')
  local characterPattern = "[\"':;]*"
  selectedText = selectedText:gsub("^" .. characterPattern .. "(.-)" .. characterPattern .. "$", "%1")
  vim.fn.setreg('*', selectedText)

end

return F
