local F = {}

--regular
--all
--aNormalMode
--commentout
--invert
--buffer

function F.zkenv(aEnv)

  os.execute("echo '" .. aEnv .. "' > ~/.pacenv")

end

function F.zkget()

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
--  local end_col = end_pos[3] + 1  -- Add 1 to include the last character
  local end_col = end_pos[3] -- Add 1 to include the last character

  local lines = vim.fn.getline(start_line, end_line)

  -- If there's only one line selected
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    -- Trim the first and last line to the correct column range
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  local io = require("io")

  local fOutput = io.popen("cat ~/.pacenv")
  local zkenv = fOutput:read('*all')
  zkenv = zkenv:gsub("\n", "")
  fOutput:close()

  fOutput = io.popen("callzkfetch '" .. table.concat(lines) .. "'")
  local zkvalue = fOutput:read('*all')
  print(zkenv .. ": " .. zkvalue)
  fOutput:close()

end

return F
