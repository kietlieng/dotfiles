local F = {}

function F.setup()
  -- https://github.com/wellle/targets.vim
  -- instead of creating these all by hand.  Do them with this function
  local function setupKeys(aMany, aAction)

    local command     = ":norm " .. aAction
    local key         = aAction
    local wIndex      = 1

    while wIndex < aMany
    do

      command = command .. "."
      wIndex = wIndex + 1
      vim.keymap.set("n", wIndex .. key, command .. "<CR>", { silent = true, remap = false })

    end

  end

  -- single quote
  setupKeys(5, 'daa')

    -- targets mapping for arguements
  --map( "n", "2daa", ":norm daa.<CR>", G_SILENT_NO_REMAP ) -- targets
  --map( "n", "3daa", ":norm daa..<CR>", G_SILENT_NO_REMAP ) -- targets
  --map( "n", "4daa", ":norm daa...<CR>", G_SILENT_NO_REMAP ) -- targets

end

return F
