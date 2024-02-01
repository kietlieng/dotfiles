local F = {}

function F.setup()

  vim.keymap.set("n", "<leader>zrain", "<cmd>CellularAutomaton make_it_rain<CR>")
  vim.keymap.set("n", "<leader>zlife", "<cmd>CellularAutomaton game_of_life<CR>")

end

return F
