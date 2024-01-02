local F = {}

function F.comments(aAll, aCommentOut, aInvert, aSelectedOnly, aNormalMode)

  local commentCharacter  = "\\/\\/"
  local currentLine       = vim.fn.line('.')
  local fileExtension     = vim.fn.expand('%:e')
  local filename          = vim.fn.expand('%:t')
  local markerOffsetStart = "-1"
  local markerOffsetEnd   = "+1"
  local markerStart       = vim.fn.line("'<")
  local markerEnd         = vim.fn.line("'>")
  local lineTotal         = vim.fn.line('$')
  local enableEndMark     = true
  local cmdMode           = ":silent "
  local searchAndReplace1 = ""
  local searchAndReplace2 = ""

  vim.cmd.normal("ml") -- set mark

  if filename == 'kitty.conf' or
     fileExtension == 'tf' or
     fileExtension == 'yaml' or
     fileExtension == 'py' or
     fileExtension == 'sh' or
     fileExtension == 'fwd' then

    commentCharacter = "#"

  elseif fileExtension == 'ts' or
    fileExtension == 'javascript' or
    fileExtension == 'js' then

    commentCharacter = "\\/\\/"

  elseif fileExtension == 'lua' then

    commentCharacter = "--"

  end

  if aSelectedOnly then

    if aCommentOut then

      if aNormalMode then
        vim.cmd(cmdMode .. "s/^/" .. commentCharacter .. "/")
      else
        vim.cmd(cmdMode .. "'<,'>s/^/" .. commentCharacter .. "/")
      end

    else -- uncomment

      if aNormalMode then
        vim.cmd(cmdMode .. "s/^" .. commentCharacter .. "//")
      else
        vim.cmd(cmdMode .. "'<,'>s/^" .. commentCharacter .. "//")
      end

    end

  else

    if aAll then -- global comment

      if aInvert then -- invert

        --vim.notify("markOffsetEnd " .. tostring(markerOffsetEnd), "info", { title = "debug" })

        if markerStart == 0 then
          markerOffsetStart = ""
        end

        if markerEnd == lineTotal then
          markerOffsetEnd = ""
          enableEndMark   = false
        end

        --vim.notify("markOffsetEnd " .. tostring(markerOffsetEnd), "info", { title = "debug" })

        if aCommentOut then -- comment out

          vim.cmd(cmdMode .. "0,'<" .. markerOffsetStart .. "s/^/" .. commentCharacter .. "/")

          if enableEndMark then

            --vim.notify("do marker 1")
            vim.cmd(cmdMode .. "'>" .. markerOffsetEnd .. ",$s/^/" .. commentCharacter .. "/")

          end

        else -- uncomment

          vim.cmd(cmdMode .. "0,'<" .. markerOffsetStart .. "s/^" .. commentCharacter .. "//")

          if enableEndMark then

            --vim.notify("do marker 2")
            vim.cmd(cmdMode .. "'>" .. markerOffsetEnd .. ",$s/^" .. commentCharacter .. "//")

          end

        end

      else -- regular

        if aCommentOut then
          vim.cmd(cmdMode .. "%s/^/" .. commentCharacter .. "/")
        else
          vim.cmd(cmdMode .. "%s/^" .. commentCharacter .. "//")
        end

      end

    else -- block comment

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

      --vim.notify("current next " .. emptyLineNext .. " current " .. currentLine)
      if (currentLine < emptyLineNext) and (emptyLineNext < lineTotal) then
        if emptyLineNext <= 0 then
          emptyLineNext = lineTotal
        else
          emptyLineNext = emptyLineNext - 1
        end
      else
        emptyLineNext = lineTotal
      end


      if aInvert then -- invert

        --vim.notify("do nothing")

        if markerStart > 0 then -- no range if beginning of file

          vim.cmd(cmdMode .. "" .. emptyLinePrevious .. "," .. markerStart  .. "-1s/^/" .. commentCharacter .. "/")

        end

        if markerEnd < lineTotal then -- no range if end of line

          --vim.notify("markerEnd " .. markerEnd .. " total " .. lineTotal )
          vim.cmd(cmdMode .. "" .. markerEnd .. "+1," .. emptyLineNext  .. "s/^/" .. commentCharacter .. "/")

        end

      else

        if aCommentOut then
          --vim.api.nvim_feedkeys('vip', 'n', true)
          vim.cmd(cmdMode .. "" .. emptyLinePrevious .. "," .. emptyLineNext  .. "s/^/" .. commentCharacter .. "/")
          --vim.notify("previous " .. emptyLinePrevious .. " next " .. emptyLineNext)
        else
          --vim.api.nvim_feedkeys('vip', 'n', true)
          vim.cmd(cmdMode .. "" .. emptyLinePrevious .. "," .. emptyLineNext .. "s/^" .. commentCharacter .. "//")
        end

      end
    end
  end

  vim.cmd.normal("`l") -- go back to mark
  vim.cmd("noh")       -- turn off highlight

end


function F.next()

  local lineTotal    = vim.fn.line('$')
  local emptyLineNext = vim.fn.search('^\\s*$', 'n', lineTotal)

  if emptyLineNext > 0 then
    vim.notify("Nearest next empty line found at line:", emptyLineNext)
  else
    vim.notify("No empty line found.")
  end

end

return F
