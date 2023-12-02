local F = {}

function F.setup()

  -- instead of creating these all by hand.  Do them with this function
  local function setupKeys(aMany, aAction,  aChar)

    local command     = ""
    local commandChar = aChar
    local key         = ""
    local wIndex      = 2

    -- need to escape the charater
    if aChar == "'" then
      commandChar = "\\\'"
    end

    while wIndex < aMany
    do

      key = wIndex .. aAction .. "i" .. aChar
      command = "<cmd>lua require('quotes').jumpquote(" .. wIndex .. ", '" .. aAction  .. "', '" .. commandChar .. "')<CR>"
      vim.keymap.set("n", key, command, { silent = true, remap = false })

      wIndex = wIndex + 1

    end

  end

  -- single quote
  setupKeys(5, 'c', "'")
  setupKeys(5, 'd', "'")
  setupKeys(5, 'v', "'")
  setupKeys(5, 'y', "'")

  -- quotes
  setupKeys(5, 'c', '"')
  setupKeys(5, 'd', '"')
  setupKeys(5, 'v', '"')
  setupKeys(5, 'y', '"')

  -- parens
  setupKeys(5, 'c', '(')
  setupKeys(5, 'd', '(')
  setupKeys(5, 'v', '(')
  setupKeys(5, 'y', '(')

  -- brackets
  setupKeys(5, 'c', '[')
  setupKeys(5, 'd', '[')
  setupKeys(5, 'v', '[')
  setupKeys(5, 'y', '[')

  -- squigs brances
  setupKeys(5, 'c', '{')
  setupKeys(5, 'd', '{')
  setupKeys(5, 'v', '{')
  setupKeys(5, 'y', '{')

end

function F.jumpquote(aIndex, aAction, aChar)

  local isYank         = false
  local yankCommand    = ""
  -- get last position
  local targetPosition = ( aIndex * 2 ) - 1

  -- match only singly
  if (aChar == '(') or (aChar == '[') or (aChar == '{')  then
    targetPosition = aIndex
  end
  --" negative

  -- if yanking move back to mark
  if (aAction == 'y') then

    isYank      = true
    yankCommand = "\"*" -- copy to register 

  end


  local actualChar = "f"
  if targetPosition < 0 then

    actualChar     = "F"
    targetPosition = vim.fn.abs(targetPosition)

  end

  --echo "position "  . targetPosition . " last char " . nr2char(getchar())
  --print(targetPosition .. actualChar .. aChar)

  if isYank then -- mark location
    vim.cmd.normal('ml')
  end

  vim.cmd.normal(targetPosition .. actualChar .. aChar)
  vim.cmd.normal(yankCommand .. aAction .. "i" .. aChar)

  if isYank then -- jump back to location
    vim.cmd.normal('`l')
  end

end

return F
