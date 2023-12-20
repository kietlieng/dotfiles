local F = {}

function F.comments(aCommentOut)

  local fileExtension = vim.fn.expand('%:e')
  local commentCharacter = ""

  vim.cmd(":normal ml") -- set mark
  if fileExtension == 'tf' or fileExtension == 'yaml' then
    commentCharacter = "#"
  elseif fileExtension == 'ts' or fileExtension == 'javascript' then
    commentCharacter = "\\/\\/"
  end

  if aCommentOut then
     vim.cmd("%s/^/" .. commentCharacter .. "/")
   else
     vim.cmd("%s/^" .. commentCharacter .. "//")
  end
  vim.cmd(":normal `l") -- go back to mark

end


return F
