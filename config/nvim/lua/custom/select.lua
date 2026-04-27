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

function F.word()

  local wordUnderCursor = vim.fn.expand("<cWORD>")
  vim.fn.setreg('*', wordUnderCursor) -- copy to reg

end



-- selection
-- paired ', `, "
-- unpaired <>, (), {}, []

-- considered: mini.ai but you have to figure out if you want brackets or maching pairs
-- treesitter: probably a good bet since it's a symantic tree itself
-- write your own: may take this route but it's too hard to figure out


function F.selectContent(selectOnly)

  local bracket_pairs = {
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
  }

  local origPos = vim.api.nvim_win_get_cursor(0)
  local node = vim.treesitter.get_node()

  local startRow, startColumn, endRow, endColumn

  while node do
    local t = node:type()
    if t == 'string' or t == 'template_string' or t:match('string_literal') then
      -- Prefer the inner content node (skips the quote delimiters)
      local content_node = node
      for child in node:iter_children() do
        local ct = child:type()
        if ct == 'string_content' or ct == 'string_fragment' then
          content_node = child
          break
        end
      end
      startRow, startColumn, endRow, endColumn = content_node:range()
      break
    end

    local cc = node:child_count()
    if cc >= 2 then
      local first = node:child(0)
      local last = node:child(cc - 1)
      if bracket_pairs[first:type()] == last:type() then
        -- Select between the brackets (exclusive of the delimiters)
        local _, _, firstEndRow, firstEndColumn = first:range()
        local lastStartRow, lastStartColumn = last:range()
        startRow, startColumn, endRow, endColumn = firstEndRow, firstEndColumn, lastStartRow, lastStartColumn
        break
      end
    end

    node = node:parent()
  end

  if not startRow then
    -- Fallback: select the body of the enclosing function
    node = vim.treesitter.get_node()
    while node do
      local t = node:type()
      if t:match('function') or t:match('method') or t == 'arrow_function' then
        for child in node:iter_children() do
          local ct = child:type()
          if ct == 'block' or ct == 'body' or ct:match('_body$')
              or ct == 'compound_statement' or ct == 'statement_block' then
            startRow, startColumn, endRow, endColumn = child:range()
            break
          end
        end
        if startRow then break end
      end
      node = node:parent()
    end
  end

  if not startRow then
    vim.notify('not in a string, bracket, or function', vim.log.levels.WARN)
    return
  end

  -- Convert end-exclusive to inclusive for visual selection
  if endColumn == 0 then
    endRow = endRow - 1
    local line = vim.api.nvim_buf_get_lines(0, endRow, endRow + 1, false)[1] or ''
    endColumn = math.max(#line - 1, 0)
  else
    endColumn = endColumn - 1
  end

  vim.api.nvim_win_set_cursor(0, { startRow + 1, startColumn })
  vim.cmd('normal! v')
  vim.api.nvim_win_set_cursor(0, { endRow + 1, endColumn })
  if not selectOnly then
    vim.cmd('normal! "+y')
    vim.api.nvim_win_set_cursor(0, origPos)
  end

end

function F.expandContent(selectOnly)

  local bracket_pairs = {
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
  }

  local origPos = vim.api.nvim_win_get_cursor(0)

  -- Read the current/last visual selection (0-indexed, end-inclusive)
  local mode = vim.fn.mode()
  local selStartRow, selStartCol, selEndRow, selEndCol

  if mode == 'v' or mode == 'V' or mode == '\22' then
    local vPos = vim.fn.getpos('v')
    local cPos = vim.fn.getpos('.')
    selStartRow, selStartCol = vPos[2] - 1, vPos[3] - 1
    selEndRow, selEndCol = cPos[2] - 1, cPos[3] - 1
    if selStartRow > selEndRow or (selStartRow == selEndRow and selStartCol > selEndCol) then
      selStartRow, selEndRow = selEndRow, selStartRow
      selStartCol, selEndCol = selEndCol, selStartCol
    end
    local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
  else
    local sMark = vim.api.nvim_buf_get_mark(0, '<')
    local eMark = vim.api.nvim_buf_get_mark(0, '>')
    selStartRow, selStartCol = sMark[1] - 1, sMark[2]
    selEndRow, selEndCol = eMark[1] - 1, eMark[2]
  end

  -- Convert selection to end-exclusive [start, end) for comparisons
  local selEndExRow = selEndRow
  local selEndExCol = selEndCol + 1

  local function pos_lt(r1, c1, r2, c2)
    if r1 < r2 then return true end
    if r1 > r2 then return false end
    return c1 < c2
  end

  -- A range strictly contains the selection if it is at least as wide on both
  -- sides AND strictly larger on at least one side.
  local function strictly_contains(rStartRow, rStartCol, rEndRow, rEndCol)
    local startOk = pos_lt(rStartRow, rStartCol, selStartRow, selStartCol)
                    or (rStartRow == selStartRow and rStartCol == selStartCol)
    local endOk = pos_lt(selEndExRow, selEndExCol, rEndRow, rEndCol)
                  or (selEndExRow == rEndRow and selEndExCol == rEndCol)
    local strictlyLarger = pos_lt(rStartRow, rStartCol, selStartRow, selStartCol)
                           or pos_lt(selEndExRow, selEndExCol, rEndRow, rEndCol)
    return startOk and endOk and strictlyLarger
  end

  local node = vim.treesitter.get_node({ pos = { selStartRow, selStartCol } })

  local startRow, startColumn, endRow, endColumn

  while node do
    local t = node:type()

    if t == 'string' or t == 'template_string' or t:match('string_literal') then
      local content_node = node
      for child in node:iter_children() do
        local ct = child:type()
        if ct == 'string_content' or ct == 'string_fragment' then
          content_node = child
          break
        end
      end
      local cStartRow, cStartCol, cEndRow, cEndCol = content_node:range()
      if strictly_contains(cStartRow, cStartCol, cEndRow, cEndCol) then
        startRow, startColumn, endRow, endColumn = cStartRow, cStartCol, cEndRow, cEndCol
        break
      end
    end

    local cc = node:child_count()
    if cc >= 2 then
      local first = node:child(0)
      local last = node:child(cc - 1)
      if bracket_pairs[first:type()] == last:type() then
        local _, _, firstEndRow, firstEndColumn = first:range()
        local lastStartRow, lastStartColumn = last:range()
        if strictly_contains(firstEndRow, firstEndColumn, lastStartRow, lastStartColumn) then
          startRow, startColumn, endRow, endColumn = firstEndRow, firstEndColumn, lastStartRow, lastStartColumn
          break
        end
      end
    end

    node = node:parent()
  end

  if not startRow then
    vim.notify('no enclosing pair to expand into', vim.log.levels.WARN)
    return
  end

  -- Convert end-exclusive to inclusive for visual selection
  if endColumn == 0 then
    endRow = endRow - 1
    local line = vim.api.nvim_buf_get_lines(0, endRow, endRow + 1, false)[1] or ''
    endColumn = math.max(#line - 1, 0)
  else
    endColumn = endColumn - 1
  end

  vim.api.nvim_win_set_cursor(0, { startRow + 1, startColumn })
  vim.cmd('normal! v')
  vim.api.nvim_win_set_cursor(0, { endRow + 1, endColumn })
  if not selectOnly then
    vim.cmd('normal! "+y')
    vim.api.nvim_win_set_cursor(0, origPos)
  end

end

return F
