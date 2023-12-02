local F = {}

function F.setup()

  vim.keymap.set("n", "<leader>urain", "<cmd>CellularAutomaton make_it_rain<CR>")
  vim.keymap.set("n", "<leader>ulife", "<cmd>CellularAutomaton game_of_life<CR>")

end

return F
