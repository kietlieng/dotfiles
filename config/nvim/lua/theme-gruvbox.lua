local F = {}

function F.setup()

  vim.cmd([[

    ""let g:gruvbox_improved_strings         = 1 "" high contrast string (white text / grey background). Not great if alot of strings
    ""let g:gruvbox_invert_indent_guides     = 1 "" don't use indent guides
    ""let g:gruvbox_invert_signs             = 1 "" too jarring
    let g:gruvbox_bold                       = 1
    let g:gruvbox_contrast_dark              = 'hard'
    let g:gruvbox_improved_warnings          = 1
    let g:gruvbox_invert_tabline             = 1
    let g:gruvbox_italic                     = 1
    let g:gruvbox_italicize_strings          = 1

  ]])

  vim.opt.background = "dark" -- dark / light
  vim.cmd.colorscheme "gruvbox"

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
