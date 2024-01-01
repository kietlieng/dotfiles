local F = {}

function F.comments(aAll, aCommentOut, aInvert, aSelectedOnly, aNormalMode)

  local commentCharacter  = ""
  local currentLine       = vim.fn.line('.')
  local fileExtension     = vim.fn.expand('%:e')
  local filename          = vim.fn.expand('%:t')
  local markerOffsetStart = "-1"
  local markerOffsetEnd   = "+1"
  local markerStart       = vim.fn.line("'<")
  local markerEnd         = vim.fn.line("'>")
  local lineTotal         = vim.fn.line('$')
  local enableEndMark     = true

  print("mode " .. vim.fn.mode())

  vim.cmd.normal("ml") -- set mark

  if filename == 'kitty.conf' then
    commentCharacter = "#"
  else
    if fileExtension == 'tf' or fileExtension == 'yaml' or fileExtension == 'py' or fileExtension == 'sh' then
      commentCharacter = "#"
    elseif fileExtension == 'ts' or fileExtension == 'javascript' or fileExtension == 'js' then
      commentCharacter = "\\/\\/"
    elseif fileExtension == 'lua' then
      commentCharacter = "--"
    end
  end


  if aSelectedOnly then

    --print("mode " .. vim.fn.mode())

    if aCommentOut then

      if aNormalMode then
        vim.cmd(":silent s/^/" .. commentCharacter .. "/")
      else
        vim.cmd(":silent '<,'>s/^/" .. commentCharacter .. "/")
      end

    else -- uncomment

      if aNormalMode then
        vim.cmd(":silent s/^" .. commentCharacter .. "//")
      else
        vim.cmd(":silent '<,'>s/^" .. commentCharacter .. "//")
      end

    end

  else

    if aAll then -- global comment

      if aInvert then -- invert

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

        if aCommentOut then -- comment out
          --vim.cmd(":silent 0,'<" .. markerOffsetStart .. "s/^/" .. commentCharacter .. "/")
          --vim.cmd(":silent '>" .. markerOffsetEnd .. ",$s/^/" .. commentCharacter .. "/")
          vim.cmd(":silent 0,'<" .. markerOffsetStart .. "s/^/" .. commentCharacter .. "/")

          if enableEndMark then

            --vim.notify("do marker 1")
            vim.cmd(":silent '>" .. markerOffsetEnd .. ",$s/^/" .. commentCharacter .. "/")

          end

        else -- uncomment

          vim.cmd(":silent 0,'<" .. markerOffsetStart .. "s/^" .. commentCharacter .. "//")

          if enableEndMark then

            --vim.notify("do marker 2")
            vim.cmd(":silent '>" .. markerOffsetEnd .. ",$s/^" .. commentCharacter .. "//")

          end

        end

      else -- regular

        if aCommentOut then
          vim.cmd("%s/^/" .. commentCharacter .. "/")
        else
          vim.cmd("%s/^" .. commentCharacter .. "//")
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



      if aInvert then -- invert

        --print("do nothing")

        if markerStart > 0 then -- no range if beginning of file

          vim.cmd(emptyLinePrevious .. "," .. markerStart  .. "-1s/^/" .. commentCharacter .. "/")

        end

        if markerEnd < lineTotal then -- no range if end of line

          --print("markerEnd " .. markerEnd .. " total " .. lineTotal )
          vim.cmd(markerEnd .. "+1," .. emptyLineNext  .. "s/^/" .. commentCharacter .. "/")

        end

      else

        if aCommentOut then
          --vim.api.nvim_feedkeys('vip', 'n', true)
          vim.cmd(emptyLinePrevious .. "," .. emptyLineNext  .. "s/^/" .. commentCharacter .. "/")
          --print("previous " .. emptyLinePrevious .. " next " .. emptyLineNext)
        else
          --vim.api.nvim_feedkeys('vip', 'n', true)
          vim.cmd(emptyLinePrevious .. "," .. emptyLineNext .. "s/^" .. commentCharacter .. "//")
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
    print("Nearest next empty line found at line:", emptyLineNext)
  else
    print("No empty line found.")
  end

end

return F
