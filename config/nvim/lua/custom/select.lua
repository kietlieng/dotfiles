local F = {}

--regular
--all
--aNormalMode
--commentout
--invert
--buffer


function F.headsOrTails( argTag, argCurrentBuffer, argHeadWord, argTailWord, argTailCommentChar)

  for k, v in pairs(argCurrentBuffer) do

    for firstWord in string.gmatch( v, "%S+") do

      -- print(argTag, firstWord)
      -- print(string.sub(firstWord, 1, 1))

      local firstChar = string.sub(firstWord, 1, 1)

      if argTailCommentChar ~= firstChar then
        local headStart, headFinish = string.find(argHeadWord, firstWord)
        local tailStart, tailFinish = string.find(argTailWord, firstWord)

        if headStart then
          -- print("line is head 1")
          return 1
        else

          if tailStart then
            -- print("line is tail -1")
            return -1
          end
          -- print("neutral")
          return 0

        end
      end
      break

    end

  end

  -- print("return 0")
  return 0

end

function F.findBegining(argHeadWord, argTailWord, argTailCommentChar)

  local currentBuffer       = vim.api.nvim_get_current_buf()
  local tempRow, currentCol = unpack(vim.api.nvim_win_get_cursor(0))
  local lines               = vim.api.nvim_buf_get_lines(currentBuffer, 0, -1, true)

  local stack = 0
  local first = true

  while 0 < tempRow do

    lines = vim.api.nvim_buf_get_lines(currentBuffer, tempRow - 1, tempRow, false)
    stack = stack + F.headsOrTails("begin", lines, argHeadWord, argTailWord, argTailCommentChar)
    -- print("stack", stack, tempRow)

    -- safeguard stack to reset on first try
    if first and (stack < 0) then
      stack = 0
    end

    first = false
    if stack > 0 then
      return stack, (tempRow + 1)
    end
    tempRow = tempRow - 1

  end

end

function F.findEnding(argTempRow, argHeadWord, argTailWord, argTailCommentChar)

  local currentBuffer = vim.api.nvim_get_current_buf()
  -- print("argTempRow", argTempRow)
  argTempRow          = argTempRow - 1
  local lines         = vim.api.nvim_buf_get_lines(currentBuffer, 0, -1, true)
  local numberOfLines = #lines

  local stack = 0
  local first = true

  while argTempRow < (numberOfLines + 1) do

    lines = vim.api.nvim_buf_get_lines(currentBuffer, argTempRow, argTempRow + 1, false)
    stack = stack + F.headsOrTails("end", lines, argHeadWord, argTailWord, argTailCommentChar)

    -- safeguard stack to reset on first try
    if first and (stack > 0) then
      stack = 0
    end

    first = false

    -- print("stack", stack, argTempRow, numberOfLines)
    if stack < 0 then
      return stack, argTempRow
    end
    argTempRow = argTempRow + 1

  end
  print("end of the line")
  return stack, argTempRow

end

function F.bracket()

  local fileExtension = vim.fn.expand('%:e')
  local placeholderRow, currentCol = unpack(vim.api.nvim_win_get_cursor(0))

  local beginLine  = 0
  local beginStack = 0
  local endLine    = 0
  local endStack   = 0

  if fileExtension == 'fish' then

    beginStack, beginLine = F.findBegining("function,if,while,switch", "end","#")
    endStack, endLine = F.findEnding(placeholderRow, "function,if,while,switch", "end", "#")

    -- print("beginLine", beginLine, beginStack, "endLine", endLine, endStack)
    if beginLine and endLine then

      -- list from bottom to top 
      vim.api.nvim_win_set_cursor(0, {endLine, 0})
      vim.cmd("normal! V")
      vim.api.nvim_win_set_cursor(0, {beginLine, 0})

    else
      print("no matches")
    end

  else
    vim.cmd.normal("vi{")
  end

end

function F.definition()

  local fileExtension = vim.fn.expand('%:e')
  local beginLine  = 0
  local beginStack = 0
  local endLine    = 0
  local endStack   = 0

  if fileExtension == 'fish' then

    beginStack, beginLine = F.findBegining("function", "","#")
    -- print("beginLine", beginLine)
    endStack, endLine = F.findEnding(beginLine, "function,if,while,switch", "end", "#")

    if beginLine and endLine then
      -- print("beginLine", beginLine, beginStack, "endLine", endLine, endStack)
      vim.api.nvim_win_set_cursor(0, {endLine, 0})
      vim.cmd("normal! V")
      vim.api.nvim_win_set_cursor(0, {beginLine, 0})
    end

  else

    vim.cmd.normal("vi{")

  end

end

function F.openLink()

  local wordUnderCursor = vim.fn.expand("<cWORD>")
  local location = vim.fn.expand("%:p:h")
  require("io").popen("callterminal " .. location .. " s -l \"" .. wordUnderCursor .. "\"")

end

return F
