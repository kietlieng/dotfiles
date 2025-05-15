local F = {}
local fzf = require("fzf")

function F.buffers()

  require('fzf-lua').buffers({
  })

end

-- Grep Fuzzy / Live
function F.grepLevel(fLevel, aFuzzy)

  aFuzzy = aFuzzy or 1

  vim.fn.setreg('r', vim.fn.getcwd()) -- rest register to current working directory

  if fLevel == -2 then

    vim.fn.setreg('r', vim.fn.getcwd()) -- rest register to current working directory

  elseif fLevel == -1 then -- from get root

    local currentRepo = vim.fn.expand('%:p:h')
    local io = require("io")
    local fOutput = io.popen("cd " .. currentRepo .. "; callgitrootfolder " .. currentRepo)
    local gitRoot = fOutput:read('*all')

    vim.fn.setreg('r', gitRoot) -- figure out the git root and set the r register to that

  else

    local dirExpression = '%:p:h'
    local aDepth = fLevel

    while aDepth > 0 do

      dirExpression = dirExpression .. ':h'
      aDepth = aDepth - 1

    end

    vim.fn.setreg('r', vim.fn.expand(dirExpression)) -- if not expand on `%:p:h' and set register to that

  end

  -- vim.cmd([[Rg]]) -- run the command to get the rip grepper using register

  local pprompt = vim.fn.getreg('r')

  if aFuzzy == 2 then

    require('fzf-lua').live_grep({
      prompt = "live ",
      cwd = pprompt,
    })

  else

    require('fzf-lua').grep_visual({
      prompt = "fzf ",
      cwd = pprompt,
    })

  end

end

-- File depth
function F.dirDepthJump(aDepth)

  local dirExpression = '%:p:h'

  if aDepth == -2 then

    dirExpression = ''

  elseif aDepth == -1 then

    -- find root directory of the file open.  Sometimes will open a file
    -- from a separate location than your current one
    local currentRepo = vim.fn.expand('%:p:h')
    local io = require("io")
    local fOutput = io.popen("callgitrootfolder " .. currentRepo)
    dirExpression = fOutput:read('*all')
    fOutput:close()

    print(dirExpression)

  else

    if aDepth == -99 then

      -- find root directory of where vim ran. This doesn't account for
      -- the location of the directory the current file is open from. Just where
      -- the vim program is running from
      local fOutput = io.popen("callgitrootfolder")
      dirExpression = fOutput:read('*all')
      fOutput:close()

--      print(dirExpression)

    elseif aDepth > 0 then

      while aDepth > 0 do

        dirExpression = dirExpression .. ':h'
        aDepth = aDepth - 1

      end

    end

  end

  --print("expression " .. dirExpression)

  if dirExpression == "" then

    require('fzf-lua').files({
    })
    -- print(dirExpression)

  else

    require('fzf-lua').files({
      cwd = vim.fn.expand(dirExpression),
    })
    -- print(value)

  end

end

-- General file jump
function F.dirJump(aTarget)

  local dirTarget = ""
  if aTarget == 'bigip' then
    dirTarget = "~/lab/repos/bigipapi"
  elseif aTarget == 'dns_dev' then
    dirTarget = "~/lab/repos/edge/dns-internal-dev/zones"
  elseif aTarget == 'nameserver' then
    dirTarget = "~/lab/repos/nameserver/roles/nsupdate/templates/fwd"
  elseif aTarget == 'dns_prod_internal' then
    dirTarget = "~/lab/repos/edge/dns-internal-prod/zones"
  elseif aTarget == 'lua' then
    dirTarget = "~/.config/nvim"
  elseif aTarget == 'dns_public' then
    dirTarget = "~/lab/repos/edge/public-dns-repo/zones"
  elseif aTarget == 'script' then
    dirTarget = "~/lab/scripts"
  elseif aTarget == 'tmuxp' then
    dirTarget = "~/lab/scripts/tmuxp"
  elseif aTarget == 'palo' then
    dirTarget = "~/lab/repos/dev-paloalto"
  elseif aTarget == 'cert' then
    dirTarget = "~/lab/repos/cert-alert"
  elseif aTarget == 'irules' then
    dirTarget = "~/lab/repos/irules-engine/modules"
  end

  require('fzf-lua').files({
    cwd = dirTarget,
  })


end


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
        require('fzf-lua').files({
          cwd = vim.fn.expand(jumpResults[1]),
        })

    end
  end)()

end

function F.openWorkingJumpFile()

  local jumpResults = ''


  local io = require("io")
  local fOutput = io.popen("cat ~/.jumplist")
  jumpResults = fOutput:read('*all')
  fOutput:close()

  require('fzf-lua').files({
    cwd = jumpResults
  })

end

return F
