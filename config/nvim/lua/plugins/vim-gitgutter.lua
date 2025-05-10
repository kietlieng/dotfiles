-- Git gutter.  Different than fugitive
local F = {}

function F.setup()

--  vim.cmd([[ let g:gitgutter_show_msg_on_hunk_jumping = 0 ]])

end


return { 
  'airblade/vim-gitgutter', 
  config = F.setup()
}

