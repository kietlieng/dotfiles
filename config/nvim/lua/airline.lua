local F = {}

function F.setup()

  vim.cmd([[

    "" airline
    ""let g:gruvbox_improved_strings         = 1 "" high contrast string (white text / grey background). Not great if alot of strings
    ""let g:gruvbox_invert_indent_guides     = 1 "" don't use indent guides
    ""let g:gruvbox_invert_signs             = 1 "" too jarring
    ""let g:gruvbox_material_background      = 'hard' "" hard / medium / soft
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_section_y                  = airline#section#create_left(['path'])
    let g:airline_theme                      = 'gruvbox'

  ]])

end


return F
