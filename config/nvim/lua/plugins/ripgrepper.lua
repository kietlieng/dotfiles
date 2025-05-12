local F = {}

function F.setup()


  vim.cmd([[

  let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'
  let g:rg_highlight = 'true'
  let @r = expand('%:p:h') "" need to register r to be set first

  "" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" original bang command "" command just searches only current working directory
  "" command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>) . " " . @r, 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" new bang command that searches the current file directory or register r.  This allows for us to change the register value to whatever we want

  command! -bang -nargs=* Rg call fzf#vim#grep("rg --column -i --context 4 --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>) . " " . @r, 1, { "options": '--delimiter : --nth 4..' }, <bang>0) "" new bang command that searches the current file directory or register r.  This allows for us to change the register value to whatever we want
  ]])

end

function F.grepLevel(fLevel)

  if fLevel == -2 then

    vim.fn.setreg('r', vim.fn.getcwd()) -- rest register to current working directory

  elseif fLevel == -1 then -- from get root

    local currentRepo = vim.fn.expand('%:p:h')
    local io = require("io")
    local fOutput = io.popen("cd " .. currentRepo .. "; callgitrootfolder")
    local gitRoot = fOutput:read('*all')

    vim.fn.setreg('r', gitRoot) -- figure out the git root and set the r register to that

  else

    local dirExpression = '%:p:h'
    local aDepth = fLevel

    while aDepth > 0 do

      dirExpression = dirExpression .. ':h'
      aDepth = aDepth - 1

    end

    vim.fn.setreg('r', vim.fn.expand(dirExpression)) -- if not expand on `%:p:h' and set register to that

  end

  vim.cmd([[Rg]]) -- run the command to get the rip grepper using register

end


return {
  'jremmen/vim-ripgrep',
  config = F.setup(),
}

