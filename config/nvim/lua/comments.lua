local F = {}

function F.comments(aAll, aCommentOut, aInvert)

  local commentCharacter  = ""
  local currentLine       = vim.fn.line('.')
  local fileExtension     = vim.fn.expand('%:e')
  local markerOffsetStart = "-1"
  local markerOffsetEnd   = "+1"
  local markerStart       = 0
  local markerEnd         = 0
  local lineTotal         = vim.fn.line('$')
  local enableEndMark     = true

  vim.cmd.normal("ml") -- set mark
  if fileExtension == 'tf' or fileExtension == 'yaml' or fileExtension == 'py' then
    commentCharacter = "#"
  elseif fileExtension == 'ts' or fileExtension == 'javascript' or fileExtension == 'js' then
    commentCharacter = "\\/\\/"
  elseif fileExtension == 'lua' then
    commentCharacter = "--"
  end


  if aAll then -- comment out all

    if aInvert then

      markerStart = vim.fn.line("'<")
      markerEnd = vim.fn.line("'>")

      --vim.notify("markOffsetEnd " .. tostring(markerOffsetEnd), "info", { title = "debug" })

      if markerStart ==  1 then
        markerOffsetStart = "-1"
      elseif markerStart == 0 then
        markerOffsetStart = ""
      end

      if markerEnd == lineTotal then
        markerOffsetEnd = ""
        enableEndMark   = false
      elseif markerEnd == (lineTotal - 1) then
        markerOffsetEnd = "+1"
      end

      --vim.notify("markOffsetEnd " .. tostring(markerOffsetEnd), "info", { title = "debug" })

      if aCommentOut then
         --vim.cmd(":silent 0,'<" .. markerOffsetStart .. "s/^/" .. commentCharacter .. "/")
         --vim.cmd(":silent '>" .. markerOffsetEnd .. ",$s/^/" .. commentCharacter .. "/")
         vim.cmd(":silent 0,'<" .. markerOffsetStart .. "s/^/" .. commentCharacter .. "/")

         if enableEndMark then

           --vim.notify("do marker 1")
           vim.cmd(":silent '>" .. markerOffsetEnd .. ",$s/^/" .. commentCharacter .. "/")

         end

      else
         vim.cmd(":silent 0,'<" .. markerOffsetStart .. "s/^" .. commentCharacter .. "//")

         if enableEndMark then

           --vim.notify("do marker 2")
           vim.cmd(":silent '>" .. markerOffsetEnd .. ",$s/^" .. commentCharacter .. "//")

         end

      end

    else

      if aCommentOut then
         vim.cmd("%s/^/" .. commentCharacter .. "/")
      else
         vim.cmd("%s/^" .. commentCharacter .. "//")
      end

    end

  else -- comment out only the current block

    local emptyLineNext     = vim.fn.search('^\\s*$', 'n', lineTotal)
    local emptyLinePrevious = vim.fn.search('^\\s*$', 'bn', 0, currentLine - 1)

    -- does not loop around
    if emptyLinePrevious < currentLine then
      if emptyLinePrevious <= 0 then
        emptyLinePrevious = 0
      else
        emptyLinePrevious = emptyLinePrevious + 1
      end
    else
      emptyLinePrevious = 0
    end

    --print("current next " .. emptyLineNext .. " current " .. currentLine)
    if (currentLine < emptyLineNext) and (emptyLineNext < lineTotal) then
      if emptyLineNext <= 0 then
        emptyLineNext = lineTotal
      else
        emptyLineNext = emptyLineNext - 1
      end
    else
      emptyLineNext = lineTotal
    end

    if aCommentOut then
       --vim.api.nvim_feedkeys('vip', 'n', true)
       vim.cmd(emptyLinePrevious .. "," .. emptyLineNext  .. "s/^/" .. commentCharacter .. "/")
       --print("previous " .. emptyLinePrevious .. " next " .. emptyLineNext)
     else
       --vim.api.nvim_feedkeys('vip', 'n', true)
       vim.cmd(emptyLinePrevious .. "," .. emptyLineNext .. "s/^" .. commentCharacter .. "//")
    end

  end

  vim.cmd.normal("`l") -- go back to mark
  vim.cmd("noh")       -- turn off highlight

end


function F.next()

    local lineTotal    = vim.fn.line('$')
    local emptyLineNext = vim.fn.search('^\\s*$', 'n', lineTotal)

    if emptyLineNext > 0 then
        print("Nearest next empty line found at line:", emptyLineNext)
    else
        print("No empty line found.")
    end

end

return F
