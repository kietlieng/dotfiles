local F = {}

function F.CloseBufferOrVim(aSave)

  local len = 0
  --print(vim.opt)
  --local options_listed = vim.opt.listed
  local vim_fn = vim.fn
  local buflisted = vim_fn.buflisted

  -- if more than 1 buffer close the current buffer only.  Otherwise close vim
  for buffer = 1, vim_fn.bufnr('$') do
    --if not options_listed or buflisted(buffer) ~= 1 then
    if not buflisted(buffer) ~= 1 then
      len = len + 1
    end
  end

  if len > 1 then

    if aSave > 0 then
      vim.cmd([[:bw]])
    else
      vim.cmd([[:bd!]])
    end

  else

    if aSave > 0 then
      vim.cmd([[:wq!]])
    else
      vim.cmd([[:q!]])
    end

  end

end

return F
