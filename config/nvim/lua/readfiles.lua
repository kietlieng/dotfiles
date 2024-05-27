local F = {}
local fzf = require("fzf")

function F.browse(argType)

  local argPath = ''

  if argType == 'tmp' then
    argPath = ' /tmp'
  elseif argType == 'currentFileDirectory' then -- currentDirectory
    argPath = ' ' .. vim.fn.expand('%:p:h')
  end

  coroutine.wrap(function()
    local result = fzf.fzf("ls -1" .. argPath, "--ansi")
    if result then
      vim.cmd(':r ' .. argPath .. '/' .. result[1])
    end
  end)()

end


return F
