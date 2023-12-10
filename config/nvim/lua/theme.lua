local F = {}

function F.setup()

-- https://stackoverflow.com/questions/71152802/how-to-override-color-scheme-in-neovim-lua-config-file
--vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg=0, guibg=lightgrey })
----vim.api.nvim_set_hl(0, "Comment", { cterm=italic, gui=italic })
--vim.api.nvim_set_hl(0, "Comment", { cterm=strikethrough, gui=strikethrough })

  vim.cmd([[

    "" airline
    ""let g:gruvbox_improved_strings         = 1 "" high contrast string (white text / grey background). Not great if alot of strings
    ""let g:gruvbox_invert_indent_guides     = 1 "" don't use indent guides
    ""let g:gruvbox_invert_signs             = 1 "" too jarring
    ""let g:gruvbox_material_background      = 'hard' "" hard / medium / soft
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_section_y                  = airline#section#create_left(['path'])
    let g:airline_theme                      = 'gruvbox'
    let g:gruvbox_bold                       = 1
    let g:gruvbox_contrast_dark              = 'hard'
    let g:gruvbox_improved_warnings          = 1
    let g:gruvbox_invert_tabline             = 1
    let g:gruvbox_italic                     = 1
    let g:gruvbox_italicize_strings          = 1

  ]])

  ---- onedark theme
  --require("onedarkpro").setup({
  --  highlights = {
  --    Error = {
  --      underline = false,
  --    },
  --  }
  --})

  --vim.cmd.colorscheme "catppuccin" -- catppuccin / catppuccin-latte / catppuccin-frappe / catppuccin-macchiato / catppuccin-mocha
  --vim.cmd.colorscheme "challenger_deep"
  --vim.cmd.colorscheme "gruvbox-material"
  --vim.cmd.colorscheme "challenger_deep"
  --vim.cmd.colorscheme "oceanic_material"
  --require('colorbuddy').colorscheme('gruvbuddy')
  --vim.cmd.colorscheme "onedark_dark" -- onedark / onelight / onedark_vivid / onedark_dark


  vim.opt.background = "dark" -- dark / light
  vim.cmd.colorscheme "gruvbox"

  vim.cmd([[

    ""highlight ColorColumn ctermbg=0 guibg=lightgrey

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
