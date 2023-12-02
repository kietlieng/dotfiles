local F = {}


function F.setup()

  -- telescope setup
  require('telescope').setup {
      extensions = {
          fzy_native = {
              override_generic_sorter = false,
              override_file_sorter = true,
          }
      }
  }

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

    local currentRepo = vim.fn.expand('%:p:h')
    local io = require("io")
    local fOutput = io.popen("cd " .. currentRepo .. "; callgitrootfolder.sh")
    dirExpression = fOutput:read('*all')
    local rc = {fOutput:close()}

    --print(values)

  else

    if aDepth > 0 then

      while aDepth > 0 do

        dirExpression = dirExpression .. ':h'
        aDepth = aDepth - 1

      end

    end

  end

  --print("expression " .. dirExpression)

  if dirExpression == "" then

    require('telescope.builtin').find_files { }

  else

    require('telescope.builtin').find_files { cwd = vim.fn.expand(dirExpression) }

  end

end

return F
