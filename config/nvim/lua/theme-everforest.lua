local F = {}

function F.setup()

  vim.cmd([[

    let g:everforest_background = 'hard'

  ]])

  vim.opt.background = "dark" -- dark / light
  vim.cmd.colorscheme "everforest"

  vim.cmd([[

    highlight Normal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
    highlight ColorColumn ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
    highlight clear SignColumn
    highlight TabLineFill ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
    highlight TabLine ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
    highlight TabLineSel ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE
    highlight StatusLine ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

  ]])
--    highlight Search ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
--    highlight Comment ctermfg=NONE ctermbg=NONE
end


return F
