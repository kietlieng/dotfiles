local F = {}

function F.setup()

  vim.cmd([[

    highlight Normal ctermbg=NONE ctermfg=NONE guibg=NONE
    highlight ColorColumn ctermfg=NONE ctermbg=NONE guibg=NONE
    highlight clear SignColumn
    highlight TabLineFill ctermfg=NONE ctermbg=NONE
    highlight TabLine ctermfg=NONE ctermbg=NONE
    highlight TabLineSel ctermfg=NONE ctermbg=NONE
    highlight StatusLine ctermbg=NONE ctermfg=NONE

  ]])
end


return F
