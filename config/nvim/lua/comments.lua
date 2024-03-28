local F = {}

--regular
--all
--aNormalMode
--commentout
--invert
--buffer

function F.comments(aRegular, aNormalMode, aAll, aCommentOut, aInvert, aBuffer)

  local commentCharacter  = "\\/\\/"
  local currentLine       = vim.fn.line('.')
  local fileExtension     = vim.fn.expand('%:e')
  local filename          = vim.fn.expand('%:t')
  local markerOffsetStart = "-1"
  local markerOffsetEnd   = "+1"
  local markerStart       = vim.fn.line("'<")
  local markerEnd         = vim.fn.line("'>")
  local linesTotal        = vim.fn.line('$')
  local enableEndMark     = true
  local cmdMode           = ":silent "
  local emptyLinePrevious = vim.fn.search('^\\s*$', 'bn', 0, currentLine - 1)
  local emptyLineNext     = vim.fn.search('^\\s*$', 'n', linesTotal)

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
  if (currentLine < emptyLineNext) and (emptyLineNext < linesTotal) then
    if emptyLineNext <= 0 then
      emptyLineNext = linesTotal
    else
      emptyLineNext = emptyLineNext - 1
    end
  else
    emptyLineNext = linesTotal
  end

  vim.cmd.normal("ml") -- set mark

  if filename == 'kitty.conf' or
     filename == 'config' or -- might be ssh config
     filename == 'skhdrc' or -- hotkeys
     filename == '.zshrc' or
     filename == '.yabairc' or
     filename == '.gitlab-ci.yml' or
     fileExtension == 'tf' or
     fileExtension == 'yaml' or
     fileExtension == 'yml' or
     fileExtension == 'py' or
     fileExtension == 'sh' or
     fileExtension == 'zsh' or
     fileExtension == 'fwd' then

    commentCharacter = "#"

  elseif fileExtension == 'ts' or
    fileExtension == 'javascript' or
    fileExtension == 'js' then

    commentCharacter = "\\/\\/"

  elseif fileExtension == 'lua' then

    commentCharacter = "--"

  end

  local commentedOutPrevious = vim.fn.search('^' .. commentCharacter, 'bn', 0, currentLine - 1)
  local commentedOutNext     = vim.fn.search('^' .. commentCharacter, 'n', linesTotal)

  if aRegular then

    if aBuffer then

      if aCommentOut then

        --vim.notify("comment out")

        if (0 < emptyLinePrevious) and (emptyLinePrevious < currentLine) then

          --vim.notify("start commentout 0," .. emptyLinePrevious)
          vim.cmd(cmdMode .. "0," .. emptyLinePrevious .. "-1s/^/" .. commentCharacter .. "/")

        end

        if (currentLine < linesTotal) and (currentLine < emptyLineNext) and (emptyLineNext < linesTotal) then -- no range if end of line

          --vim.notify("markerEnd " .. markerEnd .. " total " .. linesTotal )
          --vim.notify("end commentout " .. " markerEnd " .. markerEnd .. " emptyLineNext " .. emptyLineNext)
          vim.cmd(cmdMode .. emptyLineNext .. "+1," .. linesTotal  .. "s/^/" .. commentCharacter .. "/")

        end


      else

        --vim.notify("uncomment")
        if (1 < commentedOutPrevious) and (commentedOutPrevious < currentLine) then

          --vim.notify("start uncomment 0," .. commentedOutPrevious)
          vim.cmd(cmdMode .. "0," .. commentedOutPrevious .. "s/^" .. commentCharacter .. "//")

        end

        if (currentLine < linesTotal) and (currentLine < commentedOutNext) and (commentedOutNext < linesTotal) then -- no range if end of line

          --vim.notify("markerEnd " .. markerEnd .. " total " .. linesTotal )
          --vim.notify("end uncomment " .. " markerEnd " .. markerEnd .. " commentedOutNext " .. commentedOutNext)
          vim.cmd(cmdMode .. commentedOutNext .. "," .. linesTotal  .. "s/^" .. commentCharacter .. "//")

        end
      end

    else

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

    end

  else

    if aAll then -- global comment

      if aInvert then -- invert

        --vim.notify("markOffsetEnd " .. tostring(markerOffsetEnd), "info", { title = "debug" })

        if markerStart == 0 then
          markerOffsetStart = ""
        end

        if markerEnd == linesTotal then
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

      if aInvert then -- invert

        --vim.notify("do nothing")

        if markerStart > 0 then -- no range if beginning of file

          vim.cmd(cmdMode .. emptyLinePrevious .. "," .. markerStart  .. "-1s/^/" .. commentCharacter .. "/")

        end

        if markerEnd < linesTotal then -- no range if end of line

          --vim.notify("markerEnd " .. markerEnd .. " total " .. linesTotal )
          vim.cmd(cmdMode .. markerEnd .. "+1," .. emptyLineNext  .. "s/^/" .. commentCharacter .. "/")

        end

      else

        if aCommentOut then
          --vim.api.nvim_feedkeys('vip', 'n', true)
          vim.cmd(cmdMode .. emptyLinePrevious .. "," .. emptyLineNext  .. "s/^/" .. commentCharacter .. "/")
          --vim.notify("previous " .. emptyLinePrevious .. " next " .. emptyLineNext)
        else
          --vim.api.nvim_feedkeys('vip', 'n', true)
          vim.cmd(cmdMode .. emptyLinePrevious .. "," .. emptyLineNext .. "s/^" .. commentCharacter .. "//")
        end

      end
    end
  end

  vim.cmd.normal("`l") -- go back to mark
  vim.cmd("noh")       -- turn off highlight

end

function F.next()

  local linesTotal    = vim.fn.line('$')
  local emptyLineNext = vim.fn.search('^\\s*$', 'n', linesTotal)

  if emptyLineNext > 0 then
    vim.notify("Nearest next empty line found at line:", emptyLineNext)
  else
    vim.notify("No empty line found.")
  end

end

return F
