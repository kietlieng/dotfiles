local F = {}

function F.setup()

-- https://stackoverflow.com/questions/71152802/how-to-override-color-scheme-in-neovim-lua-config-file
--vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg=0, guibg=lightgrey })
----vim.api.nvim_set_hl(0, "Comment", { cterm=italic, gui=italic })
--vim.api.nvim_set_hl(0, "Comment", { cterm=strikethrough, gui=strikethrough })

  vim.cmd([[

    "" airline
    "" let g:airline#extensions#tabline#enabled = 1
    "" let g:airline_section_y                  = airline#section#create_left(['path'])
    "" let g:airline_theme                      = 'gruvbox-material'

    let g:oceanic_material_transparent_background = 0  "" : enable transparent background 	0:disable transparent background
    let g:oceanic_material_background             = 'darker' "" use #282c34 color as background 	ocean: #1b2b34 medium: #282C34 deep:#212112 darker:#1d1f21
    let g:oceanic_material_allow_bold             = 1 "": use bold for certain text 	0: not at all
    let g:oceanic_material_allow_italic           = 1 "": use italic for certain text 	0: not at all
    let g:oceanic_material_allow_underline        = 1 "": use underline for certain text 	0: not at all
    let g:oceanic_material_allow_undercurl        = 1 "": use undercurl for certain text 	0: not at all
    let g:oceanic_material_allow_reverse          = 1 "": use reverse for certain text 	0: not at all

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
  vim.cmd.colorscheme "gruvbox_material"

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
