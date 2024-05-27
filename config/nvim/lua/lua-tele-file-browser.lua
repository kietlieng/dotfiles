local F = {}

function waitForInput(n)
  os.execute("sleep " .. tonumber(n))
end

function F.setup()

  -- telescope do nothing
  require("telescope").load_extension "file_browser"

end

function F.browse()

  targetFile = require('telescope.builtin').find_files { cwd = '/tmp' }
--  print("print out target" .. targetFile)
--  if targetFile ~= nil then
--    vim.cmd.normal(':r ' .. targetFile)
--  end

end

function F.getInput()


end

return F
