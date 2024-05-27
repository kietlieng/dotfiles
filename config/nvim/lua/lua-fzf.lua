local F = {}
local fzf = require("fzf")

function F.readFiles(argType)

  local argPath = ''

  if argType == 'tmp' then
    argPath = ' /tmp'
  elseif argType == 'currentFileDirectory' then -- currentDirectory
    argPath = ' ' .. vim.fn.expand('%:p:h')
  end

  coroutine.wrap(function()
    local result = fzf.fzf("rg --files " .. argPath, "--ansi")
    if result then
      vim.cmd(':r ' .. argPath .. '/' .. result[1])
    end
  end)()

end

function F.readJumpFiles(argType)

  local jumpResults = ''
  coroutine.wrap(function()
    jumpResults = fzf.fzf("cat ~/.jumpscript | awk -F'^' '{print $2}'", "--ansi")
    if jumpResults then
      coroutine.wrap(function()
        local results = fzf.fzf("rg --files " .. jumpResults[1], "--ansi")

        if results then
          vim.cmd(':r ' .. results[1])
        end

      end)()
    end
  end)()

end


return F
