local F = {}


function F.setup()

  -- telescope setup
  require('telescope').setup {
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      },
      fzy_native = {
          override_generic_sorter = true,
          override_file_sorter = true,
      }
    }
  }

  require('telescope').load_extension('fzf')
--  require('telescope').load_extension('file_browser')

end

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

  require('telescope.builtin').find_files { cwd = dirTarget }

end


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

    value = require('telescope.builtin').find_files { }
    print(value)

  else

    value = require('telescope.builtin').find_files { cwd = vim.fn.expand(dirExpression) }
    print(value)

  end

end

return F
