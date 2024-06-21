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
      vim.cmd(':r ' .. result[1])
    end
  end)()

end

function F.readJumpFiles()

  local jumpResults = ''
  local results = ''
  coroutine.wrap(function()

    jumpResults = fzf.fzf("cat ~/.jumpscript | awk -F'^' '{print $2}'", "--ansi")
    if jumpResults then

        local results = fzf.fzf("rg --files " .. jumpResults[1], "--ansi")

        if results then
          vim.cmd(':r ' .. results[1])
        end

    end
  end)()

end


function F.openJumpFiles()

  local jumpResults = ''
  coroutine.wrap(function()
    jumpResults = fzf.fzf("cat ~/.jumpscript | awk -F'^' '{print $2}'", "--ansi")
    if jumpResults then
        require('telescope.builtin').find_files { cwd = vim.fn.expand(jumpResults[1]) }
    end
  end)()

end

function F.openWorkingJumpFile()

  local jumpResults = ''


  local io = require("io")
  local fOutput = io.popen("cat ~/.jumplist")
  jumpResults = fOutput:read('*all')
  fOutput:close()

  require('telescope.builtin').find_files { cwd = jumpResults }

end

return F
