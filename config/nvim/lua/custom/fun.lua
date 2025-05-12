local F = {}

function F.setup()

  vim.keymap.set("n", "<leader><space>rain", "<cmd>CellularAutomaton make_it_rain<CR>")
  vim.keymap.set("n", "<leader><space>life", "<cmd>CellularAutomaton game_of_life<CR>")

end

return F
